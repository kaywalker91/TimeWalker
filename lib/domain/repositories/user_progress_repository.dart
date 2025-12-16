import 'package:time_walker/domain/entities/user_progress.dart';

abstract class UserProgressRepository {
  /// 사용자 진행 상태 불러오기
  Future<UserProgress?> getUserProgress(String userId);

  /// 사용자 진행 상태 저장하기
  Future<void> saveUserProgress(UserProgress progress);
}
