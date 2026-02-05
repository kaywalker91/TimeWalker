import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/themes/app_text_styles.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/core/routes/app_router.dart';

class QuizCard extends StatefulWidget {
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
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        if (widget.showReviewMode && widget.isCompleted) {
          if (widget.onDetailShow != null) {
            widget.onDetailShow!();
          }
        } else {
          AppRouter.goToQuizPlay(context, widget.quiz.id);
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isCompleted 
                ? AppColors.quizCardCompleted.withValues(alpha: 0.8)
                : AppColors.quizCardDefault.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isCompleted
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Glass effect overlay (using gradient for simulation)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.white.withValues(alpha: 0.1),
                        AppColors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Type Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              widget.quiz.type.displayName,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (widget.isCompleted)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: AppColors.white,
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Question
                      Text(
                        widget.quiz.question,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Bottom Row: Points, Time, Arrow
                      Row(
                        children: [
                          // Points
                          Icon(Icons.stars_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.quiz.basePoints} ${AppLocalizations.of(context)!.quiz_pts}',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Time
                          const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.quiz.timeLimitSeconds}s',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Action Arrow
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: widget.isCompleted ? AppColors.success : AppColors.textDisabled,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
