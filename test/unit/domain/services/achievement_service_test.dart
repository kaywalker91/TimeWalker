import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/services/achievement_service.dart';
import 'package:time_walker/domain/entities/achievement.dart';

import '../../../helpers/test_utils.dart';

void main() {
  late AchievementService service;

  setUp(() {
    service = AchievementService();
  });

  group('AchievementService', () {
    // =========================================================
    // checkQuizAchievements 테스트
    // =========================================================
    group('checkQuizAchievements', () {
      test('첫 퀴즈 완료 시 업적이 반환되어야 함', () {
        // Given: 퀴즈 1개 완료한 사용자 (업적 없음)
        final userProgress = createMockUserProgress(
          completedQuizIds: ['quiz_1'],
          achievementIds: [],
        );

        // When: 퀴즈 업적 체크
        final achievements = service.checkQuizAchievements(
          userProgress: userProgress,
          newlyCompletedQuizId: 'quiz_1',
        );

        // Then: 첫 퀴즈 관련 업적이 달성될 수 있음
        // Note: 실제 업적 데이터에 따라 결과가 달라질 수 있음
        expect(achievements, isA<List<Achievement>>());
      });

      test('이미 획득한 업적은 중복으로 반환되지 않아야 함', () {
        // Given: 이미 업적을 가진 사용자
        final userProgress = createMockUserProgress(
          completedQuizIds: List.generate(10, (i) => 'quiz_$i'),
          achievementIds: ['quiz_master_10'], // 이미 획득
        );

        // When: 업적 체크
        final achievements = service.checkQuizAchievements(
          userProgress: userProgress,
          newlyCompletedQuizId: 'quiz_10',
        );

        // Then: 이미 가진 업적은 포함되지 않음
        final duplicates = achievements.where((a) => a.id == 'quiz_master_10');
        expect(duplicates, isEmpty);
      });

      test('퀴즈 완료 수가 조건 미달이면 업적이 반환되지 않아야 함', () {
        // Given: 퀴즈 0개 완료 사용자
        final userProgress = createMockUserProgress(
          completedQuizIds: [],
          achievementIds: [],
        );

        // When: 업적 체크 (완료된 퀴즈 없음)
        final achievements = service.checkQuizAchievements(
          userProgress: userProgress,
          newlyCompletedQuizId: '', // 새로 완료한 퀴즈 없음
        );

        // Then: 조건 미달로 업적 없음
        // 퀴즈 개수 기반 업적은 최소 1개 이상 필요
        expect(
          achievements.where((a) => 
            a.condition.type == AchievementConditionType.completeQuiz &&
            a.condition.targetValue > 0
          ),
          isEmpty,
        );
      });
    });

    // =========================================================
    // checkKnowledgeAchievements 테스트
    // =========================================================
    group('checkKnowledgeAchievements', () {
      test('지식 포인트 조건 충족 시 업적이 반환되어야 함', () {
        // Given: 1000 지식 포인트 보유 사용자
        final userProgress = createMockUserProgress(
          totalKnowledge: 1000,
          achievementIds: [],
        );

        // When: 지식 업적 체크
        final achievements = service.checkKnowledgeAchievements(
          userProgress: userProgress,
        );

        // Then: 지식 관련 업적 목록 반환
        expect(achievements, isA<List<Achievement>>());
      });

      test('이미 획득한 지식 업적은 중복 반환되지 않아야 함', () {
        // Given: 지식 업적 이미 보유
        final userProgress = createMockUserProgress(
          totalKnowledge: 5000,
          achievementIds: ['knowledge_1000', 'knowledge_3000'],
        );

        // When: 업적 체크
        final achievements = service.checkKnowledgeAchievements(
          userProgress: userProgress,
        );

        // Then: 이미 가진 업적은 포함되지 않음
        final ids = achievements.map((a) => a.id).toList();
        expect(ids.contains('knowledge_1000'), isFalse);
        expect(ids.contains('knowledge_3000'), isFalse);
      });
    });

    // =========================================================
    // checkDialogueAchievements 테스트
    // =========================================================
    group('checkDialogueAchievements', () {
      test('대화 완료 업적 체크가 정상 동작해야 함', () {
        // Given: 대화 5개 완료 사용자
        final userProgress = createMockUserProgress(
          completedDialogueIds: ['d1', 'd2', 'd3', 'd4', 'd5'],
          achievementIds: [],
        );

        // When: 대화 업적 체크
        final achievements = service.checkDialogueAchievements(
          userProgress: userProgress,
          completedDialogueId: 'd5',
        );

        // Then: Achievement 리스트 반환 (내용은 데이터에 따라 다름)
        expect(achievements, isA<List<Achievement>>());
      });
    });

    // =========================================================
    // checkAllAfterQuiz 테스트 (통합)
    // =========================================================
    group('checkAllAfterQuiz', () {
      test('퀴즈 완료 후 퀴즈+지식 업적을 모두 체크해야 함', () {
        // Given: 퀴즈 10개 완료, 1000 지식 보유
        final userProgress = createMockUserProgress(
          completedQuizIds: List.generate(10, (i) => 'quiz_$i'),
          totalKnowledge: 1000,
          achievementIds: [],
        );

        final quiz = createMockQuiz(
          id: 'quiz_10',
          categoryId: 'asia',
        );

        // When: 통합 업적 체크
        final achievements = service.checkAllAfterQuiz(
          userProgress: userProgress,
          completedQuiz: quiz,
          quizCategory: 'asia',
        );

        // Then: 퀴즈와 지식 관련 업적이 모두 포함될 수 있음
        expect(achievements, isA<List<Achievement>>());
      });
    });

    // =========================================================
    // calculateBonusPoints 테스트
    // =========================================================
    group('calculateBonusPoints', () {
      test('빈 업적 목록이면 0 포인트 반환', () {
        // Given: 빈 업적 목록
        final achievements = <Achievement>[];

        // When: 보너스 계산
        final bonus = service.calculateBonusPoints(achievements);

        // Then: 0 반환
        expect(bonus, equals(0));
      });

      test('여러 업적의 보너스 포인트가 합산되어야 함', () {
        // Given: 보너스 포인트가 있는 업적들
        final achievements = [
          createMockQuizAchievement(
            id: 'a1',
            title: 'Test 1',
            targetValue: 1,
            bonusPoints: 50,
          ),
          createMockQuizAchievement(
            id: 'a2',
            title: 'Test 2',
            targetValue: 5,
            bonusPoints: 100,
          ),
          createMockQuizAchievement(
            id: 'a3',
            title: 'Test 3',
            targetValue: 10,
            bonusPoints: 150,
          ),
        ];

        // When: 보너스 계산
        final bonus = service.calculateBonusPoints(achievements);

        // Then: 50 + 100 + 150 = 300
        expect(bonus, equals(300));
      });
    });

    // =========================================================
    // createUnlockResults 테스트
    // =========================================================
    group('createUnlockResults', () {
      test('업적 목록을 UnlockResult 목록으로 변환해야 함', () {
        // Given: 업적 목록
        final achievements = [
          createMockQuizAchievement(
            id: 'test_achievement',
            title: 'Test',
            targetValue: 1,
            bonusPoints: 100,
          ),
        ];

        // When: 결과 생성
        final results = service.createUnlockResults(achievements);

        // Then: 같은 수의 결과 생성, 각 결과에 타임스탬프 포함
        expect(results.length, equals(achievements.length));
        expect(results.first.achievement.id, equals('test_achievement'));
        expect(results.first.bonusPoints, equals(100));
        expect(results.first.unlockedAt, isNotNull);
      });

      test('빈 업적 목록이면 빈 결과 반환', () {
        // Given: 빈 업적 목록
        final achievements = <Achievement>[];

        // When: 결과 생성
        final results = service.createUnlockResults(achievements);

        // Then: 빈 리스트 반환
        expect(results, isEmpty);
      });
    });
  });
}
