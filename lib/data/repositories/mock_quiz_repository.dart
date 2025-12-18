import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class MockQuizRepository implements QuizRepository {
  List<Quiz> _quizzes = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/quizzes.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _quizzes = jsonList.map((e) => Quiz.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log
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
}
