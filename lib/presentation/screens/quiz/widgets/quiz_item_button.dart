import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// Reusable item button for quiz power-ups (Hint, Time Freeze)
class QuizItemButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isEnabled;
  final VoidCallback onTap;
  final Color color;

  const QuizItemButton({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.isEnabled,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white10,
        disabledBackgroundColor: AppColors.white10,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isEnabled ? color.withValues(alpha: 0.5) : AppColors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isEnabled ? color : AppColors.grey, size: 24),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isEnabled ? AppColors.white : AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isEnabled ? color : AppColors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
