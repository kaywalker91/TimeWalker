import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/constants/player_avatars.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_layout_spec.dart';
import 'package:simple_animations/simple_animations.dart';

/// 시간 여행자 ID 카드 (기존 ProfileUserHeader 대체)
///
/// 미래적인 신분증 컨셉의 프리미엄 헤더 위젯
class TimeWalkerIdCard extends StatefulWidget {
  final UserProgress userProgress;
  final ProfileLayoutSpec layoutSpec;
  final String playerName;
  final int playerAvatarIndex;

  const TimeWalkerIdCard({
    super.key,
    required this.userProgress,
    required this.layoutSpec,
    required this.playerName,
    required this.playerAvatarIndex,
  });

  @override
  State<TimeWalkerIdCard> createState() => _TimeWalkerIdCardState();
}

class _TimeWalkerIdCardState extends State<TimeWalkerIdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatarRadius = widget.layoutSpec.avatarSize / 2;

    return Stack(
      children: [
        // 1. ID Card Background (Glassmorphism)
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: widget.layoutSpec.idCardMinHeight,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface.withValues(alpha: 0.7),
                AppColors.surface.withValues(alpha: 0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Holographic Shimmer Effect
                LoopAnimationBuilder<double>(
                  tween: Tween(begin: -1.0, end: 2.0),
                  duration: const Duration(seconds: 5),
                  builder: (context, value, child) {
                    return Positioned.fill(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        alignment: Alignment(value, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.transparent,
                                AppColors.white.withValues(alpha: 0.05),
                                AppColors.transparent,
                              ],
                              stops: const [0, 0.5, 1],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Content Layout
                Padding(
                  padding: EdgeInsets.all(widget.layoutSpec.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Section
                          _buildAvatarSection(avatarRadius),
                          SizedBox(width: widget.layoutSpec.clusterGap),

                          // Info Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(
                                  l10n.profile_identity_name,
                                  key: const Key('profile_id_name_label'),
                                ),
                                SizedBox(height: widget.layoutSpec.microGap),
                                ShaderMask(
                                  shaderCallback: (bounds) => AppGradients
                                      .goldenText
                                      .createShader(bounds),
                                  child: Text(
                                    widget.playerName,
                                    key: const Key('profile_id_name_value'),
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: widget.layoutSpec.itemGap),
                                _buildLabel(
                                  l10n.profile_identity_rank,
                                  key: const Key('profile_id_rank_label'),
                                ),
                                SizedBox(height: widget.layoutSpec.microGap),
                                _buildRankBadge(
                                  context,
                                  key: const Key('profile_id_rank_badge'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: widget.layoutSpec.clusterGap),
                      // ID Number / Metadata
                      Container(
                        key: const Key('profile_id_metadata'),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              widget.layoutSpec.itemGap +
                              widget.layoutSpec.microGap,
                          vertical: widget.layoutSpec.itemGap,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ID: TW-${DateTime.now().year}-${widget.userProgress.rank.index.toString().padLeft(4, '0')}',
                                style: TextStyle(
                                  fontFamily: 'Monospace',
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: widget.layoutSpec.itemGap),
                            Icon(
                              Icons.nfc,
                              color: AppColors.primary.withValues(alpha: 0.5),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Corner Accents (Deco)
        Positioned(top: 0, left: 0, child: _buildCorner(false, false)),
        Positioned(top: 0, right: 0, child: _buildCorner(true, false)),
        Positioned(bottom: 0, left: 0, child: _buildCorner(false, true)),
        Positioned(bottom: 0, right: 0, child: _buildCorner(true, true)),
      ],
    );
  }

  Widget _buildCorner(bool isRight, bool isBottom) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRight || isBottom ? 0 : 24),
          topRight: Radius.circular(!isRight || isBottom ? 0 : 24),
          bottomLeft: Radius.circular(isRight || !isBottom ? 0 : 24),
          bottomRight: Radius.circular(!isRight || !isBottom ? 0 : 24),
        ),
        border: Border(
          top: isBottom
              ? BorderSide.none
              : BorderSide(color: AppColors.primary, width: 2),
          bottom: !isBottom
              ? BorderSide.none
              : BorderSide(color: AppColors.primary, width: 2),
          left: isRight
              ? BorderSide.none
              : BorderSide(color: AppColors.primary, width: 2),
          right: !isRight
              ? BorderSide.none
              : BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(double radius) {
    final hasGoldenFrame = widget.userProgress.inventoryIds.contains(
      'avatar_frame_gold',
    );
    final primaryColor = hasGoldenFrame ? AppColors.gold : AppColors.primary;
    final secondaryColor = hasGoldenFrame
        ? const Color(0xFFFFE082)
        : AppColors.secondary;
    final outerFramePadding = widget.layoutSpec.itemGap / 2;
    final innerFramePadding = widget.layoutSpec.itemGap / 3;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(outerFramePadding),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(
                  alpha: 0.3 + (_glowController.value * 0.3),
                ),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
            gradient: SweepGradient(
              colors: [primaryColor, secondaryColor, primaryColor],
              transform: GradientRotation(_glowController.value * 2 * 3.14),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(innerFramePadding),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.surface,
              backgroundImage: AssetImage(
                PlayerAvatars.getAvatarPath(widget.playerAvatarIndex),
              ),
              onBackgroundImageError: (exception, stackTrace) {},
              child: null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, {Key? key}) {
    return Text(
      key: key,
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 1.2,
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRankBadge(BuildContext context, {Key? key}) {
    final rankName = _getRankName(context, widget.userProgress.rank);

    return Container(
      key: key,
      padding: EdgeInsets.symmetric(
        horizontal: widget.layoutSpec.itemGap + widget.layoutSpec.microGap,
        vertical: widget.layoutSpec.microGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: AppColors.primary, size: 16),
          SizedBox(width: widget.layoutSpec.itemGap),
          Text(
            rankName,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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

/// 네온 광선 스타일의 경험치 진행바
class NeonRankProgress extends StatelessWidget {
  final UserProgress userProgress;
  final ProfileLayoutSpec layoutSpec;

  const NeonRankProgress({
    super.key,
    required this.userProgress,
    required this.layoutSpec,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      padding: EdgeInsets.all(layoutSpec.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            key: const Key('profile_rank_header_row'),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.profile_rank_progress,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.labelMedium,
                  children: [
                    TextSpan(
                      text: '${(userProgress.rankProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' / 100%',
                      style: TextStyle(color: AppColors.textDisabled),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: layoutSpec.itemGap),
          // Neon Bar
          Container(
            key: const Key('profile_rank_bar'),
            height: layoutSpec.rankBarHeight,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(layoutSpec.rankBarHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white.withValues(alpha: 0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  blurStyle: BlurStyle.inner, // Inset Shadow 느낌
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * userProgress.rankProgress;
                final tipLeft = math.max(0.0, width - 4.0);
                final tipTop = math.max(
                  0.0,
                  (layoutSpec.rankBarHeight - 8.0) / 2,
                );
                return Stack(
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(
                          layoutSpec.rankBarHeight / 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    // Particle Effect at the tip
                    if (width > 0)
                      Positioned(
                        left: tipLeft,
                        top: tipTop,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.white,
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: layoutSpec.microGap * 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              key: const Key('profile_rank_next_text'),
              l10n.profile_next_rank_pts(userProgress.pointsToNextRank),
              style: TextStyle(color: AppColors.textDisabled, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
