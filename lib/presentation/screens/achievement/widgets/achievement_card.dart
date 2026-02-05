import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';

/// 업적 카드 위젯
class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final VoidCallback onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = achievement.rarity.color.toColor();
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked 
              ? color.withValues(alpha: 0.15)
              : AppColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? color : AppColors.white.withValues(alpha: 0.1),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // 시크릿 업적이면서 미해금 시 숨김 처리
            if (achievement.isSecret && !isUnlocked) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '???',
                      style: TextStyle(
                        color: AppColors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '비밀 업적',
                      style: TextStyle(
                        color: AppColors.white24,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 아이콘
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnlocked 
                            ? color.withValues(alpha: 0.2)
                            : AppColors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isUnlocked ? Icons.emoji_events : Icons.emoji_events_outlined,
                        size: 32,
                        color: isUnlocked ? color : AppColors.white38,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // 제목
                    Text(
                      achievement.titleKorean,
                      style: TextStyle(
                        color: isUnlocked ? AppColors.white : AppColors.white54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // 설명
                    Text(
                      achievement.description,
                      style: TextStyle(
                        color: isUnlocked ? AppColors.white70 : AppColors.white38,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // 희귀도 배지
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUnlocked 
                            ? color.withValues(alpha: 0.3)
                            : AppColors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        achievement.rarity.displayName,
                        style: TextStyle(
                          color: isUnlocked ? color : AppColors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // 해금 체크 마크
            if (isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
