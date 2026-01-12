import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

import '../../../helpers/test_utils.dart';

void main() {
  group('UserProgress', () {
    // =========================================================
    // 기본 생성 및 copyWith 테스트
    // =========================================================
    group('생성자 및 copyWith', () {
      test('기본값으로 생성 시 올바른 초기값을 가져야 함', () {
        // When: 필수 필드만으로 생성
        const progress = UserProgress(userId: 'test_user');

        // Then: 기본값 검증
        expect(progress.userId, equals('test_user'));
        expect(progress.totalKnowledge, equals(0));
        expect(progress.rank, equals(ExplorerRank.novice));
        expect(progress.completedDialogueIds, isEmpty);
        expect(progress.unlockedRegionIds, isEmpty);
        expect(progress.hasCompletedTutorial, isFalse);
      });

      test('copyWith으로 특정 필드만 변경 가능해야 함', () {
        // Given: 초기 UserProgress
        final original = createMockUserProgress(
          totalKnowledge: 1000,
          rank: ExplorerRank.novice,
        );

        // When: copyWith으로 지식 포인트만 변경
        final updated = original.copyWith(totalKnowledge: 2000);

        // Then: 변경된 필드만 업데이트, 나머지는 유지
        expect(updated.totalKnowledge, equals(2000));
        expect(updated.rank, equals(ExplorerRank.novice)); // 변경 안 됨
        expect(updated.userId, equals(original.userId));
      });

      test('copyWith으로 여러 필드 동시 변경 가능해야 함', () {
        // Given
        final original = createMockUserProgress();

        // When: 여러 필드 동시 변경
        final updated = original.copyWith(
          totalKnowledge: 5000,
          rank: ExplorerRank.expert,
          coins: 10000,
        );

        // Then
        expect(updated.totalKnowledge, equals(5000));
        expect(updated.rank, equals(ExplorerRank.expert));
        expect(updated.coins, equals(10000));
      });
    });

    // =========================================================
    // 해금 상태 확인 메서드 테스트
    // =========================================================
    group('해금 상태 확인', () {
      test('isRegionUnlocked - 해금된 지역은 true 반환', () {
        // Given
        final progress = createMockUserProgress(
          unlockedRegionIds: ['asia', 'europe'],
        );

        // Then
        expect(progress.isRegionUnlocked('asia'), isTrue);
        expect(progress.isRegionUnlocked('europe'), isTrue);
        expect(progress.isRegionUnlocked('africa'), isFalse);
      });

      test('isRegionUnlocked - americas와 north_america/south_america 호환성', () {
        // Given: americas가 해금된 경우
        final progress = createMockUserProgress(
          unlockedRegionIds: ['americas'],
        );

        // Then: north_america, south_america도 해금으로 간주
        expect(progress.isRegionUnlocked('americas'), isTrue);
        expect(progress.isRegionUnlocked('north_america'), isTrue);
        expect(progress.isRegionUnlocked('south_america'), isTrue);
      });

      test('isCountryUnlocked - 해금된 국가 확인', () {
        // Given
        final progress = createMockUserProgress(
          unlockedCountryIds: ['korea', 'china'],
        );

        // Then
        expect(progress.isCountryUnlocked('korea'), isTrue);
        expect(progress.isCountryUnlocked('china'), isTrue);
        expect(progress.isCountryUnlocked('japan'), isFalse);
      });

      test('isEraUnlocked - 해금된 시대 확인', () {
        // Given
        final progress = createMockUserProgress(
          unlockedEraIds: ['joseon', 'three_kingdoms'],
        );

        // Then
        expect(progress.isEraUnlocked('joseon'), isTrue);
        expect(progress.isEraUnlocked('three_kingdoms'), isTrue);
        expect(progress.isEraUnlocked('goryeo'), isFalse);
      });

      test('isCharacterUnlocked - 해금된 인물 확인', () {
        // Given
        final progress = createMockUserProgress(
          unlockedCharacterIds: ['sejong', 'yi_sun_sin'],
        );

        // Then
        expect(progress.isCharacterUnlocked('sejong'), isTrue);
        expect(progress.isCharacterUnlocked('yi_sun_sin'), isTrue);
        expect(progress.isCharacterUnlocked('gwanggaeto'), isFalse);
      });

      test('isDialogueCompleted - 완료된 대화 확인', () {
        // Given
        final progress = createMockUserProgress(
          completedDialogueIds: ['sejong_intro', 'sejong_hangul'],
        );

        // Then
        expect(progress.isDialogueCompleted('sejong_intro'), isTrue);
        expect(progress.isDialogueCompleted('sejong_hangul'), isTrue);
        expect(progress.isDialogueCompleted('admiral_yi_intro'), isFalse);
      });

      test('isQuizCompleted - 완료된 퀴즈 확인', () {
        // Given
        final progress = createMockUserProgress(
          completedQuizIds: ['quiz_1', 'quiz_2'],
        );

        // Then
        expect(progress.isQuizCompleted('quiz_1'), isTrue);
        expect(progress.isQuizCompleted('quiz_2'), isTrue);
        expect(progress.isQuizCompleted('quiz_3'), isFalse);
      });
    });

    // =========================================================
    // 진행률 계산 테스트
    // =========================================================
    group('진행률 계산', () {
      test('getRegionProgress - 지역 진행률 가져오기', () {
        // Given
        final progress = createMockUserProgress().copyWith(
          regionProgress: {'asia': 0.75, 'europe': 0.5},
        );

        // Then
        expect(progress.getRegionProgress('asia'), equals(0.75));
        expect(progress.getRegionProgress('europe'), equals(0.5));
        expect(progress.getRegionProgress('africa'), equals(0.0)); // 없으면 0
      });

      test('getEraProgress - 시대 진행률 가져오기', () {
        // Given
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'joseon': 1.0, 'three_kingdoms': 0.6},
        );

        // Then
        expect(progress.getEraProgress('joseon'), equals(1.0));
        expect(progress.getEraProgress('three_kingdoms'), equals(0.6));
        expect(progress.getEraProgress('goryeo'), equals(0.0));
      });

      test('overallProgress - 전체 진행률 계산', () {
        // Given: 여러 시대의 진행률
        final progress = createMockUserProgress().copyWith(
          eraProgress: {
            'joseon': 1.0,      // 100%
            'three_kingdoms': 0.5, // 50%
            'goryeo': 0.0,     // 0%
          },
        );

        // Then: 평균 = (1.0 + 0.5 + 0.0) / 3 = 0.5
        expect(progress.overallProgress, equals(0.5));
      });

      test('overallProgress - 시대가 없으면 0 반환', () {
        // Given: 시대 진행 없음
        final progress = createMockUserProgress().copyWith(
          eraProgress: {},
        );

        // Then
        expect(progress.overallProgress, equals(0.0));
      });
    });

    // =========================================================
    // 등급 관련 테스트
    // =========================================================
    group('등급 계산', () {
      test('pointsToNextRank - 다음 등급까지 필요한 포인트', () {
        // Given: novice 등급, 500 포인트
        final progress = createMockUserProgress(
          rank: ExplorerRank.novice,
          totalKnowledge: 500,
        );

        // Then: 다음 등급(apprentice = 1000)까지 500 필요
        final pointsNeeded = progress.pointsToNextRank;
        expect(pointsNeeded, greaterThan(0));
      });

      test('rankProgress - 현재 등급 내 진행률', () {
        // Given
        final progress = createMockUserProgress(
          rank: ExplorerRank.novice,
          totalKnowledge: 500,
        );

        // Then: 0.0 ~ 1.0 사이 값
        expect(progress.rankProgress, greaterThanOrEqualTo(0.0));
        expect(progress.rankProgress, lessThanOrEqualTo(1.0));
      });
    });

    // =========================================================
    // 통계 관련 테스트
    // =========================================================
    group('통계', () {
      test('completedDialogueCount - 완료한 대화 수', () {
        // Given
        final progress = createMockUserProgress(
          completedDialogueIds: ['d1', 'd2', 'd3'],
        );

        // Then
        expect(progress.completedDialogueCount, equals(3));
      });

      test('unlockedCharacterCount - 해금한 인물 수', () {
        // Given
        final progress = createMockUserProgress(
          unlockedCharacterIds: ['sejong', 'yi_sun_sin'],
        );

        // Then
        expect(progress.unlockedCharacterCount, equals(2));
      });

      test('completedQuizCount - 완료한 퀴즈 수', () {
        // Given
        final progress = createMockUserProgress(
          completedQuizIds: List.generate(15, (i) => 'quiz_$i'),
        );

        // Then
        expect(progress.completedQuizCount, equals(15));
      });

      test('totalPlayTimeFormatted - 플레이 시간 포맷팅', () {
        // Given: 125분 = 2시간 5분
        final progress = createMockUserProgress().copyWith(
          totalPlayTimeMinutes: 125,
        );

        // Then
        expect(progress.totalPlayTimeFormatted, equals('2시간 5분'));
      });

      test('totalPlayTimeFormatted - 1시간 미만', () {
        // Given: 45분
        final progress = createMockUserProgress().copyWith(
          totalPlayTimeMinutes: 45,
        );

        // Then
        expect(progress.totalPlayTimeFormatted, equals('45분'));
      });
    });

    // =========================================================
    // 도감 관련 테스트
    // =========================================================
    group('도감', () {
      test('isEncyclopediaDiscovered - 발견 여부 확인', () {
        // Given
        final progress = createMockUserProgress().copyWith(
          encyclopediaDiscoveryDates: {
            'entry_1': DateTime(2024, 1, 15),
            'entry_2': DateTime(2024, 1, 16),
          },
        );

        // Then
        expect(progress.isEncyclopediaDiscovered('entry_1'), isTrue);
        expect(progress.isEncyclopediaDiscovered('entry_2'), isTrue);
        expect(progress.isEncyclopediaDiscovered('entry_3'), isFalse);
      });

      test('getEncyclopediaDiscoveryDate - 발견 날짜 반환', () {
        // Given
        final discoveryDate = DateTime(2024, 1, 15);
        final progress = createMockUserProgress().copyWith(
          encyclopediaDiscoveryDates: {'entry_1': discoveryDate},
        );

        // Then
        expect(progress.getEncyclopediaDiscoveryDate('entry_1'), equals(discoveryDate));
        expect(progress.getEncyclopediaDiscoveryDate('entry_2'), isNull);
      });

      test('discoveredEncyclopediaCount - 발견한 도감 수', () {
        // Given
        final progress = createMockUserProgress().copyWith(
          encyclopediaDiscoveryDates: {
            'entry_1': DateTime(2024, 1, 15),
            'entry_2': DateTime(2024, 1, 16),
            'entry_3': DateTime(2024, 1, 17),
          },
        );

        // Then
        expect(progress.discoveredEncyclopediaCount, equals(3));
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성을 가진 두 객체는 같아야 함', () {
        // Given
        final progress1 = createMockUserProgress(
          userId: 'same_user',
          totalKnowledge: 1000,
        );
        final progress2 = createMockUserProgress(
          userId: 'same_user',
          totalKnowledge: 1000,
        );

        // Then
        expect(progress1, equals(progress2));
      });

      test('다른 속성을 가진 두 객체는 달라야 함', () {
        // Given
        final progress1 = createMockUserProgress(totalKnowledge: 1000);
        final progress2 = createMockUserProgress(totalKnowledge: 2000);

        // Then
        expect(progress1, isNot(equals(progress2)));
      });
    });

    // =========================================================
    // 하위 엔티티 변환 테스트 (Phase 3 리팩토링)
    // =========================================================
    group('하위 엔티티 변환', () {
      test('toUserProfile - UserProgress에서 UserProfile로 변환', () {
        // Given
        final progress = createMockUserProgress(
          userId: 'user_123',
          rank: ExplorerRank.advanced,
          coins: 5000,
        );

        // When
        final profile = progress.toUserProfile();

        // Then
        expect(profile.userId, equals('user_123'));
        expect(profile.rank, equals(ExplorerRank.advanced));
        expect(profile.coins, equals(5000));
        expect(profile.hasCompletedTutorial, equals(progress.hasCompletedTutorial));
      });

      test('toExplorationState - UserProgress에서 ExplorationState로 변환', () {
        // Given
        final progress = createMockUserProgress(
          totalKnowledge: 3000,
          eraProgress: {'joseon': 0.8, 'goryeo': 0.5},
        );

        // When
        final exploration = progress.toExplorationState();

        // Then
        expect(exploration.totalKnowledge, equals(3000));
        expect(exploration.eraProgress, equals({'joseon': 0.8, 'goryeo': 0.5}));
      });

      test('toUnlockState - UserProgress에서 UnlockState로 변환', () {
        // Given
        final progress = createMockUserProgress(
          unlockedRegionIds: ['asia', 'europe'],
          unlockedEraIds: ['joseon', 'goryeo'],
          unlockedCharacterIds: ['sejong'],
        );

        // When
        final unlock = progress.toUnlockState();

        // Then
        expect(unlock.unlockedRegionIds, equals(['asia', 'europe']));
        expect(unlock.unlockedEraIds, equals(['joseon', 'goryeo']));
        expect(unlock.unlockedCharacterIds, equals(['sejong']));
      });

      test('toCompletionState - UserProgress에서 CompletionState로 변환', () {
        // Given
        final progress = createMockUserProgress(
          completedDialogueIds: ['d1', 'd2'],
          completedQuizIds: ['q1'],
          achievementIds: ['ach_1'],
        );

        // When
        final completion = progress.toCompletionState();

        // Then
        expect(completion.completedDialogueIds, equals(['d1', 'd2']));
        expect(completion.completedQuizIds, equals(['q1']));
        expect(completion.achievementIds, equals(['ach_1']));
      });

      test('fromComponents - 분리된 엔티티들로부터 UserProgress 재조합', () {
        // Given: 원본 UserProgress
        final original = createMockUserProgress(
          userId: 'user_123',
          totalKnowledge: 5000,
          rank: ExplorerRank.advanced,
          coins: 10000,
          unlockedRegionIds: ['asia', 'europe'],
          unlockedEraIds: ['joseon'],
          completedDialogueIds: ['d1', 'd2'],
          completedQuizIds: ['q1', 'q2'],
        );

        // When: 분리 후 재조합
        final profile = original.toUserProfile();
        final exploration = original.toExplorationState();
        final unlock = original.toUnlockState();
        final completion = original.toCompletionState();

        final reconstructed = UserProgress.fromComponents(
          profile: profile,
          exploration: exploration,
          unlock: unlock,
          completion: completion,
        );

        // Then: 원본과 동일해야 함
        expect(reconstructed.userId, equals(original.userId));
        expect(reconstructed.totalKnowledge, equals(original.totalKnowledge));
        expect(reconstructed.rank, equals(original.rank));
        expect(reconstructed.coins, equals(original.coins));
        expect(reconstructed.unlockedRegionIds, equals(original.unlockedRegionIds));
        expect(reconstructed.unlockedEraIds, equals(original.unlockedEraIds));
        expect(reconstructed.completedDialogueIds, equals(original.completedDialogueIds));
        expect(reconstructed.completedQuizIds, equals(original.completedQuizIds));
      });

      test('변환 메서드는 원본을 변경하지 않아야 함 (불변성)', () {
        // Given
        final original = createMockUserProgress(
          unlockedRegionIds: ['asia'],
        );

        // When: 변환 수행
        final unlock = original.toUnlockState();

        // Then: 원본 목록이 변경되지 않았는지 확인
        expect(original.unlockedRegionIds, equals(['asia']));
        expect(unlock.unlockedRegionIds, equals(['asia']));
        
        // 반환된 목록이 원본과 다른 인스턴스인지 확인
        expect(identical(original.unlockedRegionIds, unlock.unlockedRegionIds), isFalse);
      });
    });
  });
}
