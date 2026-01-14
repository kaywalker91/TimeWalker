import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/supabase_mapping_utils.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/domain/entities/quiz_category.dart';
import 'package:time_walker/domain/repositories/quiz_repository.dart';

class SupabaseQuizRepository implements QuizRepository {
  SupabaseQuizRepository(this._client, this._loader);

  final SupabaseClient _client;
  final SupabaseContentLoader _loader;

  List<Quiz> _quizzes = [];
  List<QuizCategory> _categories = [];
  Map<String, List<Quiz>> _quizzesByCategory = {};
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      await _loadFromSupabase();
    } catch (_) {
      await _loadFromAssets();
    }
    _isLoaded = true;
  }

  Future<void> _loadFromSupabase() async {
    final categoryRows = await _loader.loadList(
      dataset: 'quiz_categories',
      fetchRemote: () async {
        final response = await _client
            .from('quiz_categories')
            .select()
            .order('sort_order');
        return List<Map<String, dynamic>>.from(response as List);
      },
      transform: _mapCategoryRow,
    );

    final quizRows = await _loader.loadList(
      dataset: 'quizzes',
      fetchRemote: () async {
        final response = await _client.from('quizzes').select();
        return List<Map<String, dynamic>>.from(response as List);
      },
      transform: _mapQuizRow,
    );

    _categories = categoryRows.map((e) => QuizCategory.fromJson(e)).toList();
    _quizzes = [];
    _quizzesByCategory = {};

    for (final quizJson in quizRows) {
      final quiz = Quiz.fromJson(quizJson);
      _quizzes.add(quiz);
      final categoryId = quizJson['categoryId'] as String?;
      if (categoryId != null) {
        _quizzesByCategory.putIfAbsent(categoryId, () => []).add(quiz);
      }
    }
  }

  Future<void> _loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/quizzes.json');
    final dynamic jsonResponse = jsonDecode(jsonString);

    if (jsonResponse is List) {
      _quizzes = jsonResponse.map((e) => Quiz.fromJson(e)).toList();
      _categories = [];
      _quizzesByCategory = {};
      return;
    }

    if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('categories')) {
      final categories = jsonResponse['categories'] as List;
      _quizzes = [];
      _categories = [];
      _quizzesByCategory = {};

      for (final categoryJson in categories) {
        final category = QuizCategory.fromJson(categoryJson);
        _categories.add(category);

        final quizzesJson = categoryJson['quizzes'] as List;
        final quizzes = quizzesJson.map((e) => Quiz.fromJson(e)).toList();

        _quizzesByCategory[category.id] = quizzes;
        _quizzes.addAll(quizzes);
      }
    }
  }

  @override
  Future<List<Quiz>> getAllQuizzes() async {
    await _ensureLoaded();
    return _quizzes;
  }

  @override
  Future<List<Quiz>> getQuizzesByEra(String eraId) async {
    await _ensureLoaded();
    return _quizzes.where((q) => q.eraId == eraId).toList();
  }

  @override
  Future<List<Quiz>> getQuizzesByDifficulty(QuizDifficulty difficulty) async {
    await _ensureLoaded();
    return _quizzes.where((q) => q.difficulty == difficulty).toList();
  }

  @override
  Future<Quiz?> getQuizById(String id) async {
    await _ensureLoaded();
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<QuizCategory>> getQuizCategories() async {
    await _ensureLoaded();
    return _categories;
  }

  @override
  Future<List<Quiz>> getQuizzesByCategory(String categoryId) async {
    await _ensureLoaded();
    return _quizzesByCategory[categoryId] ?? [];
  }

  @override
  Future<List<Quiz>> getQuizzesByDialogueId(String dialogueId) async {
    await _ensureLoaded();
    return _quizzes.where((q) => q.relatedDialogueId == dialogueId).toList();
  }
}

Map<String, dynamic> _mapCategoryRow(Map<String, dynamic> row) {
  return {
    'id': row['id'],
    'title': row['title'],
    'description': row['description'],
  };
}

Map<String, dynamic> _mapQuizRow(Map<String, dynamic> row) {
  return {
    'id': row['id'],
    'question': row['question'],
    'type': row['type'],
    'difficulty': row['difficulty'],
    'options': stringList(row['options']),
    'correctAnswer': row['correct_answer'],
    'explanation': row['explanation'],
    'imageAsset': row['image_asset'],
    'eraId': row['era_id'],
    'relatedFactId': row['related_fact_id'],
    'relatedDialogueId': row['related_dialogue_id'],
    'relatedCharacterId': row['related_character_id'],
    'relatedLocationId': row['related_location_id'],
    'basePoints': intOrNull(row['base_points']) ?? 10,
    'timeLimitSeconds': intOrNull(row['time_limit_seconds']) ?? 30,
    'categoryId': row['category_id'],
  };
}
