import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/completion_state.dart';

void main() {
  group('CompletionState', () {
    // =========================================================
    // 기본 생성 및 copyWith 테스트
    // =========================================================
    group('생성자 및 copyWith', () {
      test('기본값으로 생성 시 모든 목록이 비어있어야 함', () {
        // When
        const state = CompletionState();

        // Then
        expect(state.completedDialogueIds, isEmpty);
        expect(state.completedQuizIds, isEmpty);
        expect(state.encyclopediaDiscoveryDates, isEmpty);
        expect(state.achievementIds, isEmpty);
        expect(state.discoveredEncyclopediaIds, isEmpty);
      });

      test('모든 필드를 지정하여 생성 가능해야 함', () {
        // Given
        final now = DateTime.now();
        
        // When
        final state = CompletionState(
          completedDialogueIds: ['d1', 'd2'],
          completedQuizIds: ['q1', 'q2', 'q3'],
          encyclopediaDiscoveryDates: {'entry_1': now},
          achievementIds: ['ach_1'],
          discoveredEncyclopediaIds: ['old_entry'],
        );

        // Then
        expect(state.completedDialogueIds, equals(['d1', 'd2']));
        expect(state.completedQuizIds, equals(['q1', 'q2', 'q3']));
        expect(state.encyclopediaDiscoveryDates, equals({'entry_1': now}));
        expect(state.achievementIds, equals(['ach_1']));
        expect(state.discoveredEncyclopediaIds, equals(['old_entry']));
      });

      test('copyWith으로 특정 필드만 변경 가능해야 함', () {
        // Given
        const original = CompletionState(
          completedDialogueIds: ['d1'],
          completedQuizIds: ['q1'],
        );

        // When
        final updated = original.copyWith(
          completedDialogueIds: ['d1', 'd2'],
        );

        // Then
        expect(updated.completedDialogueIds, equals(['d1', 'd2']));
        expect(updated.completedQuizIds, equals(['q1'])); // 변경 안 됨
      });
    });

    // =========================================================
    // 완료 상태 확인 테스트
    // =========================================================
    group('완료 상태 확인', () {
      test('isDialogueCompleted - 대화 완료 여부', () {
        // Given
        const state = CompletionState(
          completedDialogueIds: ['sejong_intro', 'sejong_hangul'],
        );

        // Then
        expect(state.isDialogueCompleted('sejong_intro'), isTrue);
        expect(state.isDialogueCompleted('sejong_hangul'), isTrue);
        expect(state.isDialogueCompleted('admiral_yi_intro'), isFalse);
      });

      test('isQuizCompleted - 퀴즈 완료 여부', () {
        // Given
        const state = CompletionState(
          completedQuizIds: ['quiz_1', 'quiz_2'],
        );

        // Then
        expect(state.isQuizCompleted('quiz_1'), isTrue);
        expect(state.isQuizCompleted('quiz_2'), isTrue);
        expect(state.isQuizCompleted('quiz_3'), isFalse);
      });

      test('isEncyclopediaDiscovered - 새 방식 (encyclopediaDiscoveryDates)', () {
        // Given
        final state = CompletionState(
          encyclopediaDiscoveryDates: {
            'entry_1': DateTime(2024, 1, 15),
            'entry_2': DateTime(2024, 1, 16),
          },
        );

        // Then
        expect(state.isEncyclopediaDiscovered('entry_1'), isTrue);
        expect(state.isEncyclopediaDiscovered('entry_2'), isTrue);
        expect(state.isEncyclopediaDiscovered('entry_3'), isFalse);
      });

      test('isEncyclopediaDiscovered - deprecated 방식과 호환', () {
        // Given: deprecated 필드만 있는 경우 (하위 호환성)
        const state = CompletionState(
          discoveredEncyclopediaIds: ['old_entry_1', 'old_entry_2'],
        );

        // Then
        expect(state.isEncyclopediaDiscovered('old_entry_1'), isTrue);
        expect(state.isEncyclopediaDiscovered('old_entry_2'), isTrue);
      });

      test('hasAchievement - 업적 보유 여부', () {
        // Given
        const state = CompletionState(
          achievementIds: ['first_steps', 'quiz_master'],
        );

        // Then
        expect(state.hasAchievement('first_steps'), isTrue);
        expect(state.hasAchievement('quiz_master'), isTrue);
        expect(state.hasAchievement('explorer'), isFalse);
      });
    });

    // =========================================================
    // 발견 날짜 관련 테스트
    // =========================================================
    group('도감 발견 날짜', () {
      test('getEncyclopediaDiscoveryDate - 존재하는 항목', () {
        // Given
        final discoveryDate = DateTime(2024, 1, 15, 10, 30);
        final state = CompletionState(
          encyclopediaDiscoveryDates: {'entry_1': discoveryDate},
        );

        // Then
        expect(
          state.getEncyclopediaDiscoveryDate('entry_1'),
          equals(discoveryDate),
        );
      });

      test('getEncyclopediaDiscoveryDate - 존재하지 않는 항목', () {
        // Given
        const state = CompletionState();

        // Then
        expect(state.getEncyclopediaDiscoveryDate('entry_1'), isNull);
      });

      test('recentlyDiscoveredEncyclopediaIds - 최신순 정렬', () {
        // Given
        final state = CompletionState(
          encyclopediaDiscoveryDates: {
            'entry_1': DateTime(2024, 1, 15), // 가장 오래됨
            'entry_3': DateTime(2024, 1, 17), // 가장 최신
            'entry_2': DateTime(2024, 1, 16), // 중간
          },
        );

        // When
        final recentIds = state.recentlyDiscoveredEncyclopediaIds;

        // Then: 최신순 (내림차순)
        expect(recentIds, equals(['entry_3', 'entry_2', 'entry_1']));
      });
    });

    // =========================================================
    // 완료 처리 메서드 테스트
    // =========================================================
    group('완료 처리', () {
      test('completeDialogue - 새 대화 완료', () {
        // Given
        const state = CompletionState(
          completedDialogueIds: ['d1'],
        );

        // When
        final updated = state.completeDialogue('d2');

        // Then
        expect(updated.isDialogueCompleted('d1'), isTrue);
        expect(updated.isDialogueCompleted('d2'), isTrue);
        expect(state.isDialogueCompleted('d2'), isFalse); // 원본 불변
      });

      test('completeDialogue - 이미 완료된 대화는 중복 추가 안 됨', () {
        // Given
        const state = CompletionState(
          completedDialogueIds: ['d1'],
        );

        // When
        final updated = state.completeDialogue('d1');

        // Then
        expect(updated.completedDialogueIds, hasLength(1));
        expect(identical(state, updated), isTrue);
      });

      test('completeQuiz - 퀴즈 완료', () {
        // Given
        const state = CompletionState();

        // When
        final updated = state.completeQuiz('quiz_1');

        // Then
        expect(updated.isQuizCompleted('quiz_1'), isTrue);
      });

      test('discoverEncyclopedia - 도감 항목 발견', () {
        // Given
        const state = CompletionState();

        // When
        final updated = state.discoverEncyclopedia('entry_1');

        // Then
        expect(updated.isEncyclopediaDiscovered('entry_1'), isTrue);
        expect(updated.getEncyclopediaDiscoveryDate('entry_1'), isNotNull);
      });

      test('discoverEncyclopedia - 커스텀 날짜 지정', () {
        // Given
        const state = CompletionState();
        final customDate = DateTime(2024, 1, 15);

        // When
        final updated = state.discoverEncyclopedia('entry_1', customDate);

        // Then
        expect(
          updated.getEncyclopediaDiscoveryDate('entry_1'),
          equals(customDate),
        );
      });

      test('discoverEncyclopedia - 이미 발견된 항목은 중복 추가 안 됨', () {
        // Given
        final existingDate = DateTime(2024, 1, 15);
        final state = CompletionState(
          encyclopediaDiscoveryDates: {'entry_1': existingDate},
        );

        // When
        final newDate = DateTime(2024, 1, 20);
        final updated = state.discoverEncyclopedia('entry_1', newDate);

        // Then: 원래 날짜 유지
        expect(
          updated.getEncyclopediaDiscoveryDate('entry_1'),
          equals(existingDate),
        );
        expect(identical(state, updated), isTrue);
      });

      test('addAchievement - 업적 획득', () {
        // Given
        const state = CompletionState();

        // When
        final updated = state.addAchievement('first_steps');

        // Then
        expect(updated.hasAchievement('first_steps'), isTrue);
      });

      test('연속 완료 - 여러 항목 순차적으로 완료', () {
        // Given
        const state = CompletionState();

        // When
        final updated = state
            .completeDialogue('d1')
            .completeQuiz('q1')
            .discoverEncyclopedia('e1')
            .addAchievement('ach_1');

        // Then
        expect(updated.isDialogueCompleted('d1'), isTrue);
        expect(updated.isQuizCompleted('q1'), isTrue);
        expect(updated.isEncyclopediaDiscovered('e1'), isTrue);
        expect(updated.hasAchievement('ach_1'), isTrue);
      });
    });

    // =========================================================
    // 통계 테스트
    // =========================================================
    group('통계', () {
      test('completedDialogueCount - 완료한 대화 수', () {
        // Given
        const state = CompletionState(
          completedDialogueIds: ['d1', 'd2', 'd3'],
        );

        // Then
        expect(state.completedDialogueCount, equals(3));
      });

      test('completedQuizCount - 완료한 퀴즈 수', () {
        // Given
        const state = CompletionState(
          completedQuizIds: ['q1', 'q2'],
        );

        // Then
        expect(state.completedQuizCount, equals(2));
      });

      test('discoveredEncyclopediaCount - 발견한 도감 수', () {
        // Given
        final state = CompletionState(
          encyclopediaDiscoveryDates: {
            'e1': DateTime(2024, 1, 15),
            'e2': DateTime(2024, 1, 16),
            'e3': DateTime(2024, 1, 17),
          },
        );

        // Then
        expect(state.discoveredEncyclopediaCount, equals(3));
      });

      test('achievementCount - 획득한 업적 수', () {
        // Given
        const state = CompletionState(
          achievementIds: ['ach_1', 'ach_2'],
        );

        // Then
        expect(state.achievementCount, equals(2));
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성을 가진 두 객체는 같아야 함', () {
        // Given
        const state1 = CompletionState(
          completedDialogueIds: ['d1'],
          completedQuizIds: ['q1'],
        );
        const state2 = CompletionState(
          completedDialogueIds: ['d1'],
          completedQuizIds: ['q1'],
        );

        // Then
        expect(state1, equals(state2));
      });

      test('다른 속성을 가진 두 객체는 달라야 함', () {
        // Given
        const state1 = CompletionState(completedQuizIds: ['q1']);
        const state2 = CompletionState(completedQuizIds: ['q2']);

        // Then
        expect(state1, isNot(equals(state2)));
      });
    });

    // =========================================================
    // toString 테스트
    // =========================================================
    group('toString', () {
      test('toString이 각 카운트를 포함해야 함', () {
        // Given
        final state = CompletionState(
          completedDialogueIds: const ['d1', 'd2'],
          completedQuizIds: const ['q1'],
          encyclopediaDiscoveryDates: {'e1': DateTime.now()},
        );

        // When
        final result = state.toString();

        // Then
        expect(result, contains('CompletionState'));
        expect(result, contains('2')); // dialogues
        expect(result, contains('1')); // quizzes or encyclopedia
      });
    });
  });
}
