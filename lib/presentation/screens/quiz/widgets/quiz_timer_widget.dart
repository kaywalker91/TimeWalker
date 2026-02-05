import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// Circular timer widget displaying remaining quiz time
class QuizTimerWidget extends StatelessWidget {
  final int remainingTime;
  final int totalTime;
  final bool isTimerFrozen;
  final bool isSmallScreen;

  const QuizTimerWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
    required this.isTimerFrozen,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmallScreen ? 80.0 : 100.0;
    final isLowTime = remainingTime < 5;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isTimerFrozen
                          ? AppColors.cyanAccent
                          : (isLowTime ? AppColors.red : AppColors.primary))
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Background
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: AppColors.transparent,
              valueColor: AlwaysStoppedAnimation(
                AppColors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Progress
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: remainingTime / totalTime,
                end: remainingTime / totalTime,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    isTimerFrozen
                        ? AppColors.cyanAccent
                        : (isLowTime ? AppColors.red : AppColors.primary),
                  ),
                );
              },
            ),
          ),
          // Time Text
          if (isTimerFrozen)
            Icon(Icons.lock_clock, color: AppColors.cyanAccent, size: isSmallScreen ? 24 : 32)
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$remainingTime',
                  style: TextStyle(
                    color: isLowTime ? AppColors.red : AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 20 : 28,
                    height: 1.0,
                  ),
                ),
                Text(
                  'sec',
                  style: TextStyle(
                    color: AppColors.white54,
                    fontSize: isSmallScreen ? 10 : 12,
                    height: 1.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
