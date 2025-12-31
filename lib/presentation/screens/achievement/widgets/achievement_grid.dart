import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'achievement_card.dart';
import 'achievement_detail_sheet.dart';

/// 업적 그리드
class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final List<String> unlockedIds;

  const AchievementGrid({
    super.key,
    required this.achievements,
    required this.unlockedIds,
  });

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const Center(
        child: Text(
          '이 카테고리에 업적이 없습니다.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isUnlocked = unlockedIds.contains(achievement.id);
        
        return AchievementCard(
          achievement: achievement,
          isUnlocked: isUnlocked,
          onTap: () => _showAchievementDetail(context, achievement, isUnlocked),
        );
      },
    );
  }

  void _showAchievementDetail(BuildContext context, Achievement achievement, bool isUnlocked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AchievementDetailSheet(
        achievement: achievement,
        isUnlocked: isUnlocked,
      ),
    );
  }
}
