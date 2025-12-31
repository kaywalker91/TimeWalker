import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// 시간 여행 테마 카드의 기본 Mixin
/// 
/// 호버, 프레스 상태 관리와 공통 애니메이션을 제공합니다.
/// 카드 위젯에서 `with TimeCardMixin`으로 사용합니다.
mixin TimeCardMixin<T extends StatefulWidget> on State<T> {
  bool _isHovered = false;
  bool _isPressed = false;
  
  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;
  
  /// 잠금 상태 (하위 클래스에서 override)
  bool get isLocked => false;
  
  /// 해금 상태
  bool get isUnlocked => !isLocked;
  
  /// 호버 시작 핸들러
  void onHoverStart() {
    setState(() => _isHovered = true);
  }
  
  /// 호버 종료 핸들러
  void onHoverEnd() {
    setState(() => _isHovered = false);
  }
  
  /// 프레스 시작 핸들러
  void onPressStart() {
    setState(() => _isPressed = true);
  }
  
  /// 프레스 종료 핸들러
  void onPressEnd() {
    setState(() => _isPressed = false);
  }
  
  /// 호버 효과를 위한 Transform 매트릭스
  Matrix4 get hoverTransform {
    if (isLocked) return Matrix4.identity();
    if (_isPressed) return Matrix4.translationValues(0, 4, 0);
    if (_isHovered) return Matrix4.translationValues(0, -4, 0);
    return Matrix4.identity();
  }
  
  /// 프레스 효과를 위한 Transform 매트릭스
  Matrix4 get pressTransform {
    if (isLocked) return Matrix4.identity();
    if (_isPressed) return Matrix4.translationValues(0, 4, 0);
    return Matrix4.identity();
  }
  
  /// 잠금 상태의 BoxDecoration
  BoxDecoration get lockedDecoration => BoxDecoration(
    color: AppColors.surface.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.border.withValues(alpha: 0.3),
      width: 1,
    ),
  );
  
  /// 해금 상태의 BoxDecoration
  BoxDecoration get unlockedDecoration => BoxDecoration(
    gradient: AppGradients.card,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _isHovered 
          ? AppColors.primary 
          : AppColors.primary.withValues(alpha: 0.5),
      width: 2,
    ),
    boxShadow: _isHovered ? AppShadows.goldenGlowMd : AppShadows.card,
  );
  
  /// 상태에 따른 BoxDecoration
  BoxDecoration get stateDecoration => 
      isLocked ? lockedDecoration : unlockedDecoration;

  /// 공통 MouseRegion 래퍼
  Widget buildHoverRegion({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => onHoverStart(),
      onExit: (_) => onHoverEnd(),
      child: child,
    );
  }
  
  /// 공통 GestureDetector 래퍼
  Widget buildPressDetector({
    required Widget child,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => onPressStart(),
      onTapUp: (_) => onPressEnd(),
      onTapCancel: onPressEnd,
      onTap: onTap,
      child: child,
    );
  }
}

/// 테마 색상이 있는 카드를 위한 확장 Mixin
mixin ThemedCardMixin<T extends StatefulWidget> on TimeCardMixin<T> {
  /// 테마 색상 (하위 클래스에서 override)
  Color get themeColor => AppColors.primary;
  
  /// 테마 색상이 적용된 해금 상태 BoxDecoration
  @override
  BoxDecoration get unlockedDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        themeColor.withValues(alpha: 0.2),
        themeColor.withValues(alpha: 0.1),
        AppColors.surface,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: isHovered 
          ? themeColor 
          : themeColor.withValues(alpha: 0.5),
      width: 2,
    ),
    boxShadow: isHovered 
        ? [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ]
        : AppShadows.card,
  );
}

/// 잠금 오버레이 위젯
/// 
/// 카드 위에 잠금 상태를 표시하는 오버레이
class LockOverlay extends StatelessWidget {
  /// 오버레이 텍스트
  final String? message;
  
  /// 아이콘 크기
  final double iconSize;
  
  /// 테마 색상
  final Color? themeColor;
  
  /// 잠금 해제 조건 표시
  final String? unlockCondition;

  const LockOverlay({
    super.key,
    this.message,
    this.iconSize = 40,
    this.themeColor,
    this.unlockCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_rounded,
              size: iconSize,
              color: (themeColor ?? AppColors.textSecondary).withValues(alpha: 0.7),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (unlockCondition != null) ...[
              const SizedBox(height: 4),
              Text(
                unlockCondition!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
