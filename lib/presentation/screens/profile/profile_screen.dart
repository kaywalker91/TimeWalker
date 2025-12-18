import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);
    final encyclopediaStatsAsync = ref.watch(encyclopediaListProvider);
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Explorer Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: userProgressAsync.when(
        data: (userProgress) {
          return encyclopediaStatsAsync.when(
            data: (allEntries) {
              final totalEntries = allEntries.length;
              final unlockedEntries = userProgress.unlockedFactIds.length + 
                                      userProgress.unlockedCharacterIds.length;
              
              final collectionRate = totalEntries > 0 ? unlockedEntries / totalEntries : 0.0;
              final explorationRate = userProgress.overallProgress;

              return SingleChildScrollView(
                padding: EdgeInsets.all(responsive.padding(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. User Avatar & Rank
                    _buildUserHeader(userProgress, responsive),
                    SizedBox(height: responsive.spacing(32)),

                    // 2. Rank Progress
                    _buildRankProgress(userProgress, responsive),
                    SizedBox(height: responsive.spacing(32)),

                    // 3. Stats Dashboard (Circular Charts)
                    responsive.isLandscape || responsive.deviceType == DeviceType.tablet
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _buildStatCircles(userProgress, explorationRate, collectionRate, responsive),
                          )
                        : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: responsive.spacing(16),
                            runSpacing: responsive.spacing(16),
                            children: _buildStatCircles(userProgress, explorationRate, collectionRate, responsive),
                          ),
                    SizedBox(height: responsive.spacing(48)),

                    // 4. Detailed Stats List
                    _buildStatTile(
                      'Total Playtime',
                      userProgress.totalPlayTimeFormatted,
                      Icons.timer,
                      responsive,
                    ),
                    _buildStatTile(
                      'Eras Visited',
                      '${userProgress.unlockedEraIds.length} Eras',
                      Icons.history_edu,
                      responsive,
                    ),
                    _buildStatTile(
                      'Dialogues Completed',
                      '${userProgress.completedDialogueIds.length}',
                      Icons.chat_bubble_outline,
                      responsive,
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Failed to load stats', style: TextStyle(color: Colors.white)),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  List<Widget> _buildStatCircles(UserProgress userProgress, double explorationRate, double collectionRate, ResponsiveUtils responsive) {
    return [
      _buildCircularStat(
        'Exploration',
        explorationRate,
        Colors.blueAccent,
        icon: Icons.map,
        responsive: responsive,
      ),
      _buildCircularStat(
        'Collection',
        collectionRate,
        Colors.purpleAccent,
        icon: Icons.book,
        responsive: responsive,
      ),
      _buildCircularStat(
        'Knowledge',
        (userProgress.totalKnowledge / 1000).clamp(0.0, 1.0),
        Colors.amber,
        icon: Icons.lightbulb,
        overrideText: userProgress.totalKnowledge.toString(),
        responsive: responsive,
      ),
    ];
  }

  Widget _buildUserHeader(UserProgress userProgress, ResponsiveUtils responsive) {
    final avatarRadius = responsive.isSmallPhone ? 40.0 : 50.0;
    final iconSize = responsive.iconSize(50);
    final nameFontSize = responsive.fontSize(24);
    final rankFontSize = responsive.fontSize(14);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey[800],
            child: Icon(Icons.person, size: iconSize, color: Colors.white),
          ),
        ),
        SizedBox(height: responsive.spacing(16)),
        Text(
          'Time Walker',
          style: TextStyle(
            color: Colors.white,
            fontSize: nameFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacing(8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.padding(12),
            vertical: responsive.padding(4),
          ),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
          ),
          child: Text(
            userProgress.rank.displayName,
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: rankFontSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankProgress(UserProgress userProgress, ResponsiveUtils responsive) {
    final fontSize = responsive.fontSize(14);
    final smallFontSize = responsive.fontSize(12);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rank Progress',
              style: TextStyle(color: Colors.white70, fontSize: fontSize),
            ),
            Text(
              '${userProgress.pointsToNextRank} pts to next rank',
              style: TextStyle(color: Colors.white38, fontSize: smallFontSize),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing(8)),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: userProgress.rankProgress,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation(Colors.amber),
            minHeight: responsive.isSmallPhone ? 8 : 10,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularStat(
    String label,
    double progress,
    Color color, {
    required IconData icon,
    required ResponsiveUtils responsive,
    String? overrideText,
  }) {
    final circleSize = responsive.isSmallPhone ? 60.0 : 80.0;
    final strokeWidth = responsive.isSmallPhone ? 6.0 : 8.0;
    final iconSize = responsive.iconSize(30);
    final labelFontSize = responsive.fontSize(14);
    final percentFontSize = responsive.fontSize(12);
    final valueFontSize = responsive.fontSize(16);
    
    return Column(
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: strokeWidth,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Center(
                child: overrideText != null
                    ? Text(
                        overrideText,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: valueFontSize,
                        ),
                      )
                    : Icon(icon, color: color, size: iconSize),
              ),
            ],
          ),
        ),
        SizedBox(height: responsive.spacing(12)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (overrideText == null) ...[
          SizedBox(height: responsive.spacing(4)),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: percentFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, ResponsiveUtils responsive) {
    final fontSize = responsive.fontSize(16);
    final iconSize = responsive.iconSize(20);
    final tilePadding = responsive.padding(16);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
      padding: EdgeInsets.all(tilePadding),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C3E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(10)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white70, size: iconSize),
          ),
          SizedBox(width: responsive.spacing(16)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: fontSize,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
