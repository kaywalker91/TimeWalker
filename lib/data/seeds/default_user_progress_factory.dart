import 'package:time_walker/data/seeds/user_progress_seed.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';

class DefaultUserProgressFactory implements UserProgressFactory {
  @override
  UserProgress initial(String userId) {
    return UserProgressSeed.initial(userId);
  }

  @override
  UserProgress debugAllUnlocked(String userId) {
    return UserProgressSeed.debugAllUnlocked(userId);
  }
}
