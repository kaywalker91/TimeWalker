import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/presentation/providers/quiz_play_provider.dart';

/// Option card widget for quiz answers
class QuizOptionCard extends ConsumerWidget {
  final String quizId;
  final String option;
  final Quiz quiz;
  final QuizPlayState quizState;

  const QuizOptionCard({
    super.key,
    required this.quizId,
    required this.option,
    required this.quiz,
    required this.quizState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (quizState.hiddenOptions.contains(option)) {
      return _buildHiddenOption();
    }

    final isSelected = quizState.selectedAnswer == option;
    final isCorrectAnswer = quiz.checkAnswer(option);

    Color borderColor = AppColors.white12;
    Color bgColor = AppColors.white.withValues(alpha: 0.05);
    IconData? statusIcon;
    Color statusColor = AppColors.transparent;

    if (quizState.isSubmitted) {
      if (isCorrectAnswer) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.2);
        statusIcon = Icons.check_circle;
        statusColor = AppColors.success;
      } else if (isSelected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.2);
        statusIcon = Icons.cancel;
        statusColor = AppColors.error;
      }
    } else if (isSelected) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withValues(alpha: 0.15);
    }

    return GestureDetector(
      onTap: quizState.isSubmitted
          ? null
          : () {
              HapticFeedback.selectionClick();
              ref.read(quizPlayProvider(quizId).notifier).setSelectedAnswer(option);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected || (quizState.isSubmitted && (isCorrectAnswer || isSelected)) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildLeadingIcon(isSelected, isCorrectAnswer, statusIcon, statusColor),
            if (!quizState.isSubmitted) const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenOption() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white10),
      ),
      child: const Center(
        child: Text('???', style: TextStyle(color: AppColors.white24, letterSpacing: 2)),
      ),
    );
  }

  Widget _buildLeadingIcon(bool isSelected, bool isCorrectAnswer, IconData? statusIcon, Color statusColor) {
    if (quizState.isSubmitted && statusIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
        ],
      );
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : AppColors.white10,
      ),
      child: Text(
        '${quiz.options.indexOf(option) + 1}',
        style: TextStyle(
          color: isSelected ? AppColors.black : AppColors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
