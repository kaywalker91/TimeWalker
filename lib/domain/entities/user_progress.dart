import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/completion_state.dart';
import 'package:time_walker/domain/entities/exploration_state.dart';
import 'package:time_walker/domain/entities/unlock_state.dart';
import 'package:time_walker/domain/entities/user_profile.dart';

/// 사용자 진행 상태 엔티티
class UserProgress extends Equatable {
  final String userId;
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
  final List<String> completedQuizIds; // 정답을 맞춘 퀴즈 ID 목록
  final List<String> discoveredEncyclopediaIds; // 발견한 도감 항목 ID 목록 (deprecated, 하위 호환성)
  final Map<String, DateTime> encyclopediaDiscoveryDates; // 도감 항목 ID -> 발견 날짜
  final DateTime? lastPlayedAt;
  final String? lastPlayedEraId;
  final int totalPlayTimeMinutes;
  final int loginStreak;
  final int coins; // 보유 코인 (화폐)
  final List<String> inventoryIds; // 보유 아이템 목록
  final bool hasCompletedTutorial; // 튜토리얼 완료 여부

  const UserProgress({
    required this.userId,
    this.totalKnowledge = 0,
    this.rank = ExplorerRank.novice,
    this.regionProgress = const {},
    this.countryProgress = const {},
    this.eraProgress = const {},
    this.completedDialogueIds = const [],
    this.unlockedRegionIds = const [],
    this.unlockedCountryIds = const [],
    this.unlockedEraIds = const [],
    this.unlockedCharacterIds = const [],
    this.unlockedFactIds = const [],
    this.achievementIds = const [],
    this.completedQuizIds = const [],
    this.discoveredEncyclopediaIds = const [], // deprecated, 하위 호환성 유지
    this.encyclopediaDiscoveryDates = const {}, // 새로운 필드: 항목 ID -> 발견 날짜
    this.lastPlayedAt,
    this.lastPlayedEraId,
    this.totalPlayTimeMinutes = 0,
    this.loginStreak = 0,
    this.coins = 99999, // 기본 코인 제공 (테스트용)
    this.inventoryIds = const [],
    this.hasCompletedTutorial = false,
  });

