import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:simple_animations/simple_animations.dart';

/// 시간 여행자 ID 카드 (기존 ProfileUserHeader 대체)
/// 
/// 미래적인 신분증 컨셉의 프리미엄 헤더 위젯
class TimeWalkerIdCard extends StatefulWidget {
  final UserProgress userProgress;
  final ResponsiveUtils responsive;

  const TimeWalkerIdCard({
    super.key,
    required this.userProgress,
    required this.responsive,
  });

  @override
  State<TimeWalkerIdCard> createState() => _TimeWalkerIdCardState();
}

class _TimeWalkerIdCardState extends State<TimeWalkerIdCard> with SingleTickerProviderStateMixin {
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
    final avatarRadius = widget.responsive.isSmallPhone ? 35.0 : 45.0;
    
    return Stack(
      children: [
        // 1. ID Card Background (Glassmorphism)
        Container(
          width: double.infinity,
          height: 220,
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
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
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
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.05),
                                Colors.transparent,
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
                  padding: EdgeInsets.all(widget.responsive.padding(24)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Section
                          _buildAvatarSection(avatarRadius),
                          SizedBox(width: widget.responsive.spacing(20)),
                          
                          // Info Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(AppLocalizations.of(context)!.profile_identity_name),
                                const SizedBox(height: 4),
                                ShaderMask(
                                  shaderCallback: (bounds) => AppGradients.goldenText.createShader(bounds),
                                  child: Text(
                                    'Time Walker',
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildLabel(AppLocalizations.of(context)!.profile_identity_rank),
                                const SizedBox(height: 4),
                                _buildRankBadge(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // ID Number / Metadata
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID: TW-${DateTime.now().year}-${widget.userProgress.rank.index.toString().padLeft(4, '0')}',
                              style: TextStyle(
                                fontFamily: 'Monospace',
                                color: AppColors.textSecondary.withValues(alpha: 0.7),
                               fontSize: 12,
                              ),
                            ),
                            Icon(Icons.nfc, color: AppColors.primary.withValues(alpha: 0.5), size: 16),
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
          top: isBottom ? BorderSide.none : BorderSide(color: AppColors.primary, width: 2),
          bottom: !isBottom ? BorderSide.none : BorderSide(color: AppColors.primary, width: 2),
          left: isRight ? BorderSide.none : BorderSide(color: AppColors.primary, width: 2),
          right: !isRight ? BorderSide.none : BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(double radius) {
    final hasGoldenFrame = widget.userProgress.inventoryIds.contains('avatar_frame_gold');
    final primaryColor = hasGoldenFrame ? AppColors.gold : AppColors.primary;
    final secondaryColor = hasGoldenFrame ? Colors.amber[100]! : AppColors.secondary;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3 + (_glowController.value * 0.3)),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
            gradient: SweepGradient(
              colors: [
                primaryColor,
                secondaryColor,
                primaryColor,
              ],
              transform: GradientRotation(_glowController.value * 2 * 3.14),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: radius, color: AppColors.textPrimary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 1.2,
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRankBadge(BuildContext context) {
    final rankName = _getRankName(context, widget.userProgress.rank);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Text(
            rankName,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
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

/// 네온 광선 스타일의 경험치 진행바
class NeonRankProgress extends StatelessWidget {
  final UserProgress userProgress;
  final ResponsiveUtils responsive;

  const NeonRankProgress({
    super.key,
    required this.userProgress,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.profile_rank_progress,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
            RichText(
              text: TextSpan(
                style: AppTextStyles.labelMedium,
                children: [
                  TextSpan(
                    text: '${(userProgress.rankProgress * 100).toInt()}%',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 12),
        // Neon Bar
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 4,
                blurStyle: BlurStyle.inner, // Inset Shadow 느낌
              )
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth * userProgress.rankProgress;
              return Stack(
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                      left: width - 4,
                      top: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.white, blurRadius: 6, spreadRadius: 2),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
           l10n.profile_next_rank_pts(userProgress.pointsToNextRank),
            style: TextStyle(color: AppColors.textDisabled, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
