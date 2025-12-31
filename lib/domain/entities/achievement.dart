import 'dart:ui';
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

  /// IconData 형태의 아이콘
  int get iconCodePoint {
    switch (this) {
      case AchievementCategory.exploration:
        return 0xe3c6; // map
      case AchievementCategory.dialogue:
        return 0xe0ca; // chat_bubble
      case AchievementCategory.knowledge:
        return 0xe3e6; // menu_book
      case AchievementCategory.collection:
        return 0xe1fe; // emoji_events
      case AchievementCategory.special:
        return 0xe5f9; // star
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

  /// Color 객체로 반환
  Color get color => Color(colorValue);

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



