import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// Compact location tile for data-centric list display
class CompactLocationTile extends StatelessWidget {
  final Location location;
  final EraTheme theme;
  final VoidCallback? onTap;

  const CompactLocationTile({
    super.key,
    required this.location,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = location.status;
    final isLocked = status == ContentStatus.locked;
    final isCompleted = status == ContentStatus.completed;
    final characterCount = location.characterIds.length;
    final (statusIcon, statusColor) = _getStatusIconAndColor(status);

    return Card(
      color: AppColors.white.withValues(alpha: 0.03),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.transparent,
        ),
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _buildStatusIcon(statusIcon, statusColor),
              const SizedBox(width: 12),
              _buildLocationName(context, isLocked),
              if (isCompleted) _buildCompletedCheckmark(),
              if (characterCount > 0) _buildCharacterCount(characterCount),
              if (!isLocked) _buildChevron(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(IconData statusIcon, Color statusColor) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        statusIcon,
        color: statusColor,
        size: 18,
      ),
    );
  }

  Widget _buildLocationName(BuildContext context, bool isLocked) {
    return Expanded(
      child: Text(
        location.getNameForContext(context),
        style: TextStyle(
          color: isLocked ? AppColors.grey : AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCompletedCheckmark() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Icon(
        Icons.check_circle,
        color: AppColors.success,
        size: 18,
      ),
    );
  }

  Widget _buildCharacterCount(int characterCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 12,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 4),
          Text(
            '$characterCount',
            style: TextStyle(
              color: AppColors.grey400,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChevron() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(
        Icons.chevron_right,
        color: AppColors.grey600,
        size: 20,
      ),
    );
  }

  (IconData, Color) _getStatusIconAndColor(ContentStatus status) {
    switch (status) {
      case ContentStatus.completed:
        return (Icons.check_circle_outline, AppColors.success);
      case ContentStatus.inProgress:
        return (Icons.play_circle_outline, AppColors.warning);
      case ContentStatus.available:
        return (Icons.explore_outlined, theme.primaryColor);
      case ContentStatus.locked:
        return (Icons.lock_outline, AppColors.grey);
    }
  }
}
