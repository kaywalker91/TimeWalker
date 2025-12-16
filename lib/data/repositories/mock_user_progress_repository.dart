import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

class MockUserProgressRepository implements UserProgressRepository {
  // Simulating a DB
  UserProgress _progress = const UserProgress(
    oderId: 'user_001',
    rank: ExplorerRank.novice,
    unlockedEraIds: [
      'korea_three_kingdoms',
      'korea_goryeo',
      'korea_joseon',
    ], // Unlock Goryeo and Joseon for testing
  );

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _progress;
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _progress = progress;
  }
}
