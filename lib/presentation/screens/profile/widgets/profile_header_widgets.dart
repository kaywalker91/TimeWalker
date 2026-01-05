import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// 프로필 사용자 헤더 위젯
/// 
/// 아바타, 이름, 랭크 배지를 표시
class ProfileUserHeader extends StatelessWidget {
  final UserProgress userProgress;
  final ResponsiveUtils responsive;

  const ProfileUserHeader({
    super.key,
    required this.userProgress,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final avatarRadius = responsive.isSmallPhone ? 45.0 : 55.0;
    final iconSize = responsive.iconSize(50);

    return Column(
      children: [
        // 아바타
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

  String _getRankName(BuildContext context, ExplorerRank rank) {
    final l10n = AppLocalizations.of(context)!;
    switch (rank) {
      case ExplorerRank.novice:
        return l10n.rank_novice;
      case ExplorerRank.apprentice:
        return l10n.rank_apprentice;
      case ExplorerRank.intermediate:
        return l10n.rank_intermediate;
      case ExplorerRank.advanced:
        return l10n.rank_advanced;
      case ExplorerRank.expert:
        return l10n.rank_expert;
      case ExplorerRank.master:
        return l10n.rank_master;
    }
  }
}

/// 프로필 랭크 진행 위젯
/// 
/// 다음 랭크까지의 진행률을 표시
class ProfileRankProgress extends StatelessWidget {
  final UserProgress userProgress;
  final ResponsiveUtils responsive;

  const ProfileRankProgress({
    super.key,
    required this.userProgress,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.profile_rank_progress,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                l10n.profile_next_rank_pts(userProgress.pointsToNextRank),
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
}
