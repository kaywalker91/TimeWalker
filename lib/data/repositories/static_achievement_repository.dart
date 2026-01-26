import 'package:time_walker/data/datasources/static/achievement_data.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/repositories/achievement_repository.dart';

class StaticAchievementRepository implements AchievementRepository {
  @override
  List<Achievement> getAllAchievements() {
    return AchievementData.all;
  }

  @override
  List<Achievement> getQuizAchievements() {
    return AchievementData.quizAchievements;
  }

  @override
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return AchievementData.getByCategory(category);
  }

  @override
  Achievement? getById(String id) {
    return AchievementData.getById(id);
  }
}
