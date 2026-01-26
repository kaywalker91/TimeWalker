import 'package:time_walker/domain/entities/user_progress.dart';

abstract class UserProgressFactory {
  UserProgress initial(String userId);
  UserProgress debugAllUnlocked(String userId);
}
