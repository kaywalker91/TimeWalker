import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

/// 사용자 진행 상태 엔티티
class UserProgress extends Equatable {
  final String oderId;
  final int totalKnowledge; // 총 역사 이해도
  final ExplorerRank rank; // 탐험가 등급
  final Map<String, double> regionProgress; // 지역별 진행률
  final Map<String, double> countryProgress; // 국가별 진행률
  final Map<String, double> eraProgress; // 시대별 진행률
  final List<String> completedDialogueIds;
  final List<String> unlockedRegionIds;
  final List<String> unlockedCountryIds;
  final List<String> unlockedEraIds;
  final List<String> unlockedCharacterIds;
  final List<String> unlockedFactIds;
  final List<String> achievementIds;
  final DateTime? lastPlayedAt;
  final String? lastPlayedEraId;
  final int totalPlayTimeMinutes;
  final int loginStreak;
  final int coins; // 보유 코인 (화폐)
  final List<String> inventoryIds; // 보유 아이템 목록
  final bool hasCompletedTutorial; // 튜토리얼 완료 여부

  const UserProgress({
    required this.oderId,
    this.totalKnowledge = 0,
    this.rank = ExplorerRank.novice,
    this.regionProgress = const {},
    this.countryProgress = const {},
    this.eraProgress = const {},
    this.completedDialogueIds = const [],
    this.unlockedRegionIds = const ['asia', 'europe'], // MVP: 아시아, 유럽 해금
    this.unlockedCountryIds = const ['korea', 'italy'], // MVP: 한국, 이탈리아 해금
    this.unlockedEraIds = const ['korea_three_kingdoms', 'korea_joseon', 'europe_renaissance'], // MVP: 삼국시대, 조선, 르네상스 해금
    this.unlockedCharacterIds = const ['encyclo_char_Q128027', 'encyclo_char_Q9319', 'gwanggaeto', 'geunchogo', 'kim_yushin', 'seondeok', 'eulji_mundeok', 'jangsu', 'gyebaek', 'uija'], // 테스트: 삼국시대 인물 해금
    this.unlockedFactIds = const ['encyclo_char_Q61073'], // 테스트: 일부 인물(도감) 해금 (뮌스터)
    this.achievementIds = const [],
    this.lastPlayedAt,
    this.lastPlayedEraId,
    this.totalPlayTimeMinutes = 0,
    this.loginStreak = 0,
    this.coins = 100, // 기본 코인 제공
    this.inventoryIds = const [],
    this.hasCompletedTutorial = false,
  });

  UserProgress copyWith({
    String? oderId,
    int? totalKnowledge,
    ExplorerRank? rank,
    Map<String, double>? regionProgress,
    Map<String, double>? countryProgress,
    Map<String, double>? eraProgress,
    List<String>? completedDialogueIds,
    List<String>? unlockedRegionIds,
    List<String>? unlockedCountryIds,
    List<String>? unlockedEraIds,
    List<String>? unlockedCharacterIds,
    List<String>? unlockedFactIds,
    List<String>? achievementIds,
    DateTime? lastPlayedAt,
    String? lastPlayedEraId,
    int? totalPlayTimeMinutes,
    int? loginStreak,
    int? coins,
    List<String>? inventoryIds,
    bool? hasCompletedTutorial,
  }) {
    return UserProgress(
      oderId: oderId ?? this.oderId,
      totalKnowledge: totalKnowledge ?? this.totalKnowledge,
      rank: rank ?? this.rank,
      regionProgress: regionProgress ?? this.regionProgress,
      countryProgress: countryProgress ?? this.countryProgress,
      eraProgress: eraProgress ?? this.eraProgress,
      completedDialogueIds: completedDialogueIds ?? this.completedDialogueIds,
      unlockedRegionIds: unlockedRegionIds ?? this.unlockedRegionIds,
      unlockedCountryIds: unlockedCountryIds ?? this.unlockedCountryIds,
      unlockedEraIds: unlockedEraIds ?? this.unlockedEraIds,
      unlockedCharacterIds: unlockedCharacterIds ?? this.unlockedCharacterIds,
      unlockedFactIds: unlockedFactIds ?? this.unlockedFactIds,
      achievementIds: achievementIds ?? this.achievementIds,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      lastPlayedEraId: lastPlayedEraId ?? this.lastPlayedEraId,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      loginStreak: loginStreak ?? this.loginStreak,
      coins: coins ?? this.coins,
      inventoryIds: inventoryIds ?? this.inventoryIds,
      hasCompletedTutorial: hasCompletedTutorial ?? this.hasCompletedTutorial,
    );
  }

