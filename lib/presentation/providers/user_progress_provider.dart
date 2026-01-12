import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/data/seeds/user_progress_seed.dart';
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
      
      if (!mounted) return;

      if (progress != null) {
        state = AsyncData(progress);
      } else {
        // Create new if null
        final newProgress = UserProgressSeed.initial('user_001');
        await _repository.saveUserProgress(newProgress);
        
        if (!mounted) return;
        state = AsyncData(newProgress);
      }
    } catch (e, stack) {
      if (mounted) state = AsyncError(e, stack);
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
        final newCountryIds = List<String>.from(updated.unlockedCountryIds);
        final newRegionIds = List<String>.from(updated.unlockedRegionIds);
        ExplorerRank? newRank;

        for (final event in unlocks) {
          if (event.type == UnlockType.era && !newEraIds.contains(event.id)) {
            newEraIds.add(event.id);
          } else if (event.type == UnlockType.country &&
              !newCountryIds.contains(event.id)) {
            newCountryIds.add(event.id);
          } else if (event.type == UnlockType.region &&
              !newRegionIds.contains(event.id)) {
            newRegionIds.add(event.id);
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
          unlockedCountryIds: newCountryIds,
          unlockedRegionIds: newRegionIds,
          rank: newRank ?? updated.rank,
        );
      }

      await _repository.saveUserProgress(updated);
      
      if (!mounted) return [];
      state = AsyncData(updated);
      return unlocks;
    } catch (e, _) {
      return [];
    }
  }

  /// 아이템 사용 (소모)
  /// 인벤토리에서 해당 아이템 ID를 하나 제거합니다. 성공 시 true 반환.
  Future<bool> consumeItem(String itemId) async {
    if (!state.hasValue) return false;
    final current = state.value!;
    
    // 아이템 보유 여부 확인
    if (!current.inventoryIds.contains(itemId)) return false;
    
    try {
      final newInventory = List<String>.from(current.inventoryIds);
      // 첫 번째 일치하는 아이템만 제거 (소모품 1개 사용)
      newInventory.remove(itemId); 
      
      final updated = current.copyWith(inventoryIds: newInventory);
      
      await _repository.saveUserProgress(updated);
      
      if (!mounted) return false;
      state = AsyncData(updated);
      return true;
    } catch (e) {
      return false;
    }
  }
}
