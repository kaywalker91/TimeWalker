import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_models.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// Minimal sticky status bar with progress indicator
class EraStatusBar extends StatelessWidget {
  final Era era;
  final int totalCount;
  final int visibleCount;
  final Location? selectedLocation;
  final UserProgress userProgress;
  final int? currentKingdomIndex;
  final EraExplorationLayoutSpec layoutSpec;

  const EraStatusBar({
    super.key,
    required this.era,
    required this.totalCount,
    required this.visibleCount,
    required this.selectedLocation,
    required this.userProgress,
    this.currentKingdomIndex,
    required this.layoutSpec,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // 왕국별 악센트 색상
    final accentColor = currentKingdomIndex != null
        ? KingdomConfig
                  .meta[KingdomConfig.tabs[currentKingdomIndex!].id]
                  ?.color ??
              era.theme.accentColor
        : era.theme.accentColor;

    final progress = userProgress.getEraProgress(era.id);
    final percent = (progress * 100).toInt();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        responsive.padding(16),
        responsive.padding(
          layoutSpec.widthClass == EraExplorationWidthClass.compact ? 7 : 8,
        ),
        responsive.padding(16),
        responsive.padding(
          layoutSpec.widthClass == EraExplorationWidthClass.compact ? 7 : 8,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow(context, responsive, accentColor, percent, layoutSpec),
          SizedBox(height: responsive.spacing(8)),
          _buildProgressBar(responsive, accentColor, progress),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    ResponsiveUtils responsive,
    Color accentColor,
    int percent,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    final labelFontSize =
        layoutSpec.textScaleClass == EraExplorationTextScaleClass.xlarge ||
            layoutSpec.textScaleClass == EraExplorationTextScaleClass.max
        ? responsive.fontSize(10)
        : responsive.fontSize(11);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$visibleCount개 장소',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: labelFontSize,
            ),
          ),
        ),
        SizedBox(width: responsive.spacing(8)),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: responsive.wp(46)),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.padding(10),
                vertical: responsive.padding(3),
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                '진행률 $percent%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accentColor,
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    ResponsiveUtils responsive,
    Color accentColor,
    double progress,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withValues(alpha: 0.5), accentColor],
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
