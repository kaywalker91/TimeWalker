import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<List<Quiz>> getAllQuizzes();
  Future<List<Quiz>> getQuizzesByEra(String eraId);
  Future<List<Quiz>> getQuizzesByDifficulty(QuizDifficulty difficulty);
  Future<Quiz?> getQuizById(String id);
}
