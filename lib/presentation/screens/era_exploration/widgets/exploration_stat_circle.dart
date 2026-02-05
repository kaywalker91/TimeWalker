import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// Circular progress stat widget for exploration statistics
class ExplorationStatCircle extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const ExplorationStatCircle({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total * 100).round() : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 4,
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.white.withValues(alpha: 0.1),
                ),
              ),
              // Progress circle
              CircularProgressIndicator(
                value: total > 0 ? count / total : 0,
                strokeWidth: 4,
                backgroundColor: AppColors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              // Percentage text
              Text(
                '$percentage%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$count개',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey500,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
