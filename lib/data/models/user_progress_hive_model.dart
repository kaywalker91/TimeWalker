import 'package:hive/hive.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

part 'user_progress_hive_model.g.dart';

/// Hive 저장용 UserProgress 모델
/// 
/// Domain Entity와 분리하여 데이터 계층의 독립성 유지
@HiveType(typeId: 0)
class UserProgressHiveModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  int totalKnowledge;

  @HiveField(2)
  int rankIndex; // ExplorerRank의 index

  @HiveField(3)
  Map<String, double> regionProgress;

  @HiveField(4)
  Map<String, double> countryProgress;

  @HiveField(5)
  Map<String, double> eraProgress;

  @HiveField(6)
  List<String> completedDialogueIds;

  @HiveField(7)
  List<String> unlockedRegionIds;

  @HiveField(8)
  List<String> unlockedCountryIds;

  @HiveField(9)
  List<String> unlockedEraIds;

  @HiveField(10)
  List<String> unlockedCharacterIds;

  @HiveField(11)
  List<String> unlockedFactIds;

  @HiveField(12)
  List<String> achievementIds;

  @HiveField(13)
  List<String> completedQuizIds;

  @HiveField(14)
  List<String> discoveredEncyclopediaIds;

  @HiveField(15)
  DateTime? lastPlayedAt;

  @HiveField(16)
  String? lastPlayedEraId;

  @HiveField(17)
  int totalPlayTimeMinutes;

  @HiveField(18)
  int loginStreak;

  @HiveField(19)
  int coins;

  @HiveField(20)
  List<String> inventoryIds;

  @HiveField(21)
  bool hasCompletedTutorial;

  @HiveField(22)
  Map<String, int> encyclopediaDiscoveryDatesMs; // 항목 ID -> 발견 날짜 (millisecondsSinceEpoch)

  UserProgressHiveModel({
    required this.userId,
    this.totalKnowledge = 0,
    this.rankIndex = 0,
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
    this.lastPlayedAt,
    this.lastPlayedEraId,
    this.totalPlayTimeMinutes = 0,
    this.loginStreak = 0,
    this.coins = 100,
    List<String>? inventoryIds,
    this.hasCompletedTutorial = false,
    Map<String, int>? encyclopediaDiscoveryDatesMs,
  })  : regionProgress = regionProgress ?? {},
        countryProgress = countryProgress ?? {},
        eraProgress = eraProgress ?? {},
        completedDialogueIds = completedDialogueIds ?? [],
        unlockedRegionIds = unlockedRegionIds ?? [],
        unlockedCountryIds = unlockedCountryIds ?? [],
        unlockedEraIds = unlockedEraIds ?? [],
        unlockedCharacterIds = unlockedCharacterIds ?? [],
        unlockedFactIds = unlockedFactIds ?? [],
        achievementIds = achievementIds ?? [],
        completedQuizIds = completedQuizIds ?? [],
        discoveredEncyclopediaIds = discoveredEncyclopediaIds ?? [],
        inventoryIds = inventoryIds ?? [],
        encyclopediaDiscoveryDatesMs = encyclopediaDiscoveryDatesMs ?? {};

  /// Domain Entity로 변환
  UserProgress toEntity() {
    // millisecondsSinceEpoch -> DateTime 변환
    final discoveryDates = encyclopediaDiscoveryDatesMs.map(
      (key, value) => MapEntry(key, DateTime.fromMillisecondsSinceEpoch(value)),
    );
    
    return UserProgress(
      userId: userId,
      totalKnowledge: totalKnowledge,
      rank: ExplorerRank.values[rankIndex.clamp(0, ExplorerRank.values.length - 1)],
      regionProgress: Map<String, double>.from(regionProgress),
      countryProgress: Map<String, double>.from(countryProgress),
      eraProgress: Map<String, double>.from(eraProgress),
      completedDialogueIds: List<String>.from(completedDialogueIds),
      unlockedRegionIds: List<String>.from(unlockedRegionIds),
      unlockedCountryIds: List<String>.from(unlockedCountryIds),
      unlockedEraIds: List<String>.from(unlockedEraIds),
      unlockedCharacterIds: List<String>.from(unlockedCharacterIds),
      unlockedFactIds: List<String>.from(unlockedFactIds),
      achievementIds: List<String>.from(achievementIds),
      completedQuizIds: List<String>.from(completedQuizIds),
      discoveredEncyclopediaIds: List<String>.from(discoveredEncyclopediaIds),
      encyclopediaDiscoveryDates: discoveryDates,
      lastPlayedAt: lastPlayedAt,
      lastPlayedEraId: lastPlayedEraId,
      totalPlayTimeMinutes: totalPlayTimeMinutes,
      loginStreak: loginStreak,
      coins: coins,
      inventoryIds: List<String>.from(inventoryIds),
      hasCompletedTutorial: hasCompletedTutorial,
    );
  }

  /// Domain Entity에서 Hive 모델로 변환
  factory UserProgressHiveModel.fromEntity(UserProgress entity) {
    // DateTime -> millisecondsSinceEpoch 변환
    final discoveryDatesMs = entity.encyclopediaDiscoveryDates.map(
      (key, value) => MapEntry(key, value.millisecondsSinceEpoch),
    );
    
    return UserProgressHiveModel(
      userId: entity.userId,
      totalKnowledge: entity.totalKnowledge,
      rankIndex: entity.rank.index,
      regionProgress: Map<String, double>.from(entity.regionProgress),
      countryProgress: Map<String, double>.from(entity.countryProgress),
      eraProgress: Map<String, double>.from(entity.eraProgress),
      completedDialogueIds: List<String>.from(entity.completedDialogueIds),
      unlockedRegionIds: List<String>.from(entity.unlockedRegionIds),
      unlockedCountryIds: List<String>.from(entity.unlockedCountryIds),
      unlockedEraIds: List<String>.from(entity.unlockedEraIds),
      unlockedCharacterIds: List<String>.from(entity.unlockedCharacterIds),
      unlockedFactIds: List<String>.from(entity.unlockedFactIds),
      achievementIds: List<String>.from(entity.achievementIds),
      completedQuizIds: List<String>.from(entity.completedQuizIds),
      discoveredEncyclopediaIds: List<String>.from(entity.discoveredEncyclopediaIds),
      encyclopediaDiscoveryDatesMs: discoveryDatesMs,
      lastPlayedAt: entity.lastPlayedAt,
      lastPlayedEraId: entity.lastPlayedEraId,
      totalPlayTimeMinutes: entity.totalPlayTimeMinutes,
      loginStreak: entity.loginStreak,
      coins: entity.coins,
      inventoryIds: List<String>.from(entity.inventoryIds),
      hasCompletedTutorial: entity.hasCompletedTutorial,
    );
  }
}
