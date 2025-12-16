import 'package:equatable/equatable.dart';

/// 업적 카테고리
enum AchievementCategory {
  exploration, // 탐험
  dialogue, // 대화
  knowledge, // 지식
  collection, // 수집
  special, // 특별
}

/// 업적 카테고리 확장
extension AchievementCategoryExtension on AchievementCategory {
  String get displayName {
    switch (this) {
      case AchievementCategory.exploration:
        return '탐험';
      case AchievementCategory.dialogue:
        return '대화';
      case AchievementCategory.knowledge:
        return '지식';
      case AchievementCategory.collection:
        return '수집';
      case AchievementCategory.special:
        return '특별';
    }
  }

  String get icon {
    switch (this) {
      case AchievementCategory.exploration:
        return '🗺️';
      case AchievementCategory.dialogue:
        return '💬';
      case AchievementCategory.knowledge:
        return '📚';
      case AchievementCategory.collection:
        return '🏆';
      case AchievementCategory.special:
        return '⭐';
    }
  }
}

/// 업적 희귀도
enum AchievementRarity {
  common, // 일반
  uncommon, // 비일반
  rare, // 희귀
  epic, // 에픽
  legendary, // 전설
}

/// 업적 희귀도 확장
extension AchievementRarityExtension on AchievementRarity {
  String get displayName {
    switch (this) {
      case AchievementRarity.common:
        return '일반';
      case AchievementRarity.uncommon:
        return '비일반';
      case AchievementRarity.rare:
        return '희귀';
      case AchievementRarity.epic:
        return '에픽';
      case AchievementRarity.legendary:
        return '전설';
    }
  }

  int get colorValue {
    switch (this) {
      case AchievementRarity.common:
        return 0xFF9E9E9E; // 회색
      case AchievementRarity.uncommon:
        return 0xFF4CAF50; // 녹색
      case AchievementRarity.rare:
        return 0xFF2196F3; // 파랑
      case AchievementRarity.epic:
        return 0xFF9C27B0; // 보라
      case AchievementRarity.legendary:
        return 0xFFFF9800; // 주황
    }
  }

  int get bonusPoints {
    switch (this) {
      case AchievementRarity.common:
        return 10;
      case AchievementRarity.uncommon:
        return 25;
      case AchievementRarity.rare:
        return 50;
      case AchievementRarity.epic:
        return 100;
      case AchievementRarity.legendary:
        return 250;
    }
  }
}

/// 업적 엔티티
class Achievement extends Equatable {
  final String id;
  final String title;
  final String titleKorean;
  final String description;
  final String iconAsset;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int bonusPoints;
  final AchievementCondition condition;
  final bool isSecret; // 숨겨진 업적 여부
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.titleKorean,
    required this.description,
    required this.iconAsset,
    required this.category,
    required this.rarity,
    this.bonusPoints = 0,
    required this.condition,
    this.isSecret = false,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? titleKorean,
    String? description,
    String? iconAsset,
    AchievementCategory? category,
    AchievementRarity? rarity,
    int? bonusPoints,
    AchievementCondition? condition,
    bool? isSecret,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      titleKorean: titleKorean ?? this.titleKorean,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      condition: condition ?? this.condition,
      isSecret: isSecret ?? this.isSecret,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// 총 보너스 포인트 (희귀도 보너스 + 추가 보너스)
  int get totalBonusPoints => rarity.bonusPoints + bonusPoints;

  @override
  List<Object?> get props => [
    id,
    title,
    titleKorean,
    description,
    iconAsset,
    category,
    rarity,
    bonusPoints,
    condition,
    isSecret,
    isUnlocked,
    unlockedAt,
  ];

  @override
  String toString() =>
      'Achievement(id: $id, title: $titleKorean, unlocked: $isUnlocked)';
}

/// 업적 달성 조건
class AchievementCondition extends Equatable {
  final AchievementConditionType type;
  final int targetValue;
  final String? targetId; // 특정 시대/인물 등 대상 ID

  const AchievementCondition({
    required this.type,
    required this.targetValue,
    this.targetId,
  });

  @override
  List<Object?> get props => [type, targetValue, targetId];
}

/// 업적 조건 타입
enum AchievementConditionType {
  completeDialogues, // N개의 대화 완료
  unlockCharacters, // N명의 인물 해금
  completeEra, // 특정 시대 완료
  reachKnowledge, // N 포인트 지식 달성
  discoverFacts, // N개의 역사 사실 발견
  loginStreak, // N일 연속 로그인
  completeQuiz, // N개의 퀴즈 완료
  perfectQuiz, // 퀴즈 만점
  visitLocations, // N개의 장소 방문
  specialEvent, // 특별 이벤트 (대화 중 특정 선택)
}

/// 기본 업적 데이터
class AchievementData {
  AchievementData._();

  static const Achievement firstStep = Achievement(
    id: 'first_step',
    title: 'First Step',
    titleKorean: '첫 발걸음',
    description: '첫 번째 역사 인물과 대화를 나누다',
    iconAsset: 'assets/images/achievements/first_step.png',
    category: AchievementCategory.dialogue,
    rarity: AchievementRarity.common,
    condition: AchievementCondition(
      type: AchievementConditionType.completeDialogues,
      targetValue: 1,
    ),
  );

  static const Achievement timeExplorer = Achievement(
    id: 'time_explorer',
    title: 'Time Explorer',
    titleKorean: '시간 탐험가',
    description: '첫 번째 시대를 완료하다',
    iconAsset: 'assets/images/achievements/time_explorer.png',
    category: AchievementCategory.exploration,
    rarity: AchievementRarity.uncommon,
    condition: AchievementCondition(
      type: AchievementConditionType.completeEra,
      targetValue: 1,
    ),
  );

  static const Achievement sejongFriend = Achievement(
    id: 'sejong_friend',
    title: 'Friend of Sejong',
    titleKorean: '세종대왕의 벗',
    description: '세종대왕의 모든 대화를 완료하다',
    iconAsset: 'assets/images/achievements/sejong_friend.png',
    category: AchievementCategory.dialogue,
    rarity: AchievementRarity.rare,
    bonusPoints: 50,
    condition: AchievementCondition(
      type: AchievementConditionType.completeDialogues,
      targetValue: 3,
      targetId: 'sejong',
    ),
  );

  static const Achievement historyMaster = Achievement(
    id: 'history_master',
    title: 'History Master',
    titleKorean: '역사 마스터',
    description: '역사 마스터 등급에 도달하다',
    iconAsset: 'assets/images/achievements/history_master.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.legendary,
    bonusPoints: 200,
    condition: AchievementCondition(
      type: AchievementConditionType.reachKnowledge,
      targetValue: 12000,
    ),
  );

  static const Achievement secretOfHangul = Achievement(
    id: 'secret_of_hangul',
    title: 'Secret of Hangul',
    titleKorean: '한글의 비밀',
    description: '훈민정음 창제의 비밀을 발견하다',
    iconAsset: 'assets/images/achievements/secret_of_hangul.png',
    category: AchievementCategory.special,
    rarity: AchievementRarity.epic,
    bonusPoints: 100,
    isSecret: true,
    condition: AchievementCondition(
      type: AchievementConditionType.specialEvent,
      targetValue: 1,
      targetId: 'sejong_hangul_secret',
    ),
  );

  static List<Achievement> get all => [
    firstStep,
    timeExplorer,
    sejongFriend,
    historyMaster,
    secretOfHangul,
  ];

  static List<Achievement> getByCategory(AchievementCategory category) {
    return all.where((a) => a.category == category).toList();
  }

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
