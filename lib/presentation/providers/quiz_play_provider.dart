import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/app_durations.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/presentation/providers/achievement_providers.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Quiz Play State ==============

/// Quiz play session state
@immutable
class QuizPlayState {
  final int remainingTime;
  final String? selectedAnswer;
  final bool isSubmitted;
  final bool isCorrect;
  final bool wasAlreadyCompleted;
  final List<Achievement> unlockedAchievements;
  final bool isTimerFrozen;
  final bool isHintUsed;
  final bool isTimeFreezeUsed;
  final List<String> hiddenOptions;
  final bool timerStarted;

  const QuizPlayState({
    this.remainingTime = 0,
    this.selectedAnswer,
    this.isSubmitted = false,
    this.isCorrect = false,
    this.wasAlreadyCompleted = false,
    this.unlockedAchievements = const [],
    this.isTimerFrozen = false,
    this.isHintUsed = false,
    this.isTimeFreezeUsed = false,
    this.hiddenOptions = const [],
    this.timerStarted = false,
  });

  const QuizPlayState.initial() : this();

  QuizPlayState copyWith({
    int? remainingTime,
    String? selectedAnswer,
    bool clearSelectedAnswer = false,
    bool? isSubmitted,
    bool? isCorrect,
    bool? wasAlreadyCompleted,
    List<Achievement>? unlockedAchievements,
    bool? isTimerFrozen,
    bool? isHintUsed,
    bool? isTimeFreezeUsed,
    List<String>? hiddenOptions,
    bool? timerStarted,
  }) {
    return QuizPlayState(
      remainingTime: remainingTime ?? this.remainingTime,
      selectedAnswer: clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isCorrect: isCorrect ?? this.isCorrect,
      wasAlreadyCompleted: wasAlreadyCompleted ?? this.wasAlreadyCompleted,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      isTimerFrozen: isTimerFrozen ?? this.isTimerFrozen,
      isHintUsed: isHintUsed ?? this.isHintUsed,
      isTimeFreezeUsed: isTimeFreezeUsed ?? this.isTimeFreezeUsed,
      hiddenOptions: hiddenOptions ?? this.hiddenOptions,
      timerStarted: timerStarted ?? this.timerStarted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizPlayState &&
          runtimeType == other.runtimeType &&
          remainingTime == other.remainingTime &&
          selectedAnswer == other.selectedAnswer &&
          isSubmitted == other.isSubmitted &&
          isCorrect == other.isCorrect &&
          wasAlreadyCompleted == other.wasAlreadyCompleted &&
          listEquals(unlockedAchievements, other.unlockedAchievements) &&
          isTimerFrozen == other.isTimerFrozen &&
          isHintUsed == other.isHintUsed &&
          isTimeFreezeUsed == other.isTimeFreezeUsed &&
          listEquals(hiddenOptions, other.hiddenOptions) &&
          timerStarted == other.timerStarted;

  @override
  int get hashCode => Object.hash(
        remainingTime,
        selectedAnswer,
        isSubmitted,
        isCorrect,
        wasAlreadyCompleted,
        Object.hashAll(unlockedAchievements),
        isTimerFrozen,
        isHintUsed,
        isTimeFreezeUsed,
        Object.hashAll(hiddenOptions),
        timerStarted,
      );
}

// ============== Quiz Play Notifier ==============

/// Manages quiz play session state
class QuizPlayNotifier extends StateNotifier<QuizPlayState> {
  final UserProgressRepository _userProgressRepository;
  final Ref _ref;
  Timer? _timer;

  QuizPlayNotifier({
    required UserProgressRepository userProgressRepository,
    required Ref ref,
  })  : _userProgressRepository = userProgressRepository,
        _ref = ref,
        super(const QuizPlayState.initial());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Start the quiz timer with given seconds
  void startTimer(int seconds) {
    if (state.timerStarted) return;

    state = state.copyWith(
      remainingTime: seconds,
      timerStarted: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isTimerFrozen) return;

      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        submitAnswer(timeout: true);
      }
    });
  }

  /// Set selected answer
  void setSelectedAnswer(String answer) {
    if (state.isSubmitted) return;
    state = state.copyWith(selectedAnswer: answer);
  }

  /// Use hint item - hides 2 wrong answers
  Future<bool> useHint({
    required String correctAnswer,
    required List<String> allOptions,
    required Future<bool> Function(String) consumeItem,
  }) async {
    if (state.isHintUsed || state.isSubmitted) return false;

    final success = await consumeItem('item_hint_01');
    if (!success) return false;

    // Extract wrong options
    final wrongOptions = allOptions.where((o) => o != correctAnswer).toList();

    // Randomly hide 2 wrong options
    List<String> hidden;
    if (wrongOptions.length > 2) {
      wrongOptions.shuffle(Random());
      hidden = wrongOptions.take(2).toList();
    } else {
      hidden = wrongOptions;
    }

    // If selected answer is in hidden options, clear selection
    final shouldClearSelection = hidden.contains(state.selectedAnswer);

    state = state.copyWith(
      isHintUsed: true,
      hiddenOptions: hidden,
      clearSelectedAnswer: shouldClearSelection,
    );

    return true;
  }

  /// Use time freeze item - pauses timer for 10 seconds
  Future<bool> useTimeFreeze({
    required Future<bool> Function(String) consumeItem,
  }) async {
    if (state.isTimeFreezeUsed || state.isSubmitted) return false;

    final success = await consumeItem('item_time_freeze_01');
    if (!success) return false;

    state = state.copyWith(
      isTimeFreezeUsed: true,
      isTimerFrozen: true,
    );

    // Resume timer after freeze duration
    Timer(AppDurations.timeFreezeItem, () {
      if (mounted) {
        state = state.copyWith(isTimerFrozen: false);
      }
    });

    return true;
  }

  /// Submit the answer and process results
  Future<void> submitAnswer({
    bool timeout = false,
    Quiz? quiz,
    UserProgress? userProgress,
  }) async {
    _timer?.cancel();

    if (state.isSubmitted) return;

    bool isCorrect = false;
    if (!timeout && quiz != null && state.selectedAnswer != null) {
      isCorrect = quiz.checkAnswer(state.selectedAnswer!);
    }

    state = state.copyWith(
      isSubmitted: true,
      isCorrect: isCorrect,
    );

    // Process correct answer
    if (isCorrect && quiz != null && userProgress != null) {
      final alreadyCompleted = userProgress.isQuizCompleted(quiz.id);

      state = state.copyWith(wasAlreadyCompleted: alreadyCompleted);

      if (!alreadyCompleted) {
        await _processNewCorrectAnswer(quiz, userProgress);
      }
    }
  }

  Future<void> _processNewCorrectAnswer(Quiz quiz, UserProgress userProgress) async {
    // Update progress with points and completed quiz
    var newProgress = userProgress.copyWith(
      totalKnowledge: userProgress.totalKnowledge + quiz.basePoints,
      completedQuizIds: [...userProgress.completedQuizIds, quiz.id],
    );

    // Check achievements
    final achievementService = _ref.read(achievementServiceProvider);
    final unlocked = achievementService.checkAllAfterQuiz(
      userProgress: newProgress,
      completedQuiz: quiz,
      quizCategory: null,
    );

    // Process unlocked achievements
    if (unlocked.isNotEmpty) {
      final bonusPoints = achievementService.calculateBonusPoints(unlocked);
      newProgress = newProgress.copyWith(
        achievementIds: [
          ...newProgress.achievementIds,
          ...unlocked.map((a) => a.id),
        ],
        totalKnowledge: newProgress.totalKnowledge + bonusPoints,
      );

      state = state.copyWith(unlockedAchievements: unlocked);

      // Add to achievement notifier
      _ref.read(achievementNotifierProvider.notifier).addUnlockedAchievements(unlocked);
    }

    // Save progress
    await _userProgressRepository.saveUserProgress(newProgress);

    // Invalidate user progress provider to refresh
    _ref.invalidate(userProgressProvider);
  }

  /// Reset state for a new quiz
  void reset() {
    _timer?.cancel();
    state = const QuizPlayState.initial();
  }
}

// ============== Provider ==============

/// Provider family for quiz play sessions
/// Each quizId gets its own notifier instance
final quizPlayProvider = StateNotifierProvider.autoDispose
    .family<QuizPlayNotifier, QuizPlayState, String>((ref, quizId) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return QuizPlayNotifier(
    userProgressRepository: repository,
    ref: ref,
  );
});
