import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/services/achievement_service.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

final achievementServiceProvider = Provider<AchievementService>((ref) {
  final repository = ref.watch(achievementRepositoryProvider);
  return AchievementService(repository);
});

class AchievementNotifier extends StateNotifier<List<AchievementUnlockResult>> {
  AchievementNotifier() : super([]);

  void addUnlockedAchievements(List<Achievement> achievements) {
    if (achievements.isEmpty) return;

    final now = DateTime.now();
    final results = achievements
        .map((a) => AchievementUnlockResult(
              achievement: a,
              bonusPoints: a.bonusPoints,
              unlockedAt: now,
            ))
        .toList();

    state = [...state, ...results];
  }

  void dismissFirst() {
    if (state.isNotEmpty) {
      state = state.sublist(1);
    }
  }

  void dismissAll() {
    state = [];
  }

  bool get hasPending => state.isNotEmpty;
}

final achievementNotifierProvider =
    StateNotifierProvider<AchievementNotifier, List<AchievementUnlockResult>>((ref) {
  return AchievementNotifier();
});
