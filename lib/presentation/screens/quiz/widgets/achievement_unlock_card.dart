import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';

/// 업적 달성 알림 카드
/// 
/// 퀴즈 정답 시 새로 달성한 업적을 표시하는 카드 위젯
class AchievementUnlockCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final rarityColor = achievement.rarity.color.toColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rarityColor.withValues(alpha: 0.3),
            rarityColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rarityColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: rarityColor.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // 업적 아이콘
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: rarityColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: rarityColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // 업적 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.celebration, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    const Text(
                      '업적 달성!',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.titleKorean,
                  style: TextStyle(
                    color: rarityColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          
          // 보너스 포인트
          if (achievement.bonusPoints > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${achievement.bonusPoints}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
