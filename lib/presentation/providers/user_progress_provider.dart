import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/app_durations.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';
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
      final eraRepository = ref.watch(eraRepositoryProvider);
      final countryRepository = ref.watch(countryRepositoryProvider);
      final regionRepository = ref.watch(regionRepositoryProvider);
      final factory = ref.watch(userProgressFactoryProvider);
      return UserProgressNotifier(
        repository,
        progressionService,
        eraRepository,
        countryRepository,
        regionRepository,
        factory,
      );
    });

/// 사용자 진행 상태를 관리하는 StateNotifier
class UserProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  final UserProgressRepository _repository;
  final ProgressionService _progressionService;
  final EraRepository _eraRepository;
  final CountryRepository _countryRepository;
  final RegionRepository _regionRepository;
  final UserProgressFactory _factory;
  UnlockContent? _cachedUnlockContent;
  
  // 디바운싱 저장을 위한 타이머
  Timer? _saveTimer;
  UserProgress? _pendingSave;
  static const _saveDebounceDuration = AppDurations.saveDebounce;

  UserProgressNotifier(
    this._repository,
    this._progressionService,
    this._eraRepository,
    this._countryRepository,
    this._regionRepository,
    this._factory,
  ) : super(const AsyncLoading()) {
    _loadProgress();
  }
  
  @override
  void dispose() {
    // 보류 중인 저장 작업 즉시 실행
    _flushPendingSave();
    _saveTimer?.cancel();
    super.dispose();
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
        final newProgress = _factory.initial('user_001');
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
      final unlockContent = await _loadUnlockContent();
      final unlocks = _progressionService.checkUnlocks(
        updated,
        content: unlockContent,
      );

      // 3. Apply unlocks using ProgressionService (single source of truth)
      updated = _progressionService.applyUnlocks(updated, unlocks);

      // 디바운싱 저장 (빈번한 업데이트 최적화)
      _scheduleSave(updated);

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
      
      // 즉시 저장 (인벤토리 변경은 중요)
      await _saveImmediately(updated);
      
      if (!mounted) return false;
      state = AsyncData(updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Admin Mode: Unlock all content for testing
  Future<void> unlockAllContent() async {
    if (!state.hasValue) return;
    final current = state.value!;
    
    try {
      final unlockedProgress = _factory.debugAllUnlocked(current.userId);
      // Keep existing inventory if needed, or just overwrite. 
      // For pure admin mode, overwriting is fine, but maybe preserve settings?
      // Let's just use the seed as is for now as it gives max resources.
      
      // 즉시 저장 (관리자 모드는 즉시 반영)
      await _saveImmediately(unlockedProgress);
      
      if (!mounted) return;
      state = AsyncData(unlockedProgress);
    } catch (e, stack) {
      if (mounted) state = AsyncError(e, stack);
    }
  }

  Future<UnlockContent> _loadUnlockContent() async {
    final cached = _cachedUnlockContent;
    if (cached != null) return cached;

    final eras = await _eraRepository.getAllEras();
    final countries = await _countryRepository.getAllCountries();
    final regions = await _regionRepository.getAllRegions();
    final regionById = {
      for (final region in regions) region.id: region,
    };

    final content = UnlockContent(
      eras: eras,
      countries: countries,
      regionsById: regionById,
    );
    _cachedUnlockContent = content;
    return content;
  }
  
  // ============== 디바운싱 저장 메서드 ==============
  
  /// 디바운싱된 저장 - 500ms 내 중복 호출은 무시하고 마지막 상태만 저장
  void _scheduleSave(UserProgress progress) {
    _pendingSave = progress;
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDebounceDuration, () {
      _flushPendingSave();
    });
  }
  
  /// 보류 중인 저장 즉시 실행
  void _flushPendingSave() {
    final pending = _pendingSave;
    if (pending != null) {
      _pendingSave = null;
      _repository.saveUserProgress(pending).catchError((e) {
        debugPrint('[UserProgressNotifier] Save error: $e');
      });
    }
  }
  
  /// 즉시 저장 (중요한 변경사항용)
  Future<void> _saveImmediately(UserProgress progress) async {
    _saveTimer?.cancel();
    _pendingSave = null;
    await _repository.saveUserProgress(progress);
  }
}
