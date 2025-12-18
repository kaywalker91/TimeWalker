import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

class MockUserProgressRepository implements UserProgressRepository {
  // Simulating a DB
  UserProgress _progress = const UserProgress(
    oderId: 'user_001',
    rank: ExplorerRank.novice,
    unlockedRegionIds: ['asia', 'europe', 'africa', 'americas', 'middle_east'],
    unlockedCountryIds: [
      'korea', 'china', 'japan', 'india', 'mongolia', // Asia
      'greece', 'rome', 'britain', 'france', 'germany', // Europe
      'egypt', 'ethiopia', 'mali', // Africa
      'maya', 'aztec', 'inca', 'usa', // Americas
      'mesopotamia', 'persia', 'ottoman', // Middle East
      'italy', // Extra
    ],
    unlockedEraIds: [
      'korea_three_kingdoms',
      'korea_goryeo',
      'korea_joseon',
      'europe_renaissance',
    ],
  );

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Force return fresh object for Hot Reload to take effect immediately
    return _progress;
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _progress = progress;
  }
}