  /// 지역이 해금되었는지 확인
  bool isRegionUnlocked(String regionId) {
    return unlockedRegionIds.contains(regionId);
  }

  /// 국가가 해금되었는지 확인
  bool isCountryUnlocked(String countryId) {
    return unlockedCountryIds.contains(countryId);
  }

  /// 시대가 해금되었는지 확인
  bool isEraUnlocked(String eraId) {
    return unlockedEraIds.contains(eraId);
  }

  /// 인물이 해금되었는지 확인
  bool isCharacterUnlocked(String characterId) {
    return unlockedCharacterIds.contains(characterId);
  }

  /// 대화가 완료되었는지 확인
  bool isDialogueCompleted(String dialogueId) {
    return completedDialogueIds.contains(dialogueId);
  }

  /// 지역 진행률 가져오기
  double getRegionProgress(String regionId) {
    return regionProgress[regionId] ?? 0.0;
  }

  /// 국가 진행률 가져오기
  double getCountryProgress(String countryId) {
    return countryProgress[countryId] ?? 0.0;
  }

  /// 시대 진행률 가져오기
  double getEraProgress(String eraId) {
    return eraProgress[eraId] ?? 0.0;
  }

  /// 전체 진행률 계산
  double get overallProgress {
    if (eraProgress.isEmpty) return 0.0;
    final total = eraProgress.values.fold(0.0, (sum, p) => sum + p);
    return total / eraProgress.length;
  }

  /// 다음 등급까지 필요한 포인트
  int get pointsToNextRank {
    final thresholds = ProgressionConfig.rankThresholds;
    final ranks = ExplorerRank.values;
    final currentIndex = ranks.indexOf(rank);

    if (currentIndex >= ranks.length - 1) return 0;

    final nextRank = ranks[currentIndex + 1];
    final nextThreshold = thresholds[nextRank] ?? 0;
    return nextThreshold - totalKnowledge;
  }

  /// 현재 등급 진행률 (0.0 ~ 1.0)
  double get rankProgress {
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

  /// 완료한 대화 수
  int get completedDialogueCount => completedDialogueIds.length;

  /// 해금한 인물 수
  int get unlockedCharacterCount => unlockedCharacterIds.length;

  /// 발견한 역사 사실 수
  int get unlockedFactCount => unlockedFactIds.length;

  /// 획득한 업적 수
  int get achievementCount => achievementIds.length;

  /// 총 플레이 시간 (시:분 형식)
  String get totalPlayTimeFormatted {
    final hours = totalPlayTimeMinutes ~/ 60;
    final minutes = totalPlayTimeMinutes % 60;
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }

  @override
  List<Object?> get props => [
    oderId,
    totalKnowledge,
    rank,
    regionProgress,
    countryProgress,
    eraProgress,
    completedDialogueIds,
    unlockedRegionIds,
    unlockedCountryIds,
    unlockedEraIds,
    unlockedCharacterIds,
    unlockedFactIds,
    achievementIds,
    lastPlayedAt,
    lastPlayedEraId,
    totalPlayTimeMinutes,
    loginStreak,
    coins,
    inventoryIds,
    hasCompletedTutorial,
  ];

  @override
  String toString() =>
      'UserProgress(knowledge: $totalKnowledge, rank: ${rank.displayName})';
}

/// 일일 통계
class DailyStats extends Equatable {
  final DateTime date;
  final int knowledgeGained;
  final int dialoguesCompleted;
  final int playTimeMinutes;
  final List<String> erasVisited;

  const DailyStats({
    required this.date,
    this.knowledgeGained = 0,
    this.dialoguesCompleted = 0,
    this.playTimeMinutes = 0,
    this.erasVisited = const [],
  });

  DailyStats copyWith({
    DateTime? date,
    int? knowledgeGained,
    int? dialoguesCompleted,
    int? playTimeMinutes,
    List<String>? erasVisited,
  }) {
    return DailyStats(
      date: date ?? this.date,
      knowledgeGained: knowledgeGained ?? this.knowledgeGained,
      dialoguesCompleted: dialoguesCompleted ?? this.dialoguesCompleted,
      playTimeMinutes: playTimeMinutes ?? this.playTimeMinutes,
      erasVisited: erasVisited ?? this.erasVisited,
    );
  }

  @override
  List<Object?> get props => [
    date,
    knowledgeGained,
    dialoguesCompleted,
    playTimeMinutes,
    erasVisited,
  ];
}
