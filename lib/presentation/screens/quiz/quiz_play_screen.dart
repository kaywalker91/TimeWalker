import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/quiz_play_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/quiz_item_button.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/quiz_option_card.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/quiz_result_sheet.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/quiz_timer_widget.dart';

class QuizPlayScreen extends ConsumerWidget {
  final String quizId;

  const QuizPlayScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));
    final quizState = ref.watch(quizPlayProvider(quizId));

    return Scaffold(
      backgroundColor: AppColors.darkSheet,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: quizAsync.when(
          data: (quiz) {
            if (quiz == null) {
              return Center(child: Text(AppLocalizations.of(context)!.quiz_not_found));
            }

            // Start timer if not started
            if (!quizState.timerStarted && !quizState.isSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(quizPlayProvider(quizId).notifier).startTimer(quiz.timeLimitSeconds);
              });
            }

            return _QuizPlayContent(
              quizId: quizId,
              quiz: quiz,
              quizState: quizState,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.quiz_play_title),
      backgroundColor: AppColors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.white24),
        ),
        title: Text(
          AppLocalizations.of(context)!.quiz_help_title,
          style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          AppLocalizations.of(context)!.quiz_help_msg,
          style: const TextStyle(color: AppColors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_close, style: const TextStyle(color: AppColors.amber)),
          ),
        ],
      ),
    );
  }
}

// ============== Quiz Play Content ==============

class _QuizPlayContent extends ConsumerWidget {
  final String quizId;
  final Quiz quiz;
  final QuizPlayState quizState;

  const _QuizPlayContent({
    required this.quizId,
    required this.quiz,
    required this.quizState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 600;
        final questionFontSize = isSmallScreen ? 18.0 : 22.0;
        final spacing = isSmallScreen ? 20.0 : 32.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - (isSmallScreen ? 32 : 48),
            ),
            child: IntrinsicHeight(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isSmallScreen ? 0 : 20),
                    QuizTimerWidget(
                      remainingTime: quizState.remainingTime,
                      totalTime: quiz.timeLimitSeconds,
                      isTimerFrozen: quizState.isTimerFrozen,
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: spacing),
                    _QuizQuestion(
                      question: quiz.question,
                      fontSize: questionFontSize,
                    ),
                    SizedBox(height: spacing),
                    ...quiz.options.map((option) => QuizOptionCard(
                          quizId: quizId,
                          option: option,
                          quiz: quiz,
                          quizState: quizState,
                        )),
                    const Spacer(),
                    SizedBox(height: spacing),
                    if (!quizState.isSubmitted)
                      userProgressAsync.when(
                        data: (userProgress) {
                          return _QuizActionBar(
                            quizId: quizId,
                            quiz: quiz,
                            quizState: quizState,
                            userProgress: userProgress,
                          );
                        },
                        loading: () => const SizedBox(height: 48),
                        error: (e, s) => const SizedBox(height: 48),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============== Quiz Question ==============

class _QuizQuestion extends StatelessWidget {
  final String question;
  final double fontSize;

  const _QuizQuestion({
    required this.question,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      question,
      style: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ============== Quiz Action Bar ==============

class _QuizActionBar extends ConsumerWidget {
  final String quizId;
  final Quiz quiz;
  final QuizPlayState quizState;
  final dynamic userProgress;

  const _QuizActionBar({
    required this.quizId,
    required this.quiz,
    required this.quizState,
    required this.userProgress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hintCount = userProgress.inventoryIds.where((id) => id == 'item_hint_01').length;
    final freezeCount = userProgress.inventoryIds.where((id) => id == 'item_time_freeze_01').length;
    final hasHint = userProgress.inventoryIds.contains('item_hint_01');
    final hasFreeze = userProgress.inventoryIds.contains('item_time_freeze_01');

    return Row(
      children: [
        Expanded(
          child: QuizItemButton(
            icon: Icons.lightbulb,
            label: 'Hint',
            count: hintCount,
            isEnabled: !quizState.isHintUsed && hasHint,
            onTap: () => _useHint(context, ref),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: QuizItemButton(
            icon: Icons.hourglass_top,
            label: 'Freeze',
            count: freezeCount,
            isEnabled: !quizState.isTimeFreezeUsed && hasFreeze,
            onTap: () => _useTimeFreeze(context, ref),
            color: AppColors.cyanAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: quizState.selectedAnswer != null
                ? () {
                    HapticFeedback.mediumImpact();
                    _submitAnswer(context, ref);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              disabledBackgroundColor: AppColors.white10,
            ),
            child: Text(
              AppLocalizations.of(context)!.quiz_submit,
              style: TextStyle(
                color: quizState.selectedAnswer != null ? AppColors.background : AppColors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _useHint(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(quizPlayProvider(quizId).notifier);
    final success = await notifier.useHint(
      correctAnswer: quiz.correctAnswer,
      allOptions: quiz.options,
      consumeItem: (itemId) => ref.read(userProgressProvider.notifier).consumeItem(itemId),
    );

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('힌트 사용! 오답이 제거되었습니다.'), backgroundColor: AppColors.secondary),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아이템 사용 실패!'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _useTimeFreeze(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(quizPlayProvider(quizId).notifier);
    final success = await notifier.useTimeFreeze(
      consumeItem: (itemId) => ref.read(userProgressProvider.notifier).consumeItem(itemId),
    );

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('크로노스 타임 스톱! 시간이 10초간 멈춥니다.'), backgroundColor: AppColors.info),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아이템 사용 실패!'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _submitAnswer(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quizPlayProvider(quizId).notifier);
    notifier.submitAnswer(
      quiz: quiz,
      userProgress: userProgress,
    );

    // Show result sheet after state update
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        _showResultSheet(context, ref);
      }
    });
  }

  void _showResultSheet(BuildContext context, WidgetRef ref) {
    final state = ref.read(quizPlayProvider(quizId));
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => QuizResultSheet(
        quiz: quiz,
        isCorrect: state.isCorrect,
        wasAlreadyCompleted: state.wasAlreadyCompleted,
        unlockedAchievements: state.unlockedAchievements,
      ),
    );
  }
}