  UserProgress copyWith({
    String? userId,
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
    List<String>? completedQuizIds,
    List<String>? discoveredEncyclopediaIds,
    Map<String, DateTime>? encyclopediaDiscoveryDates,
    DateTime? lastPlayedAt,
    String? lastPlayedEraId,
    int? totalPlayTimeMinutes,
    int? loginStreak,
    int? coins,
    List<String>? inventoryIds,
    bool? hasCompletedTutorial,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
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
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      discoveredEncyclopediaIds: discoveredEncyclopediaIds ?? this.discoveredEncyclopediaIds,
      encyclopediaDiscoveryDates: encyclopediaDiscoveryDates ?? this.encyclopediaDiscoveryDates,
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
    if (unlockedRegionIds.contains(regionId)) {
      return true;
    }

    if (regionId == 'americas') {
      return unlockedRegionIds.contains('north_america') ||
          unlockedRegionIds.contains('south_america');
    }

    if (regionId == 'north_america' || regionId == 'south_america') {
      return unlockedRegionIds.contains('americas');
    }

    return false;
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

  /// 도감 항목 발견 여부 확인
  bool isEncyclopediaDiscovered(String entryId) {
    return encyclopediaDiscoveryDates.containsKey(entryId) ||
           discoveredEncyclopediaIds.contains(entryId);
  }

  /// 도감 항목 발견 날짜 반환
  DateTime? getEncyclopediaDiscoveryDate(String entryId) {
    return encyclopediaDiscoveryDates[entryId];
  }

  /// 최신순으로 정렬된 발견된 도감 ID 목록
  List<String> get recentlyDiscoveredEncyclopediaIds {
    final entries = encyclopediaDiscoveryDates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // 최신순 (내림차순)
    return entries.map((e) => e.key).toList();
  }

  /// 발견한 도감 항목 수
  int get discoveredEncyclopediaCount => encyclopediaDiscoveryDates.length;

  /// 획득한 업적 수
  int get achievementCount => achievementIds.length;

  /// 퀴즈 정답 완료 여부 확인
  bool isQuizCompleted(String quizId) {
    return completedQuizIds.contains(quizId);
  }

  /// 정답을 맞춘 퀴즈 수
  int get completedQuizCount => completedQuizIds.length;

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
    userId,
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
    completedQuizIds,
    discoveredEncyclopediaIds,
    encyclopediaDiscoveryDates,
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

  // ============================================================
  // 하위 엔티티 변환 메서드
  // Phase 3 리팩토링: UserProgress를 논리적으로 분리된 엔티티로 변환
  // ============================================================

  /// UserProfile 엔티티로 변환
  ///
  /// 사용자 기본 프로필 정보만 추출합니다.
  UserProfile toUserProfile() {
    return UserProfile(
      userId: userId,
      rank: rank,
      coins: coins,
      loginStreak: loginStreak,
      lastPlayedAt: lastPlayedAt,
      lastPlayedEraId: lastPlayedEraId,
      totalPlayTimeMinutes: totalPlayTimeMinutes,
      hasCompletedTutorial: hasCompletedTutorial,
      inventoryIds: List.from(inventoryIds),
    );
  }

  /// ExplorationState 엔티티로 변환
  ///
  /// 탐험 진행 상태 정보만 추출합니다.
  ExplorationState toExplorationState() {
    return ExplorationState(
      regionProgress: Map.from(regionProgress),
      countryProgress: Map.from(countryProgress),
      eraProgress: Map.from(eraProgress),
      totalKnowledge: totalKnowledge,
    );
  }

  /// UnlockState 엔티티로 변환
  ///
  /// 콘텐츠 해금 상태 정보만 추출합니다.
  UnlockState toUnlockState() {
    return UnlockState(
      unlockedRegionIds: List.from(unlockedRegionIds),
      unlockedCountryIds: List.from(unlockedCountryIds),
      unlockedEraIds: List.from(unlockedEraIds),
      unlockedCharacterIds: List.from(unlockedCharacterIds),
      unlockedFactIds: List.from(unlockedFactIds),
    );
  }

  /// CompletionState 엔티티로 변환
  ///
  /// 완료/발견 상태 정보만 추출합니다.
  CompletionState toCompletionState() {
    return CompletionState(
      completedDialogueIds: List.from(completedDialogueIds),
      completedQuizIds: List.from(completedQuizIds),
      encyclopediaDiscoveryDates: Map.from(encyclopediaDiscoveryDates),
      achievementIds: List.from(achievementIds),
      discoveredEncyclopediaIds: List.from(discoveredEncyclopediaIds),
    );
  }

  /// 분리된 엔티티들로부터 UserProgress 생성
  ///
  /// 하위 호환성을 위해 기존 UserProgress로 재조합하는 팩토리 메서드입니다.
  factory UserProgress.fromComponents({
    required UserProfile profile,
    required ExplorationState exploration,
    required UnlockState unlock,
    required CompletionState completion,
  }) {
    return UserProgress(
      // UserProfile
      userId: profile.userId,
      rank: profile.rank,
      coins: profile.coins,
      loginStreak: profile.loginStreak,
      lastPlayedAt: profile.lastPlayedAt,
      lastPlayedEraId: profile.lastPlayedEraId,
      totalPlayTimeMinutes: profile.totalPlayTimeMinutes,
      hasCompletedTutorial: profile.hasCompletedTutorial,
      inventoryIds: List.from(profile.inventoryIds),
      // ExplorationState
      regionProgress: Map.from(exploration.regionProgress),
      countryProgress: Map.from(exploration.countryProgress),
      eraProgress: Map.from(exploration.eraProgress),
      totalKnowledge: exploration.totalKnowledge,
      // UnlockState
      unlockedRegionIds: List.from(unlock.unlockedRegionIds),
      unlockedCountryIds: List.from(unlock.unlockedCountryIds),
      unlockedEraIds: List.from(unlock.unlockedEraIds),
      unlockedCharacterIds: List.from(unlock.unlockedCharacterIds),
      unlockedFactIds: List.from(unlock.unlockedFactIds),
      // CompletionState
      completedDialogueIds: List.from(completion.completedDialogueIds),
      completedQuizIds: List.from(completion.completedQuizIds),
      encyclopediaDiscoveryDates: Map.from(completion.encyclopediaDiscoveryDates),
      achievementIds: List.from(completion.achievementIds),
      discoveredEncyclopediaIds: List.from(completion.discoveredEncyclopediaIds),
    );
  }
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
