import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/presentation/widgets/common/time_animations.dart';

/// 공통 빈 상태 위젯
/// 
/// 데이터가 없을 때 일관된 UI를 제공합니다.
/// 다양한 상황에 맞는 아이콘, 메시지, 액션 버튼을 표시합니다.
class CommonEmptyState extends StatelessWidget {
  /// 빈 상태 아이콘
  final IconData icon;
  
  /// 아이콘 색상 (기본: AppColors.textDisabled)
  final Color? iconColor;
  
  /// 아이콘 크기 (기본: 64)
  final double iconSize;
  
  /// 제목 (선택)
  final String? title;
  
  /// 설명 메시지
  final String message;
  
  /// 액션 버튼 표시 여부 (기본: false)
  final bool showActionButton;
  
  /// 액션 버튼 텍스트
  final String? actionButtonText;
  
  /// 액션 버튼 콜백
  final VoidCallback? onAction;
  
  /// 이미지 에셋 경로 (아이콘 대신 사용, 선택)
  final String? imageAsset;

  const CommonEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.iconColor,
    this.iconSize = 64,
    this.title,
    required this.message,
    this.showActionButton = false,
    this.actionButtonText,
    this.onAction,
    this.imageAsset,
  });

  /// 검색 결과 없음 프리셋
  const CommonEmptyState.noSearchResults({
    super.key,
    this.message = '검색 결과가 없습니다.',
    this.onAction,
  })  : icon = Icons.search_off,
        iconColor = null,
        iconSize = 64,
        title = null,
        showActionButton = false,
        actionButtonText = null,
        imageAsset = null;

  /// 데이터 없음 프리셋
  const CommonEmptyState.noData({
    super.key,
    this.title,
    required this.message,
    this.actionButtonText,
    this.onAction,
  })  : icon = Icons.folder_open,
        iconColor = null,
        iconSize = 64,
        showActionButton = onAction != null,
        imageAsset = null;

  /// 즐겨찾기/컬렉션 없음 프리셋
  const CommonEmptyState.noFavorites({
    super.key,
    this.message = '아직 즐겨찾기에 추가한 항목이 없습니다.',
    this.actionButtonText = '탐험하러 가기',
    this.onAction,
  })  : icon = Icons.star_border,
        iconColor = AppColors.primary,
        iconSize = 64,
        title = null,
        showActionButton = true,
        imageAsset = null;

  /// 업적/도감 미발견 프리셋
  const CommonEmptyState.notDiscovered({
    super.key,
    this.message = '아직 발견한 항목이 없습니다.\n더 많은 역사를 탐험해보세요!',
    this.actionButtonText = '탐험 시작',
    this.onAction,
  })  : icon = Icons.explore_outlined,
        iconColor = AppColors.secondary,
        iconSize = 64,
        title = null,
        showActionButton = true,
        imageAsset = null;

  /// 시대/지역 잠금 프리셋
  const CommonEmptyState.locked({
    super.key,
    required this.message,
    this.title,
  })  : icon = Icons.lock_outline,
        iconColor = AppColors.textDisabled,
        iconSize = 64,
        showActionButton = false,
        actionButtonText = null,
        onAction = null,
        imageAsset = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘 또는 이미지
            FadeInWidget(
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset!,
                      width: iconSize * 1.5,
                      height: iconSize * 1.5,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _buildIconWidget(),
                    )
                  : _buildIconWidget(),
            ),
            const SizedBox(height: 24),
            
            // 제목 (있을 경우)
            if (title != null)
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title!,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            
            // 메시지
            FadeInWidget(
              delay: const Duration(milliseconds: 150),
              child: Text(
                message,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 액션 버튼
            if (showActionButton && onAction != null && actionButtonText != null) ...[
              const SizedBox(height: 32),
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(actionButtonText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (iconColor ?? AppColors.textDisabled).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? AppColors.textDisabled,
      ),
    );
  }
}

/// 잠금 상태 배너
/// 
/// 잠긴 콘텐츠 위에 오버레이로 표시할 수 있는 컴팩트한 배너
class LockedContentBanner extends StatelessWidget {
  final String message;
  final String? unlockHint;
  final VoidCallback? onTap;

  const LockedContentBanner({
    super.key,
    required this.message,
    this.unlockHint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                size: 20,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (unlockHint != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      unlockHint!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
