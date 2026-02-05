import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_walker/domain/entities/quiz/quiz_entity.dart';
import 'package:time_walker/domain/entities/quiz/quiz_enums.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/quiz_play_provider.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockUserProgressRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(createMockUserProgress());
  });

  setUp(() {
    mockRepository = MockUserProgressRepository();
    container = ProviderContainer(
      overrides: [
        // We need to override the repository provider
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('QuizPlayState', () {
    test('initial state has correct default values', () {
      const state = QuizPlayState.initial();

      expect(state.remainingTime, 0);
      expect(state.selectedAnswer, isNull);
      expect(state.isSubmitted, false);
      expect(state.isCorrect, false);
      expect(state.wasAlreadyCompleted, false);
      expect(state.unlockedAchievements, isEmpty);
      expect(state.isTimerFrozen, false);
      expect(state.isHintUsed, false);
      expect(state.isTimeFreezeUsed, false);
      expect(state.hiddenOptions, isEmpty);
      expect(state.timerStarted, false);
    });

    test('copyWith creates new instance with updated values', () {
      const initial = QuizPlayState.initial();

      final updated = initial.copyWith(
        remainingTime: 30,
        selectedAnswer: 'Option A',
        isSubmitted: true,
        isCorrect: true,
      );

      expect(updated.remainingTime, 30);
      expect(updated.selectedAnswer, 'Option A');
      expect(updated.isSubmitted, true);
      expect(updated.isCorrect, true);
      expect(updated.wasAlreadyCompleted, false); // unchanged
    });

    test('copyWith with clearSelectedAnswer clears selected answer', () {
      const state = QuizPlayState(selectedAnswer: 'Option A');

      final cleared = state.copyWith(clearSelectedAnswer: true);

      expect(cleared.selectedAnswer, isNull);
    });

    test('equality comparison works correctly', () {
      const state1 = QuizPlayState(remainingTime: 30, selectedAnswer: 'A');
      const state2 = QuizPlayState(remainingTime: 30, selectedAnswer: 'A');
      const state3 = QuizPlayState(remainingTime: 25, selectedAnswer: 'A');

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('hashCode is consistent with equality', () {
      const state1 = QuizPlayState(remainingTime: 30, selectedAnswer: 'A');
      const state2 = QuizPlayState(remainingTime: 30, selectedAnswer: 'A');

      expect(state1.hashCode, equals(state2.hashCode));
    });
  });

  group('QuizPlayNotifier', () {
    late QuizPlayNotifier notifier;
    late MockRef mockRef;

    setUp(() {
      mockRef = MockRef();
      notifier = QuizPlayNotifier(
        userProgressRepository: mockRepository,
        ref: mockRef,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state is QuizPlayState.initial', () {
      expect(notifier.state, const QuizPlayState.initial());
    });

    test('startTimer sets timer state and starts countdown', () async {
      notifier.startTimer(30);

      expect(notifier.state.timerStarted, true);
      expect(notifier.state.remainingTime, 30);

      // Wait for timer tick
      await Future.delayed(const Duration(seconds: 1, milliseconds: 100));

      expect(notifier.state.remainingTime, 29);
    });

    test('startTimer does nothing if already started', () {
      notifier.startTimer(30);
      notifier.startTimer(60); // second call should be ignored

      expect(notifier.state.remainingTime, 30);
    });

    test('setSelectedAnswer updates selected answer', () {
      notifier.setSelectedAnswer('Option B');

      expect(notifier.state.selectedAnswer, 'Option B');
    });

    test('setSelectedAnswer does nothing when already submitted', () {
      // Submit first
      notifier.submitAnswer(timeout: true);

      // Try to set answer
      notifier.setSelectedAnswer('Option B');

      expect(notifier.state.selectedAnswer, isNull);
    });

    test('useHint sets isHintUsed and hiddenOptions', () async {
      final success = await notifier.useHint(
        correctAnswer: 'Correct',
        allOptions: ['Correct', 'Wrong1', 'Wrong2', 'Wrong3'],
        consumeItem: (_) async => true,
      );

      expect(success, true);
      expect(notifier.state.isHintUsed, true);
      expect(notifier.state.hiddenOptions.length, 2);
      expect(notifier.state.hiddenOptions, isNot(contains('Correct')));
    });

    test('useHint fails when already used', () async {
      // First use
      await notifier.useHint(
        correctAnswer: 'Correct',
        allOptions: ['Correct', 'Wrong1', 'Wrong2'],
        consumeItem: (_) async => true,
      );

      // Second use should fail
      final success = await notifier.useHint(
        correctAnswer: 'Correct',
        allOptions: ['Correct', 'Wrong1', 'Wrong2'],
        consumeItem: (_) async => true,
      );

      expect(success, false);
    });

    test('useHint fails when consumeItem returns false', () async {
      final success = await notifier.useHint(
        correctAnswer: 'Correct',
        allOptions: ['Correct', 'Wrong1', 'Wrong2'],
        consumeItem: (_) async => false,
      );

      expect(success, false);
      expect(notifier.state.isHintUsed, false);
    });

    test('useHint clears selected answer if it was a hidden option', () async {
      notifier.setSelectedAnswer('Wrong1');

      await notifier.useHint(
        correctAnswer: 'Correct',
        allOptions: ['Correct', 'Wrong1'], // only 1 wrong option
        consumeItem: (_) async => true,
      );

      // Since Wrong1 is hidden, selection should be cleared
      expect(notifier.state.selectedAnswer, isNull);
    });

    test('useTimeFreeze sets freeze state', () async {
      final success = await notifier.useTimeFreeze(
        consumeItem: (_) async => true,
      );

      expect(success, true);
      expect(notifier.state.isTimeFreezeUsed, true);
      expect(notifier.state.isTimerFrozen, true);
    });

    test('useTimeFreeze fails when already used', () async {
      // First use
      await notifier.useTimeFreeze(consumeItem: (_) async => true);

      // Second use should fail
      final success = await notifier.useTimeFreeze(
        consumeItem: (_) async => true,
      );

      expect(success, false);
    });

    test('submitAnswer sets submitted state', () async {
      await notifier.submitAnswer(timeout: true);

      expect(notifier.state.isSubmitted, true);
      expect(notifier.state.isCorrect, false);
    });

    test('submitAnswer with correct answer sets isCorrect', () async {
      final quiz = _createTestQuiz(correctAnswer: 'Correct');
      notifier.setSelectedAnswer('Correct');

      // Use wasAlreadyCompleted = true to skip achievement processing
      final progress = createMockUserProgress().copyWith(
        completedQuizIds: [quiz.id], // Mark as already completed
      );

      await notifier.submitAnswer(
        quiz: quiz,
        userProgress: progress,
      );

      expect(notifier.state.isSubmitted, true);
      expect(notifier.state.isCorrect, true);
      expect(notifier.state.wasAlreadyCompleted, true);
    });

    test('submitAnswer with wrong answer sets isCorrect false', () async {
      final quiz = _createTestQuiz(correctAnswer: 'Correct');
      notifier.setSelectedAnswer('Wrong');

      await notifier.submitAnswer(
        quiz: quiz,
        userProgress: createMockUserProgress(),
      );

      expect(notifier.state.isSubmitted, true);
      expect(notifier.state.isCorrect, false);
    });

    test('timer freezes when isTimerFrozen is true', () async {
      notifier.startTimer(30);
      await notifier.useTimeFreeze(consumeItem: (_) async => true);

      final timeBefore = notifier.state.remainingTime;

      // Wait for timer tick
      await Future.delayed(const Duration(seconds: 1, milliseconds: 100));

      // Time should not have changed because timer is frozen
      expect(notifier.state.remainingTime, timeBefore);
    });

    test('reset clears all state', () async {
      notifier.startTimer(30);
      notifier.setSelectedAnswer('Option A');
      await notifier.submitAnswer(timeout: false);

      notifier.reset();

      expect(notifier.state, const QuizPlayState.initial());
    });
  });
}

/// Create a test quiz with customizable correct answer
Quiz _createTestQuiz({required String correctAnswer}) {
  return Quiz(
    id: 'test_quiz',
    eraId: 'test_era',
    question: 'Test question?',
    type: QuizType.multipleChoice,
    options: ['Correct', 'Wrong', 'Also Wrong', 'Still Wrong'],
    correctAnswer: correctAnswer,
    explanation: 'Test explanation',
    difficulty: QuizDifficulty.easy,
    basePoints: 10,
    timeLimitSeconds: 30,
  );
}

/// Mock Ref for testing
class MockRef extends Mock implements Ref {}

/// Create mock user progress for testing
UserProgress createMockUserProgress() {
  return const UserProgress(
    userId: 'test_user',
    totalKnowledge: 100,
    completedDialogueIds: [],
    completedQuizIds: [],
    unlockedEraIds: ['era_1'],
    unlockedCharacterIds: ['char_1'],
    achievementIds: [],
    inventoryIds: [],
    unlockedCountryIds: [],
    unlockedRegionIds: [],
  );
}
