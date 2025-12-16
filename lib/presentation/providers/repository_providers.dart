import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/data/repositories/mock_country_repository.dart';
import 'package:time_walker/data/repositories/mock_era_repository.dart';
import 'package:time_walker/data/repositories/mock_region_repository.dart';
import 'package:time_walker/data/repositories/mock_location_repository.dart';
import 'package:time_walker/data/repositories/mock_character_repository.dart';
import 'package:time_walker/data/repositories/mock_dialogue_repository.dart';
import 'package:time_walker/data/repositories/mock_user_progress_repository.dart'; // Added
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/user_progress.dart'; // Added
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart'; // Added
import 'package:time_walker/domain/services/progression_service.dart';

import '../../core/constants/exploration_config.dart'; // Added

// ============== Repository Providers ==============

/// Region Repository Provider
final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return MockRegionRepository();
});

/// Era Repository Provider
final eraRepositoryProvider = Provider<EraRepository>((ref) {
  return MockEraRepository();
});

/// Country Repository Provider
final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return MockCountryRepository();
});

/// Location Repository Provider
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});

/// Character Repository Provider
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return MockCharacterRepository();
});

/// Dialogue Repository Provider
final dialogueRepositoryProvider = Provider<DialogueRepository>((ref) {
  return MockDialogueRepository();
});

/// UserProgress Repository Provider
final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return MockUserProgressRepository();
});

/// Progression Service Provider
final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService();
});

// ============== Future Providers for Data Fetching ==============

/// 사용자 진행 상태 불러오기 (StreamProvider가 더 적합할 수 있으나 MVP는 Future/Notifier 조합 사용)
final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, AsyncValue<UserProgress>>((
      ref,
    ) {
      final repository = ref.watch(userProgressRepositoryProvider);
      final progressionService = ref.watch(progressionServiceProvider);
      return UserProgressNotifier(repository, progressionService);
    });

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
        // Add other types if needed (regions, etc.)

        for (final event in unlocks) {
          if (event.type == UnlockType.era &&
              !newEraIds.contains(event.id)) {
            newEraIds.add(event.id);
          }
           // Handle other types here (Rank is just property, Region is List)
        }

        updated = updated.copyWith(
          unlockedEraIds: newEraIds,
          // Rank is derived from knowledge, so checkUnlocks just reports it.
          // However, UserProgress entity stores 'rank'. We should update it.
          rank: _progressionService.checkUnlocks(updated).fold(
                updated.rank,
                (currentRank, event) {
                  if (event.type == UnlockType.rank) {
                    // This is bit tricky as event just has ID/Name.
                    // Ideally checkUnlocks logic should be separate or
                    // we re-calculate rank here based on totalKnowledge.
                    // For MVP simplicity, let's just recalculate rank using knowledge
                    // or trust the Service logic if we move "calculateRank" to public.
                    // Let's rely on totalKnowledge for rank source of truth.
                    return updated.rank; // Placeholder, see logic below
                  }
                  return currentRank;
                },
              ),
        );
        
        // Re-evaluate Rank explicitly to be safe as it's a derived property effectively
        // We can expose the helper from service or just let the entity logic handle it?
        // UserProgress logic:
        // Actually, UserProgress object has 'rank' field.
        // Let's defer to a cleaner implementation:
        // inside updateFn, the caller might have updated knowledge.
        // We should recalculate rank based on that knowledge.
        // But since we want to return EVENTS, we need to know if it changed.
        
        // Let's do a simple rank update based on config here (duplicating service logic slightly or making it public static)
        // Or better: updateFn does its thing. checkUnlocks reports events.
        // We update the UserProgress with the consequences (Era IDs).
        // Rank update:
        // The Service detected a Rank event? Then we update the rank field.
        for (final event in unlocks) {
             if (event.type == UnlockType.rank) {
               // Find enum by name match since event.id is enum name
                try {
                  final newRank = ExplorerRank.values.firstWhere((e) => e.name == event.id);
                  updated = updated.copyWith(rank: newRank);
                } catch (_) {}
             }
        }
      }

      await _repository.saveUserProgress(updated);
      state = AsyncData(updated);
      return unlocks;
    } catch (e, stack) {
      // state = AsyncError(e, stack);
      return [];
    }
  }
}

/// 모든 지역 목록 불러오기
final regionListProvider = FutureProvider((ref) async {
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getAllRegions();
});

/// 지역 ID로 지역 정보 불러오기
final regionByIdProvider = FutureProvider.family<Region?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getRegionById(id);
});

/// 특정 국가의 시대 목록 불러오기
final eraListByCountryProvider = FutureProvider.family<List<Era>, String>((
  ref,
  countryId,
) async {
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getErasByCountry(countryId);
});

/// 시대 ID로 시대 정보 불러오기
final eraByIdProvider = FutureProvider.family<Era?, String>((ref, id) async {
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getEraById(id);
});

/// 특정 지역의 국가 목록 불러오기
final countryListByRegionProvider =
    FutureProvider.family<List<Country>, String>((ref, regionId) async {
      final repository = ref.watch(countryRepositoryProvider);
      return repository.getCountriesByRegion(regionId);
    });

/// 국가 ID로 국가 정보 불러오기
final countryByIdProvider = FutureProvider.family<Country?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(countryRepositoryProvider);
  return repository.getCountryById(id);
});

/// 시대별 장소 목록 불러오기
final locationListByEraProvider = FutureProvider.family<List<Location>, String>(
  (ref, eraId) async {
    final repository = ref.watch(locationRepositoryProvider);
    return repository.getLocationsByEra(eraId);
  },
);

/// 시대별 인물 목록 불러오기
final characterListByEraProvider =
    FutureProvider.family<List<Character>, String>((ref, eraId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByEra(eraId);
    });

/// 장소별 인물 목록 불러오기 (해당 장수와 관련된 인물)
final characterListByLocationProvider =
    FutureProvider.family<List<Character>, String>((ref, locationId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByLocation(locationId);
    });

/// 인물별 대화 목록 불러오기
final dialogueListByCharacterProvider =
    FutureProvider.family<List<Dialogue>, String>((ref, characterId) async {
      final repository = ref.watch(dialogueRepositoryProvider);
      return repository.getDialoguesByCharacter(characterId);
    });

/// 대화 ID로 대화 정보 불러오기
final dialogueByIdProvider = FutureProvider.family<Dialogue?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(dialogueRepositoryProvider);
  return repository.getDialogueById(id);
});
