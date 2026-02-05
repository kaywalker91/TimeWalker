import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';
import 'achievement_stats_badges.dart';

/// 업적 상세 바텀시트
class AchievementDetailSheet extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const AchievementDetailSheet({
    super.key,
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final color = achievement.rarity.color.toColor();
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 아이콘
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: isUnlocked
                        ? LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.4),
                              color.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUnlocked ? null : AppColors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked ? color : AppColors.white24,
                      width: 2,
                    ),
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isUnlocked ? Icons.emoji_events : Icons.emoji_events_outlined,
                    size: 48,
                    color: isUnlocked ? color : AppColors.white38,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 상태 배지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppColors.green.withValues(alpha: 0.2)
                        : AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isUnlocked ? AppColors.green : AppColors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUnlocked ? Icons.check_circle : Icons.lock_outline,
                        size: 14,
                        color: isUnlocked ? AppColors.green : AppColors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isUnlocked ? '달성 완료' : '미달성',
                        style: TextStyle(
                          color: isUnlocked ? AppColors.green : AppColors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // 제목
                Text(
                  achievement.titleKorean,
                  style: TextStyle(
                    color: isUnlocked ? AppColors.white : AppColors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                
                // 설명
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    achievement.description,
                    style: const TextStyle(
                      color: AppColors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                
                // 정보 행
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 희귀도
                    InfoBadge(
                      icon: Icons.star,
                      label: '희귀도',
                      value: achievement.rarity.displayName,
                      color: color,
                    ),
                    
                    // 카테고리 (이모지 사용)
                    InfoBadgeWithEmoji(
                      emoji: achievement.category.icon,
                      label: '카테고리',
                      value: achievement.category.displayName,
                      color: AppColors.white70,
                    ),
                    
                    // 보너스 포인트
                    if (achievement.bonusPoints > 0)
                      InfoBadge(
                        icon: Icons.add_circle,
                        label: '보너스',
                        value: '+${achievement.bonusPoints}pt',
                        color: AppColors.amber,
                      ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 닫기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUnlocked ? color : AppColors.white24,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('닫기'),
                  ),
                ),
                
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
