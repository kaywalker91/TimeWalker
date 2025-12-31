import '../entities/quiz.dart';
import '../entities/quiz_category.dart';

abstract class QuizRepository {
  Future<List<Quiz>> getAllQuizzes();
  Future<List<Quiz>> getQuizzesByEra(String eraId);
  Future<List<Quiz>> getQuizzesByDifficulty(QuizDifficulty difficulty);
  Future<Quiz?> getQuizById(String id);
  Future<List<QuizCategory>> getQuizCategories();
  Future<List<Quiz>> getQuizzesByCategory(String categoryId);
  Future<List<Quiz>> getQuizzesByDialogueId(String dialogueId); // 대화 연관 퀴즈 조회
}
