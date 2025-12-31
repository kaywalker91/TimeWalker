import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/presentation/widgets/common/time_animations.dart';

/// 공통 에러 상태 위젯
/// 
/// 모든 화면에서 일관된 에러 UI를 제공합니다.
/// 다양한 에러 유형에 맞는 아이콘과 메시지, 재시도 버튼을 표시합니다.
class CommonErrorState extends StatelessWidget {
  /// 에러 메시지
  final String message;
  
  /// 에러 아이콘 (기본: Icons.error_outline)
  final IconData icon;
  
  /// 아이콘 색상 (기본: AppColors.error)
  final Color? iconColor;
  
  /// 아이콘 크기 (기본: 64)
  final double iconSize;
  
  /// 재시도 버튼 표시 여부 (기본: true)
  final bool showRetryButton;
  
  /// 재시도 버튼 텍스트 (기본: 현지화된 "다시 시도")
  final String? retryButtonText;
  
  /// 재시도 콜백
  final VoidCallback? onRetry;
  
  /// 추가 액션 버튼 (선택)
  final Widget? additionalAction;

  const CommonErrorState({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.iconColor,
    this.iconSize = 64,
    this.showRetryButton = true,
    this.retryButtonText,
    this.onRetry,
    this.additionalAction,
  });

  /// 네트워크 에러용 프리셋
  const CommonErrorState.network({
    super.key,
    required this.onRetry,
    this.message = '네트워크 연결을 확인해주세요.',
  })  : icon = Icons.wifi_off,
        iconColor = null,
        iconSize = 64,
        showRetryButton = true,
        retryButtonText = null,
        additionalAction = null;

  /// 데이터 로드 에러용 프리셋
  const CommonErrorState.loadFailed({
    super.key,
    String? customMessage,
    this.onRetry,
  })  : message = customMessage ?? '데이터를 불러오는 데 실패했습니다.',
        icon = Icons.cloud_off,
        iconColor = null,
        iconSize = 64,
        showRetryButton = true,
        retryButtonText = null,
        additionalAction = null;

  /// 권한 에러용 프리셋
  const CommonErrorState.permission({
    super.key,
    this.message = '접근 권한이 없습니다.',
    this.additionalAction,
  })  : icon = Icons.lock_outline,
        iconColor = AppColors.warning,
        iconSize = 64,
        showRetryButton = false,
        retryButtonText = null,
        onRetry = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 에러 아이콘
            FadeInWidget(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.error).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 에러 메시지
            FadeInWidget(
              delay: const Duration(milliseconds: 100),
              child: Text(
                message,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // 재시도 버튼
            if (showRetryButton && onRetry != null)
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryButtonText ?? '다시 시도'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            
            // 추가 액션
            if (additionalAction != null) ...[
              const SizedBox(height: 16),
              FadeInWidget(
                delay: const Duration(milliseconds: 300),
                child: additionalAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 간단한 인라인 에러 메시지
/// 
/// 폼 필드나 작은 영역에 사용할 수 있는 컴팩트한 에러 위젯
class InlineErrorMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  const InlineErrorMessage({
    super.key,
    required this.message,
    this.icon = Icons.warning_amber_rounded,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 16,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
