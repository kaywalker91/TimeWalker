import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';

/// 탐험 상태 패널
/// 
/// 현재 탐험 중인 문명과 진행 상황을 표시합니다.
/// 글래스모피즘(Glassmorphism) 스타일이 적용되어 있습니다.
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
    final portalColor = civ.portalColor.toColor();
    final glowColor = civ.glowColor.toColor();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(1.5), // 보더 두께
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  portalColor.withValues(alpha: 0.5),
                  portalColor.withValues(alpha: 0.1),
                  glowColor.withValues(alpha: 0.05),
                  glowColor.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.6), // 반투명 배경
                borderRadius: BorderRadius.circular(19), // 내부 radius = 외부 - 두께
              ),
              child: Row(
                children: [
                  // 아이콘
                  _buildIcon(portalColor, glowColor),
                  
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
                              'EXPLORING',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${civ.progressPercent}%',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: glowColor,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: glowColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentEraName != null 
                              ? '${civ.name} > $currentEraName'
                              : civ.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        
                        // 진행률 바
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: civ.progress,
                            backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation(portalColor),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 화살표
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceLight.withValues(alpha: 0.3),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color portalColor, Color glowColor) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            portalColor,
            glowColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface, // 내부를 어둡게
          ),
          child: Icon(
            Icons.explore,
            color: portalColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceLight.withValues(alpha: 0.3),
                  ),
                  child: Icon(
                    Icons.explore_outlined,
                    color: AppColors.textDisabled,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '시간 여행 준비 완료',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '포탈을 선택하여 역사를 탐험하세요.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
