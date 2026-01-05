import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';

/// 원형 통계 차트 위젯
/// 
/// 프로필 화면에서 탐험률, 수집률, 지식 포인트 등을 표시하는 원형 프로그레스
class CircularStatWidget extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  final IconData icon;
  final ResponsiveUtils responsive;
  final String? overrideText;

  const CircularStatWidget({
    super.key,
    required this.label,
    required this.progress,
    required this.color,
    required this.icon,
    required this.responsive,
    this.overrideText,
  });

  @override
  Widget build(BuildContext context) {
    final circleSize = responsive.isSmallPhone ? 70.0 : 90.0;
    final strokeWidth = responsive.isSmallPhone ? 6.0 : 8.0;
    final iconSize = responsive.iconSize(28);
    final valueFontSize = responsive.fontSize(16);

    return Column(
      children: [
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
                          overrideText!,
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
}

/// 프로필 통계 타일 위젯
/// 
/// 플레이 시간, 해금된 시대 수 등의 상세 통계를 표시
class ProfileStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ResponsiveUtils responsive;

  const ProfileStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
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
}
