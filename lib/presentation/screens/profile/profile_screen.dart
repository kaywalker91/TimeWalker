import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/themes.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 프로필 화면
/// 
/// "시간의 문" 테마 - 탐험가 프로필
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);
    final encyclopediaStatsAsync = ref.watch(encyclopediaListProvider);
    final responsive = context.responsive;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: userProgressAsync.when(
            data: (userProgress) {
              return encyclopediaStatsAsync.when(
                data: (allEntries) {
                  final totalEntries = allEntries.length;
                  final unlockedEntries = userProgress.unlockedFactIds.length + 
                                          userProgress.unlockedCharacterIds.length;
                  
                  final collectionRate = totalEntries > 0 ? unlockedEntries / totalEntries : 0.0;
                  final explorationRate = userProgress.overallProgress;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // 커스텀 앱바
                        _buildAppBar(context),
                        
                        Padding(
                          padding: EdgeInsets.all(responsive.padding(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 1. User Avatar & Rank
                              _buildUserHeader(context, userProgress, responsive),
                              SizedBox(height: responsive.spacing(32)),

                              // 2. Rank Progress
                              _buildRankProgress(context, userProgress, responsive),
                              SizedBox(height: responsive.spacing(32)),

                              // 3. Stats Dashboard (Circular Charts)
                              responsive.isLandscape || responsive.deviceType == DeviceType.tablet
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: _buildStatCircles(context, userProgress, explorationRate, collectionRate, responsive),
                                    )
                                  : Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: responsive.spacing(16),
                                      runSpacing: responsive.spacing(16),
                                      children: _buildStatCircles(context, userProgress, explorationRate, collectionRate, responsive),
                                    ),
                              SizedBox(height: responsive.spacing(48)),

                              // 4. Detailed Stats List
                              _buildStatTile(
                                AppLocalizations.of(context)!.profile_stat_playtime,
                                userProgress.totalPlayTimeFormatted,
                                Icons.timer,
                                responsive,
                              ),
                              _buildStatTile(
                                AppLocalizations.of(context)!.profile_stat_eras,
                                AppLocalizations.of(context)!.profile_eras_count(userProgress.unlockedEraIds.length),
                                Icons.history_edu,
                                responsive,
                              ),
                              _buildStatTile(
                                AppLocalizations.of(context)!.profile_stat_dialogues,
                                '${userProgress.completedDialogueIds.length}',
                                Icons.chat_bubble_outline,
                                responsive,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => _buildLoadingState(),
                error: (_, _) => _buildErrorState(AppLocalizations.of(context)!.common_error_stats_load),
              );
            },
            loading: () => _buildLoadingState(),
            error: (e, s) => _buildErrorState('Error: $e'),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 뒤로가기 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          
          // 타이틀
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.profile_title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          // 설정 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: AppColors.iconPrimary),
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const CommonLoadingState.simple();
  }
  
  Widget _buildErrorState(String message) {
    return CommonErrorState(
      message: message,
      showRetryButton: false,
    );
  }

  List<Widget> _buildStatCircles(BuildContext context, UserProgress userProgress, double explorationRate, double collectionRate, ResponsiveUtils responsive) {
    return [
      _buildCircularStat(
        AppLocalizations.of(context)!.profile_stat_exploration,
        explorationRate,
        AppColors.info,
        icon: Icons.map,
        responsive: responsive,
      ),
      _buildCircularStat(
        AppLocalizations.of(context)!.profile_stat_collection,
        collectionRate,
        AppColors.secondary,
        icon: Icons.book,
        responsive: responsive,
      ),
      _buildCircularStat(
        AppLocalizations.of(context)!.profile_stat_knowledge,
        (userProgress.totalKnowledge / 1000).clamp(0.0, 1.0),
        AppColors.primary,
        icon: Icons.lightbulb,
        overrideText: userProgress.totalKnowledge.toString(),
        responsive: responsive,
      ),
    ];
  }

  Widget _buildUserHeader(BuildContext context, UserProgress userProgress, ResponsiveUtils responsive) {
    final avatarRadius = responsive.isSmallPhone ? 45.0 : 55.0;
    final iconSize = responsive.iconSize(50);
    
    return Column(
      children: [
        // 아바타 (황금빛 글로우)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.goldenButton,
            boxShadow: AppShadows.goldenGlowLg,
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: iconSize, color: AppColors.textPrimary),
            ),
          ),
        ),
        SizedBox(height: responsive.spacing(16)),
        
        // 이름
        Text(
          'Time Walker',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacing(8)),
        
        // 랭크 배지
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.padding(16),
            vertical: responsive.padding(6),
          ),
          decoration: BoxDecoration(
            gradient: AppGradients.goldenButton,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.goldenGlowSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.military_tech, color: AppColors.background, size: 16),
              const SizedBox(width: 6),
              Text(
                _getRankName(context, userProgress.rank),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankProgress(BuildContext context, UserProgress userProgress, ResponsiveUtils responsive) {
    final smallFontSize = responsive.fontSize(12);
    
    return Container(
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profile_rank_progress,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.profile_next_rank_pts(userProgress.pointsToNextRank),
                style: TextStyle(color: AppColors.textDisabled, fontSize: smallFontSize),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          
          // 프로그레스 바
          Stack(
            children: [
              Container(
                height: responsive.isSmallPhone ? 10 : 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: userProgress.rankProgress,
                child: Container(
                  height: responsive.isSmallPhone ? 10 : 12,
                  decoration: BoxDecoration(
                    gradient: AppGradients.goldenButton,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: AppShadows.goldenGlowSm,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(8)),
          
          // 진행률 텍스트
          Text(
            '${(userProgress.rankProgress * 100).toInt()}%',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
    final circleSize = responsive.isSmallPhone ? 70.0 : 90.0;
    final strokeWidth = responsive.isSmallPhone ? 6.0 : 8.0;
    final iconSize = responsive.iconSize(28);
    final valueFontSize = responsive.fontSize(16);
    
    return Column(
      children: [
        // 원형 차트
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SizedBox(
            width: circleSize,
            height: circleSize,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: strokeWidth,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
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
        ),
        SizedBox(height: responsive.spacing(12)),
        
        // 라벨
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (overrideText == null) ...[
          SizedBox(height: responsive.spacing(4)),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, ResponsiveUtils responsive) {
    final tilePadding = responsive.padding(16);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(12)),
      padding: EdgeInsets.all(tilePadding),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(12)),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: responsive.iconSize(20)),
          ),
          SizedBox(width: responsive.spacing(16)),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getRankName(BuildContext context, ExplorerRank rank) {
    final l10n = AppLocalizations.of(context)!;
    switch (rank) {
      case ExplorerRank.novice: return l10n.rank_novice;
      case ExplorerRank.apprentice: return l10n.rank_apprentice;
      case ExplorerRank.intermediate: return l10n.rank_intermediate;
      case ExplorerRank.advanced: return l10n.rank_advanced;
      case ExplorerRank.expert: return l10n.rank_expert;
      case ExplorerRank.master: return l10n.rank_master;
    }
  }
}
