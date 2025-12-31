import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/core/routes/app_router.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final bool isCompleted;
  final bool showReviewMode;
  final VoidCallback? onDetailShow;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.isCompleted,
    this.showReviewMode = false,
    this.onDetailShow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted 
          ? AppColors.quizCardCompleted
          : AppColors.quizCardDefault,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (showReviewMode && isCompleted) {
            if (onDetailShow != null) {
              onDetailShow!();
            }
          } else {
            AppRouter.goToQuizPlay(context, quiz.id);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              quiz.type.displayName,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 12, color: Colors.green),
                                  SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.common_completed,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${quiz.basePoints} ${AppLocalizations.of(context)!.quiz_pts}',
                        style: TextStyle(
                          color: isCompleted ? Colors.green : Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quiz.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(
                        '${quiz.timeLimitSeconds}${AppLocalizations.of(context)!.quiz_sec}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        showReviewMode && isCompleted
                            ? AppLocalizations.of(context)!.quiz_view_explanation
                            : (isCompleted ? AppLocalizations.of(context)!.quiz_retry : AppLocalizations.of(context)!.quiz_start_challenge),
                        style: TextStyle(
                          color: isCompleted ? Colors.green : Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        showReviewMode && isCompleted 
                            ? Icons.menu_book 
                            : Icons.arrow_forward_ios, 
                        size: 12, 
                        color: isCompleted ? Colors.green : Colors.blueAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
