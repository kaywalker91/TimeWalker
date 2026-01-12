import 'package:time_walker/domain/entities/user_progress.dart';

/// 사용자 진행 상태 관리를 위한 Repository 인터페이스
/// 
/// 사용자의 게임 진행 상태(해금된 시대, 완료한 대화, 지식 포인트 등)를
/// 저장하고 불러오는 기능을 정의합니다.
/// 
/// ## 구현체
/// - [HiveUserProgressRepository] - Hive 로컬 저장소 사용
/// 
/// ## 사용 예시
/// ```dart
/// final repository = ref.read(userProgressRepositoryProvider);
/// 
/// // 진행 상태 불러오기
/// final progress = await repository.getUserProgress('user_123');
/// 
/// // 진행 상태 저장하기
/// final updated = progress?.copyWith(totalKnowledge: 1500);
/// await repository.saveUserProgress(updated!);
/// ```
/// 
/// ## 주의사항
/// - [getUserProgress]가 null을 반환하는 경우, 신규 사용자로 간주합니다.
/// - [saveUserProgress]는 기존 데이터를 덮어씁니다 (upsert 동작).
/// 
/// See also:
/// - [UserProgress] - 진행 상태 엔티티
/// - [ProgressionService] - 해금 로직을 담당하는 도메인 서비스
abstract class UserProgressRepository {
  /// 사용자 진행 상태를 불러옵니다.
  /// 
  /// [userId] 사용자 고유 식별자
  /// 
  /// Returns:
  /// - [UserProgress] 저장된 진행 상태
  /// - `null` 저장된 데이터가 없는 경우 (신규 사용자)
  /// 
  /// Throws:
  /// - [DataException] 데이터 로드 실패 시
  Future<UserProgress?> getUserProgress(String userId);

  /// 사용자 진행 상태를 저장합니다.
  /// 
  /// 기존 데이터가 있으면 덮어쓰고, 없으면 새로 생성합니다.
  /// 
  /// [progress] 저장할 진행 상태 객체
  /// 
  /// Throws:
  /// - [DataException] 데이터 저장 실패 시
  Future<void> saveUserProgress(UserProgress progress);
}
