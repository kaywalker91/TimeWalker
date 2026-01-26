import 'package:time_walker/domain/entities/achievement.dart';

abstract class AchievementRepository {
  List<Achievement> getAllAchievements();
  List<Achievement> getQuizAchievements();
  List<Achievement> getAchievementsByCategory(AchievementCategory category);
  Achievement? getById(String id);
}
