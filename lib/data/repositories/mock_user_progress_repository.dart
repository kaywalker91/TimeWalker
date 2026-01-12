import 'package:time_walker/data/seeds/user_progress_seed.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';

class MockUserProgressRepository implements UserProgressRepository {
  // Simulating a DB
  UserProgress _progress = UserProgressSeed.debugAllUnlocked('user_001');

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
