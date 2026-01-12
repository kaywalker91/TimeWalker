import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

/// 사용자 기본 프로필 정보
///
/// UserProgress에서 분리된 사용자 기본 정보를 담는 엔티티입니다.
/// Single Responsibility Principle을 준수하기 위해 분리되었습니다.
///
/// ## 포함 정보
/// - 사용자 식별 정보 (userId)
/// - 등급 및 화폐 정보 (rank, coins)
/// - 로그인 관련 정보 (loginStreak, lastPlayedAt)
/// - 튜토리얼 및 플레이 시간 정보
///
/// ## 사용 예시
/// ```dart
/// final profile = UserProfile(
///   userId: 'user123',
///   rank: ExplorerRank.explorer,
///   coins: 1000,
///   loginStreak: 5,
/// );
/// ```
class UserProfile extends Equatable {
  /// 사용자 고유 ID
  final String userId;

  /// 탐험가 등급
  final ExplorerRank rank;

  /// 보유 코인 (화폐)
  final int coins;

  /// 연속 로그인 일수
  final int loginStreak;

  /// 마지막 플레이 시간
  final DateTime? lastPlayedAt;

  /// 마지막으로 플레이한 시대 ID
  final String? lastPlayedEraId;

  /// 총 플레이 시간 (분)
  final int totalPlayTimeMinutes;

  /// 튜토리얼 완료 여부
  final bool hasCompletedTutorial;

  /// 보유 아이템 목록
  final List<String> inventoryIds;

  const UserProfile({
    required this.userId,
    this.rank = ExplorerRank.novice,
    this.coins = 0,
    this.loginStreak = 0,
    this.lastPlayedAt,
    this.lastPlayedEraId,
    this.totalPlayTimeMinutes = 0,
    this.hasCompletedTutorial = false,
    this.inventoryIds = const [],
  });

  /// 복사본 생성
  UserProfile copyWith({
    String? userId,
    ExplorerRank? rank,
    int? coins,
    int? loginStreak,
    DateTime? lastPlayedAt,
    String? lastPlayedEraId,
    int? totalPlayTimeMinutes,
    bool? hasCompletedTutorial,
    List<String>? inventoryIds,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      rank: rank ?? this.rank,
      coins: coins ?? this.coins,
      loginStreak: loginStreak ?? this.loginStreak,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      lastPlayedEraId: lastPlayedEraId ?? this.lastPlayedEraId,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      hasCompletedTutorial: hasCompletedTutorial ?? this.hasCompletedTutorial,
      inventoryIds: inventoryIds ?? this.inventoryIds,
    );
  }

  /// 총 플레이 시간 (시:분 형식)
  String get totalPlayTimeFormatted {
    final hours = totalPlayTimeMinutes ~/ 60;
    final minutes = totalPlayTimeMinutes % 60;
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }

  /// 다음 등급까지 필요한 포인트 (totalKnowledge 필요)
  int pointsToNextRank(int totalKnowledge) {
    final thresholds = ProgressionConfig.rankThresholds;
    final ranks = ExplorerRank.values;
    final currentIndex = ranks.indexOf(rank);

    if (currentIndex >= ranks.length - 1) return 0;

    final nextRank = ranks[currentIndex + 1];
    final nextThreshold = thresholds[nextRank] ?? 0;
    return nextThreshold - totalKnowledge;
  }

  /// 현재 등급 진행률 (0.0 ~ 1.0)
  double rankProgress(int totalKnowledge) {
    final thresholds = ProgressionConfig.rankThresholds;
    final ranks = ExplorerRank.values;
    final currentIndex = ranks.indexOf(rank);

    if (currentIndex >= ranks.length - 1) return 1.0;

    final currentThreshold = thresholds[rank] ?? 0;
    final nextRank = ranks[currentIndex + 1];
    final nextThreshold = thresholds[nextRank] ?? 0;

    final range = nextThreshold - currentThreshold;
    final progress = totalKnowledge - currentThreshold;

    return range > 0 ? (progress / range).clamp(0.0, 1.0) : 0.0;
  }

  @override
  List<Object?> get props => [
        userId,
        rank,
        coins,
        loginStreak,
        lastPlayedAt,
        lastPlayedEraId,
        totalPlayTimeMinutes,
        hasCompletedTutorial,
        inventoryIds,
      ];

  @override
  String toString() => 'UserProfile(userId: $userId, rank: ${rank.displayName})';
}
