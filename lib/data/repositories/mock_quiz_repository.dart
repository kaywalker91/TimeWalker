import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/repositories/quiz_repository.dart';

class MockQuizRepository implements QuizRepository {
  List<Quiz> _quizzes = [];
  List<QuizCategory> _categories = [];
  Map<String, List<Quiz>> _quizzesByCategory = {};
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/quizzes.json');
      final dynamic jsonResponse = jsonDecode(jsonString);
      
      if (jsonResponse is List) {
        _quizzes = jsonResponse.map((e) => Quiz.fromJson(e)).toList();
      } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('categories')) {
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
      
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log
      debugPrint('Error loading quizzes: $e');
      _quizzes = [];
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
