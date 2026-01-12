import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/quiz/quiz_entities.dart';

void main() {
  group('Quiz', () {
    // =========================================================
    // 생성자 및 기본 기능 테스트
    // =========================================================
    group('생성자 및 기본 기능', () {
      test('필수 필드로 Quiz 생성 가능', () {
        // When
        const quiz = Quiz(
          id: 'test_quiz_1',
          question: '한글을 만든 왕은?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['세종대왕', '태조', '정조', '고종'],
          correctAnswer: '세종대왕',
          explanation: '세종대왕이 1443년에 한글을 창제했습니다.',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.id, equals('test_quiz_1'));
        expect(quiz.question, equals('한글을 만든 왕은?'));
        expect(quiz.type, equals(QuizType.multipleChoice));
        expect(quiz.difficulty, equals(QuizDifficulty.easy));
        expect(quiz.options.length, equals(4));
        expect(quiz.correctAnswer, equals('세종대왕'));
        expect(quiz.basePoints, equals(10)); // 기본값
        expect(quiz.timeLimitSeconds, equals(30)); // 기본값
      });

      test('copyWith으로 특정 필드만 변경 가능', () {
        // Given
        const original = Quiz(
          id: 'quiz_1',
          question: 'Original question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'Original explanation',
          eraId: 'joseon',
        );

        // When
        final updated = original.copyWith(
          question: 'Updated question?',
          difficulty: QuizDifficulty.hard,
        );

        // Then
        expect(updated.question, equals('Updated question?'));
        expect(updated.difficulty, equals(QuizDifficulty.hard));
        expect(updated.id, equals(original.id)); // 변경 안 됨
        expect(updated.correctAnswer, equals(original.correctAnswer)); // 변경 안 됨
      });
    });

    // =========================================================
    // checkAnswer 테스트
    // =========================================================
    group('checkAnswer', () {
      test('정확한 답변은 true 반환', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'A is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswer('A'), isTrue);
      });

      test('대소문자 구분 없이 정답 확인', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['Answer', 'B', 'C', 'D'],
          correctAnswer: 'Answer',
          explanation: 'Answer is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswer('answer'), isTrue);
        expect(quiz.checkAnswer('ANSWER'), isTrue);
        expect(quiz.checkAnswer('AnSwEr'), isTrue);
      });

      test('잘못된 답변은 false 반환', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'A is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswer('B'), isFalse);
        expect(quiz.checkAnswer('C'), isFalse);
        expect(quiz.checkAnswer('D'), isFalse);
        expect(quiz.checkAnswer('Wrong'), isFalse);
      });
    });

    // =========================================================
    // checkAnswerByIndex 테스트
    // =========================================================
    group('checkAnswerByIndex', () {
      test('정답 인덱스는 true 반환', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A', // 인덱스 0
          explanation: 'A is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswerByIndex(0), isTrue);
      });

      test('오답 인덱스는 false 반환', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'A is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswerByIndex(1), isFalse);
        expect(quiz.checkAnswerByIndex(2), isFalse);
        expect(quiz.checkAnswerByIndex(3), isFalse);
      });

      test('범위 밖 인덱스는 false 반환', () {
        // Given
        const quiz = Quiz(
          id: 'quiz_1',
          question: 'Question?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'A is correct',
          eraId: 'joseon',
        );

        // Then
        expect(quiz.checkAnswerByIndex(-1), isFalse);
        expect(quiz.checkAnswerByIndex(4), isFalse);
        expect(quiz.checkAnswerByIndex(100), isFalse);
      });
    });

    // =========================================================
    // maxPoints 테스트
    // =========================================================
    group('maxPoints', () {
      test('난이도에 따른 최대 포인트 계산', () {
        // Given: 기본 포인트 10
        const easyQuiz = Quiz(
          id: 'easy',
          question: 'Easy?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
          basePoints: 10,
        );

        const mediumQuiz = Quiz(
          id: 'medium',
          question: 'Medium?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.medium,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
          basePoints: 10,
        );

        const hardQuiz = Quiz(
          id: 'hard',
          question: 'Hard?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.hard,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
          basePoints: 10,
        );

        // Then: 난이도 배율 적용
        expect(easyQuiz.maxPoints, equals(10 * QuizDifficulty.easy.pointMultiplier));
        expect(mediumQuiz.maxPoints, equals(10 * QuizDifficulty.medium.pointMultiplier));
        expect(hardQuiz.maxPoints, equals(10 * QuizDifficulty.hard.pointMultiplier));
      });
    });

    // =========================================================
    // fromJson 테스트
    // =========================================================
    group('fromJson', () {
      test('JSON에서 Quiz 객체 생성', () {
        // Given
        final json = {
          'id': 'json_quiz',
          'question': 'JSON Quiz Question?',
          'type': 'multipleChoice',
          'difficulty': 'medium',
          'options': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
          'correctAnswer': 'Option 1',
          'explanation': 'Because Option 1 is correct.',
          'eraId': 'joseon',
          'basePoints': 15,
          'timeLimitSeconds': 45,
        };

        // When
        final quiz = Quiz.fromJson(json);

        // Then
        expect(quiz.id, equals('json_quiz'));
        expect(quiz.question, equals('JSON Quiz Question?'));
        expect(quiz.type, equals(QuizType.multipleChoice));
        expect(quiz.difficulty, equals(QuizDifficulty.medium));
        expect(quiz.options.length, equals(4));
        expect(quiz.correctAnswer, equals('Option 1'));
        expect(quiz.basePoints, equals(15));
        expect(quiz.timeLimitSeconds, equals(45));
      });

      test('선택적 필드 누락 시 기본값 사용', () {
        // Given: 최소 필드만 포함
        final json = {
          'id': 'minimal_quiz',
          'question': 'Minimal?',
          'type': 'trueFalse',
          'difficulty': 'easy',
          'options': ['True', 'False'],
          'correctAnswer': 'True',
          'explanation': 'True is correct.',
          'eraId': 'goryeo',
        };

        // When
        final quiz = Quiz.fromJson(json);

        // Then: 기본값 적용
        expect(quiz.basePoints, equals(10));
        expect(quiz.timeLimitSeconds, equals(30));
        expect(quiz.imageAsset, isNull);
        expect(quiz.relatedFactId, isNull);
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성의 두 Quiz는 같아야 함', () {
        // Given
        const quiz1 = Quiz(
          id: 'same_quiz',
          question: 'Same?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
        );

        const quiz2 = Quiz(
          id: 'same_quiz',
          question: 'Same?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
        );

        // Then
        expect(quiz1, equals(quiz2));
      });

      test('다른 id를 가진 Quiz는 달라야 함', () {
        // Given
        const quiz1 = Quiz(
          id: 'quiz_1',
          question: 'Same?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
        );

        const quiz2 = Quiz(
          id: 'quiz_2',
          question: 'Same?',
          type: QuizType.multipleChoice,
          difficulty: QuizDifficulty.easy,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: 'A',
          eraId: 'joseon',
        );

        // Then
        expect(quiz1, isNot(equals(quiz2)));
      });
    });
  });
}
