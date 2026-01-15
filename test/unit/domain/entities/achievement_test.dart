import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/achievement.dart';

void main() {
  group('AchievementCategory Extension', () {
    test('displayName이 올바르게 반환된다', () {
      expect(AchievementCategory.exploration.displayName, equals('탐험'));
      expect(AchievementCategory.knowledge.displayName, equals('지식'));
    });

    test('icon이 올바르게 반환된다', () {
      expect(AchievementCategory.exploration.icon, equals('🗺️'));
      expect(AchievementCategory.knowledge.icon, equals('📚'));
    });
  });

  group('AchievementRarity Extension', () {
    test('displayName이 올바르게 반환된다', () {
      expect(AchievementRarity.common.displayName, equals('일반'));
      expect(AchievementRarity.legendary.displayName, equals('전설'));
    });

    test('bonusPoints가 희귀도에 따라 올바르게 반환된다', () {
      expect(AchievementRarity.common.bonusPoints, equals(10));
      expect(AchievementRarity.legendary.bonusPoints, equals(250));
    });
  });

  group('Achievement Entity', () {
    const condition = AchievementCondition(
      type: AchievementConditionType.reachKnowledge,
      targetValue: 1000,
    );

    const achievement = Achievement(
      id: 'reach_1000',
      title: 'Scholar',
      titleKorean: '학자',
      description: 'Reach 1000 knowledge points',
      iconAsset: 'assets/icon.png',
      category: AchievementCategory.knowledge,
      rarity: AchievementRarity.uncommon,
      bonusPoints: 50,
      condition: condition,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      const achievement2 = Achievement(
        id: 'reach_1000',
        title: 'Scholar',
        titleKorean: '학자',
        description: 'Reach 1000 knowledge points',
        iconAsset: 'assets/icon.png',
        category: AchievementCategory.knowledge,
        rarity: AchievementRarity.uncommon,
        bonusPoints: 50,
        condition: condition,
      );
      expect(achievement, equals(achievement2));
    });

    test('totalBonusPoints가 희귀도 보너스와 기본 보너스를 합산한다', () {
      // uncommon bonus (25) + bonusPoints (50) = 75
      expect(achievement.totalBonusPoints, equals(75));
    });

    test('copyWith가 올바르게 작동한다', () {
      final updated = achievement.copyWith(isUnlocked: true);
      expect(updated.isUnlocked, isTrue);
      expect(updated.id, equals(achievement.id));
    });
  });
}
