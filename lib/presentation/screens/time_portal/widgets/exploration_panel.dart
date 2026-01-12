import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';

/// 탐험 상태 패널
/// 
/// 현재 탐험 중인 문명과 진행 상황을 표시합니다.
class ExplorationPanel extends StatelessWidget {
  final Civilization? currentCivilization;
  final String? currentEraName;
  final VoidCallback? onTap;

  const ExplorationPanel({
    super.key,
    this.currentCivilization,
    this.currentEraName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentCivilization == null) {
      return _buildEmptyState();
    }

    final civ = currentCivilization!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: civ.portalColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: civ.glowColor.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    civ.portalColor,
                    civ.glowColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: civ.glowColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.explore,
                color: AppColors.background,
                size: 22,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '🎯 현재 탐험',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${civ.progressPercent}%',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: civ.glowColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentEraName != null 
                        ? '${civ.name} > $currentEraName'
                        : civ.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // 진행률 바
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: civ.progress,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation(civ.portalColor),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 화살표
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
            ),
            child: Icon(
              Icons.explore_outlined,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '포탈을 선택하여 시간 여행을 시작하세요!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
