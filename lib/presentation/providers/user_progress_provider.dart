import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== User Progress Provider ==============

/// 사용자 진행 상태 불러오기
/// StreamProvider가 더 적합할 수 있으나 MVP는 Future/Notifier 조합 사용
final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, AsyncValue<UserProgress>>((
      ref,
    ) {
      final repository = ref.watch(userProgressRepositoryProvider);
      final progressionService = ref.watch(progressionServiceProvider);
      return UserProgressNotifier(repository, progressionService);
    });

/// 사용자 진행 상태를 관리하는 StateNotifier
class UserProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  final UserProgressRepository _repository;
  final ProgressionService _progressionService;

  UserProgressNotifier(this._repository, this._progressionService)
      : super(const AsyncLoading()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final progress = await _repository.getUserProgress(
        'user_001',
      ); // Fixed user ID for MVP
      if (progress != null) {
        state = AsyncData(progress);
      } else {
        // Create new if null
        const newProgress = UserProgress(oderId: 'user_001');
        await _repository.saveUserProgress(newProgress);
        state = const AsyncData(newProgress);
      }
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  /// 진행 상태를 업데이트하고 해금 이벤트를 반환
  Future<List<UnlockEvent>> updateProgress(
    UserProgress Function(UserProgress) updateFn,
  ) async {
    // Return empty list if current state is not loaded
    if (!state.hasValue) return [];

    final currentProgress = state.value!;
    try {
      // 1. Calculate base update (e.g., adding knowledge points)
      var updated = updateFn(currentProgress);

      // 2. Check for new unlocks using the service
      final unlocks = _progressionService.checkUnlocks(updated);

      // 3. Apply unlocks to the state if any found
      if (unlocks.isNotEmpty) {
        final newEraIds = List<String>.from(updated.unlockedEraIds);
        ExplorerRank? newRank;

        for (final event in unlocks) {
          if (event.type == UnlockType.era && !newEraIds.contains(event.id)) {
            newEraIds.add(event.id);
          } else if (event.type == UnlockType.rank) {
            try {
              newRank = ExplorerRank.values.firstWhere(
                (e) => e.name == event.id,
              );
            } catch (_) {}
          }
        }

        updated = updated.copyWith(
          unlockedEraIds: newEraIds,
          rank: newRank ?? updated.rank,
        );
      }

      await _repository.saveUserProgress(updated);
      state = AsyncData(updated);
      return unlocks;
    } catch (e, _) {
      return [];
    }
  }
}
