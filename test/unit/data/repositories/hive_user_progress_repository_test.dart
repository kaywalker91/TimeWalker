import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/data/models/user_progress_hive_model.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

void main() {
  group('UserProgressHiveModel', () {
    group('toEntity', () {
      test('converts HiveModel to UserProgress entity', () {
        // Arrange
        final hiveModel = UserProgressHiveModel(
          userId: 'test_user',
          totalKnowledge: 1500,
          rankIndex: 2, // intermediate
          regionProgress: {'asia': 0.5, 'europe': 0.3},
          countryProgress: {'korea': 0.8, 'japan': 0.4},
          eraProgress: {'joseon': 1.0, 'goryeo': 0.5},
          completedDialogueIds: ['dialogue_1', 'dialogue_2'],
          unlockedRegionIds: ['asia', 'europe'],
          unlockedCountryIds: ['korea', 'japan', 'china'],
          unlockedEraIds: ['joseon', 'goryeo', 'three_kingdoms'],
          unlockedCharacterIds: ['sejong', 'yi_sun_sin'],
          unlockedFactIds: ['fact_1'],
          achievementIds: ['first_quiz', 'first_dialogue'],
          completedQuizIds: ['quiz_1', 'quiz_2', 'quiz_3'],
          discoveredEncyclopediaIds: ['encyclo_1', 'encyclo_2'],
          lastPlayedAt: DateTime(2026, 1, 12, 10, 30),
          lastPlayedEraId: 'joseon',
          totalPlayTimeMinutes: 120,
          loginStreak: 7,
          coins: 5000,
          inventoryIds: ['item_1', 'item_2'],
          hasCompletedTutorial: true,
          encyclopediaDiscoveryDatesMs: {
            'encyclo_1': DateTime(2026, 1, 10).millisecondsSinceEpoch,
          },
        );

        // Act
        final entity = hiveModel.toEntity();

        // Assert
        expect(entity.userId, equals('test_user'));
        expect(entity.totalKnowledge, equals(1500));
        expect(entity.rank, equals(ExplorerRank.intermediate));
        expect(entity.regionProgress['asia'], equals(0.5));
        expect(entity.countryProgress['korea'], equals(0.8));
        expect(entity.eraProgress['joseon'], equals(1.0));
        expect(entity.completedDialogueIds.length, equals(2));
        expect(entity.unlockedRegionIds, contains('asia'));
        expect(entity.unlockedCountryIds.length, equals(3));
        expect(entity.unlockedEraIds.length, equals(3));
        expect(entity.unlockedCharacterIds, contains('sejong'));
        expect(entity.achievementIds.length, equals(2));
        expect(entity.completedQuizIds.length, equals(3));
        expect(entity.discoveredEncyclopediaIds.length, equals(2));
        expect(entity.lastPlayedAt, equals(DateTime(2026, 1, 12, 10, 30)));
        expect(entity.lastPlayedEraId, equals('joseon'));
        expect(entity.totalPlayTimeMinutes, equals(120));
        expect(entity.loginStreak, equals(7));
        expect(entity.coins, equals(5000));
        expect(entity.inventoryIds.length, equals(2));
        expect(entity.hasCompletedTutorial, isTrue);
        expect(entity.encyclopediaDiscoveryDates['encyclo_1'], isNotNull);
      });

      test('handles empty collections', () {
        // Arrange
        final hiveModel = UserProgressHiveModel(userId: 'empty_user');

        // Act
        final entity = hiveModel.toEntity();

        // Assert
        expect(entity.userId, equals('empty_user'));
        expect(entity.regionProgress, isEmpty);
        expect(entity.countryProgress, isEmpty);
        expect(entity.eraProgress, isEmpty);
        expect(entity.completedDialogueIds, isEmpty);
        expect(entity.unlockedRegionIds, isEmpty);
        expect(entity.unlockedCountryIds, isEmpty);
        expect(entity.unlockedEraIds, isEmpty);
        expect(entity.hasCompletedTutorial, isFalse);
      });

      test('clamps invalid rank index', () {
        // Arrange - rankIndex out of bounds
        final hiveModel = UserProgressHiveModel(
          userId: 'test_user',
          rankIndex: 100, // Invalid, should be clamped
        );

        // Act
        final entity = hiveModel.toEntity();

        // Assert - should be clamped to last valid rank
        expect(entity.rank, equals(ExplorerRank.values.last));
      });

      test('clamps negative rank index', () {
        // Arrange - negative rankIndex
        final hiveModel = UserProgressHiveModel(
          userId: 'test_user',
          rankIndex: -5, // Invalid, should be clamped to 0
        );

        // Act
        final entity = hiveModel.toEntity();

        // Assert - should be clamped to first rank (novice)
        expect(entity.rank, equals(ExplorerRank.novice));
      });
    });

    group('fromEntity', () {
      test('converts UserProgress entity to HiveModel', () {
        // Arrange
        final entity = UserProgress(
          userId: 'test_user',
          totalKnowledge: 2000,
          rank: ExplorerRank.advanced,
          regionProgress: const {'asia': 0.7},
          countryProgress: const {'korea': 0.9},
          eraProgress: const {'joseon': 1.0, 'goryeo': 0.8},
          completedDialogueIds: const ['d1', 'd2', 'd3'],
          unlockedRegionIds: const ['asia', 'europe'],
          unlockedCountryIds: const ['korea', 'japan'],
          unlockedEraIds: const ['joseon', 'goryeo'],
          unlockedCharacterIds: const ['char1', 'char2'],
          unlockedFactIds: const ['fact1'],
          achievementIds: const ['ach1', 'ach2'],
          completedQuizIds: const ['q1', 'q2'],
          discoveredEncyclopediaIds: const ['enc1'],
          encyclopediaDiscoveryDates: {
            'enc1': DateTime(2026, 1, 11, 15, 0),
          },
          lastPlayedAt: DateTime(2026, 1, 12, 12, 0),
          lastPlayedEraId: 'goryeo',
          totalPlayTimeMinutes: 200,
          loginStreak: 10,
          coins: 8000,
          inventoryIds: const ['inv1'],
          hasCompletedTutorial: true,
        );

        // Act
        final hiveModel = UserProgressHiveModel.fromEntity(entity);

        // Assert
        expect(hiveModel.userId, equals('test_user'));
        expect(hiveModel.totalKnowledge, equals(2000));
        expect(hiveModel.rankIndex, equals(ExplorerRank.advanced.index));
        expect(hiveModel.regionProgress['asia'], equals(0.7));
        expect(hiveModel.countryProgress['korea'], equals(0.9));
        expect(hiveModel.eraProgress.length, equals(2));
        expect(hiveModel.completedDialogueIds.length, equals(3));
        expect(hiveModel.unlockedRegionIds.length, equals(2));
        expect(hiveModel.unlockedCountryIds.length, equals(2));
        expect(hiveModel.unlockedEraIds.length, equals(2));
        expect(hiveModel.unlockedCharacterIds.length, equals(2));
        expect(hiveModel.achievementIds.length, equals(2));
        expect(hiveModel.completedQuizIds.length, equals(2));
        expect(hiveModel.discoveredEncyclopediaIds.length, equals(1));
        expect(hiveModel.lastPlayedAt, equals(DateTime(2026, 1, 12, 12, 0)));
        expect(hiveModel.lastPlayedEraId, equals('goryeo'));
        expect(hiveModel.totalPlayTimeMinutes, equals(200));
        expect(hiveModel.loginStreak, equals(10));
        expect(hiveModel.coins, equals(8000));
        expect(hiveModel.inventoryIds.length, equals(1));
        expect(hiveModel.hasCompletedTutorial, isTrue);
        expect(hiveModel.encyclopediaDiscoveryDatesMs['enc1'], isNotNull);
      });

      test('preserves all rank values correctly', () {
        for (final rank in ExplorerRank.values) {
          // Arrange
          final entity = UserProgress(userId: 'test', rank: rank);

          // Act
          final hiveModel = UserProgressHiveModel.fromEntity(entity);

          // Assert
          expect(hiveModel.rankIndex, equals(rank.index));
        }
      });
    });

    group('roundtrip conversion', () {
      test('entity -> hiveModel -> entity preserves all data', () {
        // Arrange
        final originalEntity = UserProgress(
          userId: 'roundtrip_test',
          totalKnowledge: 5000,
          rank: ExplorerRank.expert,
          regionProgress: const {'asia': 0.9, 'europe': 0.6, 'africa': 0.3},
          countryProgress: const {'korea': 1.0, 'japan': 0.8, 'china': 0.7},
          eraProgress: const {'joseon': 1.0, 'goryeo': 1.0, 'three_kingdoms': 0.5},
          completedDialogueIds: const ['d1', 'd2', 'd3', 'd4', 'd5'],
          unlockedRegionIds: const ['asia', 'europe', 'africa'],
          unlockedCountryIds: const ['korea', 'japan', 'china', 'uk', 'france'],
          unlockedEraIds: const ['joseon', 'goryeo', 'three_kingdoms', 'renaissance'],
          unlockedCharacterIds: const ['sejong', 'yi_sun_sin', 'gwanggaeto'],
          unlockedFactIds: const ['fact1', 'fact2'],
          achievementIds: const ['ach1', 'ach2', 'ach3'],
          completedQuizIds: const ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7', 'q8', 'q9', 'q10'],
          discoveredEncyclopediaIds: const ['enc1', 'enc2', 'enc3'],
          encyclopediaDiscoveryDates: {
            'enc1': DateTime(2026, 1, 1),
            'enc2': DateTime(2026, 1, 5),
            'enc3': DateTime(2026, 1, 10),
          },
          lastPlayedAt: DateTime(2026, 1, 12, 18, 30, 45),
          lastPlayedEraId: 'joseon',
          totalPlayTimeMinutes: 500,
          loginStreak: 14,
          coins: 25000,
          inventoryIds: const ['skin_1', 'skin_2', 'boost_1'],
          hasCompletedTutorial: true,
        );

        // Act
        final hiveModel = UserProgressHiveModel.fromEntity(originalEntity);
        final convertedEntity = hiveModel.toEntity();

        // Assert - most fields should match exactly
        expect(convertedEntity.userId, equals(originalEntity.userId));
        expect(convertedEntity.totalKnowledge, equals(originalEntity.totalKnowledge));
        expect(convertedEntity.rank, equals(originalEntity.rank));
        expect(convertedEntity.regionProgress, equals(originalEntity.regionProgress));
        expect(convertedEntity.countryProgress, equals(originalEntity.countryProgress));
        expect(convertedEntity.eraProgress, equals(originalEntity.eraProgress));
        expect(convertedEntity.completedDialogueIds, equals(originalEntity.completedDialogueIds));
        expect(convertedEntity.unlockedRegionIds, equals(originalEntity.unlockedRegionIds));
        expect(convertedEntity.unlockedCountryIds, equals(originalEntity.unlockedCountryIds));
        expect(convertedEntity.unlockedEraIds, equals(originalEntity.unlockedEraIds));
        expect(convertedEntity.unlockedCharacterIds, equals(originalEntity.unlockedCharacterIds));
        expect(convertedEntity.unlockedFactIds, equals(originalEntity.unlockedFactIds));
        expect(convertedEntity.achievementIds, equals(originalEntity.achievementIds));
        expect(convertedEntity.completedQuizIds, equals(originalEntity.completedQuizIds));
        expect(convertedEntity.discoveredEncyclopediaIds, equals(originalEntity.discoveredEncyclopediaIds));
        expect(convertedEntity.lastPlayedEraId, equals(originalEntity.lastPlayedEraId));
        expect(convertedEntity.totalPlayTimeMinutes, equals(originalEntity.totalPlayTimeMinutes));
        expect(convertedEntity.loginStreak, equals(originalEntity.loginStreak));
        expect(convertedEntity.coins, equals(originalEntity.coins));
        expect(convertedEntity.inventoryIds, equals(originalEntity.inventoryIds));
        expect(convertedEntity.hasCompletedTutorial, equals(originalEntity.hasCompletedTutorial));

        // DateTime comparison (might have millisecond precision differences)
        expect(convertedEntity.lastPlayedAt?.year, equals(originalEntity.lastPlayedAt?.year));
        expect(convertedEntity.lastPlayedAt?.month, equals(originalEntity.lastPlayedAt?.month));
        expect(convertedEntity.lastPlayedAt?.day, equals(originalEntity.lastPlayedAt?.day));
        expect(convertedEntity.lastPlayedAt?.hour, equals(originalEntity.lastPlayedAt?.hour));
        expect(convertedEntity.lastPlayedAt?.minute, equals(originalEntity.lastPlayedAt?.minute));
      });

      test('encyclopedia discovery dates preserve correctly', () {
        // Arrange
        final testDate = DateTime(2026, 1, 15, 14, 30);
        final entity = UserProgress(
          userId: 'test',
          encyclopediaDiscoveryDates: {'item_1': testDate},
        );

        // Act
        final hiveModel = UserProgressHiveModel.fromEntity(entity);
        final convertedEntity = hiveModel.toEntity();

        // Assert
        final convertedDate = convertedEntity.encyclopediaDiscoveryDates['item_1'];
        expect(convertedDate, isNotNull);
        expect(convertedDate!.millisecondsSinceEpoch, 
               equals(testDate.millisecondsSinceEpoch));
      });
    });

    group('default values', () {
      test('HiveModel has sensible defaults', () {
        // Arrange & Act
        final hiveModel = UserProgressHiveModel(userId: 'new_user');

        // Assert
        expect(hiveModel.totalKnowledge, equals(0));
        expect(hiveModel.rankIndex, equals(0));
        expect(hiveModel.coins, equals(100)); // Default coins
        expect(hiveModel.totalPlayTimeMinutes, equals(0));
        expect(hiveModel.loginStreak, equals(0));
        expect(hiveModel.hasCompletedTutorial, isFalse);
        expect(hiveModel.regionProgress, isEmpty);
        expect(hiveModel.countryProgress, isEmpty);
        expect(hiveModel.eraProgress, isEmpty);
        expect(hiveModel.completedDialogueIds, isEmpty);
        expect(hiveModel.unlockedRegionIds, isEmpty);
        expect(hiveModel.unlockedCountryIds, isEmpty);
        expect(hiveModel.unlockedEraIds, isEmpty);
        expect(hiveModel.achievementIds, isEmpty);
        expect(hiveModel.completedQuizIds, isEmpty);
        expect(hiveModel.inventoryIds, isEmpty);
        expect(hiveModel.lastPlayedAt, isNull);
        expect(hiveModel.lastPlayedEraId, isNull);
      });
    });

    group('immutability', () {
      test('toEntity creates independent copies of collections', () {
        // Arrange
        final hiveModel = UserProgressHiveModel(
          userId: 'test',
          unlockedRegionIds: ['asia'],
          completedQuizIds: ['q1'],
        );

        // Act
        final entity1 = hiveModel.toEntity();
        final entity2 = hiveModel.toEntity();

        // Assert - modifying one should not affect the other
        // (This tests that new list instances are created)
        expect(identical(entity1.unlockedRegionIds, entity2.unlockedRegionIds), isFalse);
        expect(identical(entity1.completedQuizIds, entity2.completedQuizIds), isFalse);
      });

      test('fromEntity creates independent copies of collections', () {
        // Arrange
        final entity = const UserProgress(
          userId: 'test',
          unlockedRegionIds: ['asia'],
          completedQuizIds: ['q1'],
        );

        // Act
        final hiveModel1 = UserProgressHiveModel.fromEntity(entity);
        final hiveModel2 = UserProgressHiveModel.fromEntity(entity);

        // Assert
        expect(identical(hiveModel1.unlockedRegionIds, hiveModel2.unlockedRegionIds), isFalse);
        expect(identical(hiveModel1.completedQuizIds, hiveModel2.completedQuizIds), isFalse);
      });
    });
  });
}
