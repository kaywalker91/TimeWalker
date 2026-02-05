import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/achievement_unlock_card.dart';

/// Bottom sheet showing quiz result with explanation and achievements
class QuizResultSheet extends StatelessWidget {
  final Quiz quiz;
  final bool isCorrect;
  final bool wasAlreadyCompleted;
  final List<Achievement> unlockedAchievements;

  const QuizResultSheet({
    super.key,
    required this.quiz,
    required this.isCorrect,
    required this.wasAlreadyCompleted,
    required this.unlockedAchievements,
  });

  String _getEraButtonLabel(BuildContext context, String eraId) {
    final l10n = AppLocalizations.of(context)!;
    switch (eraId) {
      case 'korea_joseon':
        return l10n.quiz_move_to_joseon;
      case 'korea_three_kingdoms':
        return l10n.quiz_move_to_three_kingdoms;
      case 'korea_goryeo':
        return l10n.quiz_move_to_goryeo;
      case 'korea_gaya':
        return l10n.quiz_move_to_gaya;
      case 'korea_ancient':
        return l10n.quiz_move_to_ancient;
      default:
        return l10n.quiz_move_to_era;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResultHeader(context),
          const SizedBox(height: 16),
          _buildExplanation(context),
          const SizedBox(height: 24),
          if (unlockedAchievements.isNotEmpty) _buildAchievements(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildResultHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCorrect ? Icons.check_circle : Icons.error,
          color: isCorrect ? AppColors.success : AppColors.error,
          size: 32,
        ),
        const SizedBox(width: 12),
        Text(
          isCorrect
              ? (wasAlreadyCompleted
                  ? AppLocalizations.of(context)!.quiz_correct_review
                  : AppLocalizations.of(context)!.quiz_correct_points(quiz.basePoints))
              : AppLocalizations.of(context)!.quiz_incorrect,
          style: AppTextStyles.headlineSmall.copyWith(
            color: isCorrect ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExplanation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.quiz_explanation,
            style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            quiz.explanation,
            style: const TextStyle(color: AppColors.white70, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      children: [
        const Text(
          "Unlocked Achievements!",
          style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ...unlockedAchievements.map((achievement) => AchievementUnlockCard(achievement: achievement)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (!isCorrect)
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                AppLocalizations.of(context)!.common_close,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ),
        if (!isCorrect) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (isCorrect) {
                AppRouter.goToEraExploration(context, quiz.eraId);
              } else {
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? AppColors.success : AppColors.secondary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: Text(
              isCorrect ? _getEraButtonLabel(context, quiz.eraId) : AppLocalizations.of(context)!.common_close,
              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
