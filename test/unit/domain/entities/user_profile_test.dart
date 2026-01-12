import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_profile.dart';

void main() {
  group('UserProfile', () {
    // =========================================================
    // 기본 생성 및 copyWith 테스트
    // =========================================================
    group('생성자 및 copyWith', () {
      test('기본값으로 생성 시 올바른 초기값을 가져야 함', () {
        // When: 필수 필드만으로 생성
        const profile = UserProfile(userId: 'test_user');

        // Then: 기본값 검증
        expect(profile.userId, equals('test_user'));
        expect(profile.rank, equals(ExplorerRank.novice));
        expect(profile.coins, equals(0));
        expect(profile.loginStreak, equals(0));
        expect(profile.totalPlayTimeMinutes, equals(0));
        expect(profile.hasCompletedTutorial, isFalse);
        expect(profile.inventoryIds, isEmpty);
        expect(profile.lastPlayedAt, isNull);
        expect(profile.lastPlayedEraId, isNull);
      });

      test('모든 필드를 지정하여 생성 가능해야 함', () {
        // Given
        final now = DateTime.now();
        
        // When
        final profile = UserProfile(
          userId: 'user_123',
          rank: ExplorerRank.advanced,
          coins: 5000,
          loginStreak: 10,
          lastPlayedAt: now,
          lastPlayedEraId: 'joseon',
          totalPlayTimeMinutes: 120,
          hasCompletedTutorial: true,
          inventoryIds: ['item_1', 'item_2'],
        );

        // Then
        expect(profile.userId, equals('user_123'));
        expect(profile.rank, equals(ExplorerRank.advanced));
        expect(profile.coins, equals(5000));
        expect(profile.loginStreak, equals(10));
        expect(profile.lastPlayedAt, equals(now));
        expect(profile.lastPlayedEraId, equals('joseon'));
        expect(profile.totalPlayTimeMinutes, equals(120));
        expect(profile.hasCompletedTutorial, isTrue);
        expect(profile.inventoryIds, equals(['item_1', 'item_2']));
      });

      test('copyWith으로 특정 필드만 변경 가능해야 함', () {
        // Given
        const original = UserProfile(
          userId: 'test_user',
          rank: ExplorerRank.novice,
          coins: 1000,
        );

        // When
        final updated = original.copyWith(coins: 2000);

        // Then
        expect(updated.coins, equals(2000));
        expect(updated.userId, equals('test_user'));
        expect(updated.rank, equals(ExplorerRank.novice)); // 변경 안 됨
      });

      test('copyWith으로 여러 필드 동시 변경 가능해야 함', () {
        // Given
        const original = UserProfile(userId: 'test_user');

        // When
        final updated = original.copyWith(
          rank: ExplorerRank.expert,
          coins: 10000,
          loginStreak: 30,
          hasCompletedTutorial: true,
        );

        // Then
        expect(updated.rank, equals(ExplorerRank.expert));
        expect(updated.coins, equals(10000));
        expect(updated.loginStreak, equals(30));
        expect(updated.hasCompletedTutorial, isTrue);
      });
    });

    // =========================================================
    // 포맷팅 메서드 테스트
    // =========================================================
    group('포맷팅', () {
      test('totalPlayTimeFormatted - 1시간 이상', () {
        // Given: 125분 = 2시간 5분
        const profile = UserProfile(
          userId: 'test_user',
          totalPlayTimeMinutes: 125,
        );

        // Then
        expect(profile.totalPlayTimeFormatted, equals('2시간 5분'));
      });

      test('totalPlayTimeFormatted - 1시간 미만', () {
        // Given: 45분
        const profile = UserProfile(
          userId: 'test_user',
          totalPlayTimeMinutes: 45,
        );

        // Then
        expect(profile.totalPlayTimeFormatted, equals('45분'));
      });

      test('totalPlayTimeFormatted - 0분', () {
        // Given
        const profile = UserProfile(
          userId: 'test_user',
          totalPlayTimeMinutes: 0,
        );

        // Then
        expect(profile.totalPlayTimeFormatted, equals('0분'));
      });

      test('totalPlayTimeFormatted - 정확히 1시간', () {
        // Given: 60분 = 1시간 0분
        const profile = UserProfile(
          userId: 'test_user',
          totalPlayTimeMinutes: 60,
        );

        // Then
        expect(profile.totalPlayTimeFormatted, equals('1시간 0분'));
      });
    });

    // =========================================================
    // 등급 계산 테스트
    // =========================================================
    group('등급 계산', () {
      test('pointsToNextRank - 다음 등급까지 필요한 포인트', () {
        // Given: novice 등급
        const profile = UserProfile(
          userId: 'test_user',
          rank: ExplorerRank.novice,
        );

        // When
        final pointsNeeded = profile.pointsToNextRank(500);

        // Then: 다음 등급(apprentice = 1000)까지 필요한 포인트
        expect(pointsNeeded, greaterThan(0));
      });

      test('pointsToNextRank - 최고 등급일 때 0 반환', () {
        // Given: 최고 등급
        final maxRank = ExplorerRank.values.last;
        final profile = UserProfile(
          userId: 'test_user',
          rank: maxRank,
        );

        // When
        final pointsNeeded = profile.pointsToNextRank(100000);

        // Then
        expect(pointsNeeded, equals(0));
      });

      test('rankProgress - 진행률이 0.0 ~ 1.0 사이', () {
        // Given
        const profile = UserProfile(
          userId: 'test_user',
          rank: ExplorerRank.novice,
        );

        // When
        final progress = profile.rankProgress(500);

        // Then
        expect(progress, greaterThanOrEqualTo(0.0));
        expect(progress, lessThanOrEqualTo(1.0));
      });

      test('rankProgress - 최고 등급일 때 1.0 반환', () {
        // Given
        final maxRank = ExplorerRank.values.last;
        final profile = UserProfile(
          userId: 'test_user',
          rank: maxRank,
        );

        // When
        final progress = profile.rankProgress(100000);

        // Then
        expect(progress, equals(1.0));
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성을 가진 두 객체는 같아야 함', () {
        // Given
        const profile1 = UserProfile(
          userId: 'same_user',
          rank: ExplorerRank.advanced,
          coins: 1000,
        );
        const profile2 = UserProfile(
          userId: 'same_user',
          rank: ExplorerRank.advanced,
          coins: 1000,
        );

        // Then
        expect(profile1, equals(profile2));
      });

      test('다른 속성을 가진 두 객체는 달라야 함', () {
        // Given
        const profile1 = UserProfile(userId: 'user1', coins: 1000);
        const profile2 = UserProfile(userId: 'user1', coins: 2000);

        // Then
        expect(profile1, isNot(equals(profile2)));
      });
    });

    // =========================================================
    // toString 테스트
    // =========================================================
    group('toString', () {
      test('toString이 userId와 rank를 포함해야 함', () {
        // Given
        const profile = UserProfile(
          userId: 'test_user',
          rank: ExplorerRank.advanced,
        );

        // When
        final result = profile.toString();

        // Then
        expect(result, contains('test_user'));
        expect(result, contains('UserProfile'));
      });
    });
  });
}
