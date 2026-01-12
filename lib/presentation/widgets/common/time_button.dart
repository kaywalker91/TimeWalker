import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// TimeWalker 공통 버튼 위젯
/// 
/// 시간여행 컨셉에 맞는 황금빛 그라데이션 버튼
enum TimeButtonVariant {
  /// 황금빛 그라데이션 - 메인 CTA
  primary,
  
  /// 보라빛 그라데이션 - 보조 액션
  secondary,
  
  /// 골드 테두리 - 아웃라인
  outline,
  
  /// 투명 배경 - 고스트
  ghost,
}

enum TimeButtonSize {
  small,
  medium,
  large,
}

class TimeButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final TimeButtonVariant variant;
  final TimeButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  const TimeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = TimeButtonVariant.primary,
    this.size = TimeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  });
  
  /// Primary 황금 버튼 생성자
  const TimeButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = TimeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = TimeButtonVariant.primary;
  
  /// Secondary 포탈 버튼 생성자
  const TimeButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = TimeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = TimeButtonVariant.secondary;
  
  /// Outline 버튼 생성자
  const TimeButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = TimeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = TimeButtonVariant.outline;
  
  /// Ghost 버튼 생성자
  const TimeButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = TimeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = TimeButtonVariant.ghost;

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> 
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  
  // Size configurations
  double get _height {
    switch (widget.size) {
      case TimeButtonSize.small:
        return 40;
      case TimeButtonSize.medium:
        return 52;
      case TimeButtonSize.large:
        return 60;
    }
  }
  
  double get _fontSize {
    switch (widget.size) {
      case TimeButtonSize.small:
        return 13;
      case TimeButtonSize.medium:
        return 15;
      case TimeButtonSize.large:
        return 17;
    }
  }
  
  double get _iconSize {
    switch (widget.size) {
      case TimeButtonSize.small:
        return 18;
      case TimeButtonSize.medium:
        return 22;
      case TimeButtonSize.large:
        return 26;
    }
  }
  
  EdgeInsets get _padding {
    switch (widget.size) {
      case TimeButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case TimeButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case TimeButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
  
  bool get _isDisabled => widget.onPressed == null || widget.isLoading;
  
  // Decoration based on variant
  BoxDecoration get _decoration {
    if (_isDisabled) {
      return AppDecorations.buttonDisabled;
    }
    
    switch (widget.variant) {
      case TimeButtonVariant.primary:
        return _isPressed 
            ? AppDecorations.buttonPrimaryPressed 
            : AppDecorations.buttonPrimary;
      case TimeButtonVariant.secondary:
        return AppDecorations.buttonSecondary;
      case TimeButtonVariant.outline:
        return AppDecorations.buttonOutline;
      case TimeButtonVariant.ghost:
        return AppDecorations.buttonGhost;
    }
  }
  
  Color get _textColor {
    if (_isDisabled) {
      return AppColors.textDisabled;
    }
    
    switch (widget.variant) {
      case TimeButtonVariant.primary:
        return AppColors.background;
      case TimeButtonVariant.secondary:
        return AppColors.textPrimary;
      case TimeButtonVariant.outline:
        return AppColors.primary;
      case TimeButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.label,
      hint: widget.isLoading ? '로딩 중' : null,
      child: GestureDetector(
        onTapDown: _isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: _isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: _isDisabled ? null : () => setState(() => _isPressed = false),
        onTap: _isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: _height,
          width: widget.fullWidth ? double.infinity : null,
          decoration: _decoration,
          transform: _isPressed 
              ? Matrix4.translationValues(0, 2, 0) 
              : Matrix4.identity(),
          child: Padding(
            padding: _padding,
            child: Row(
              mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: _iconSize,
                    color: _textColor,
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                    letterSpacing: 1.2,
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

/// 아이콘만 있는 원형 버튼
class TimeIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final TimeButtonVariant variant;
  final double size;
  final String? tooltip;

  const TimeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = TimeButtonVariant.ghost,
    this.size = 48,
    this.tooltip,
  });

  @override
  State<TimeIconButton> createState() => _TimeIconButtonState();
}

class _TimeIconButtonState extends State<TimeIconButton> {
  bool _isPressed = false;
  
  bool get _isDisabled => widget.onPressed == null;
  
  BoxDecoration get _decoration {
    if (_isDisabled) {
      return BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      );
    }
    
    switch (widget.variant) {
      case TimeButtonVariant.primary:
        return BoxDecoration(
          gradient: _isPressed 
              ? AppGradients.goldenButtonPressed 
              : AppGradients.goldenButton,
          shape: BoxShape.circle,
          boxShadow: _isPressed ? null : AppShadows.goldenGlowSm,
        );
      case TimeButtonVariant.secondary:
        return BoxDecoration(
          gradient: AppGradients.portalButton,
          shape: BoxShape.circle,
          boxShadow: AppShadows.portalGlowSm,
        );
      case TimeButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.6),
            width: 2,
          ),
        );
      case TimeButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed 
              ? AppColors.surface.withValues(alpha: 0.5) 
              : AppColors.surface.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        );
    }
  }
  
  Color get _iconColor {
    if (_isDisabled) return AppColors.iconDisabled;
    
    switch (widget.variant) {
      case TimeButtonVariant.primary:
        return AppColors.background;
      case TimeButtonVariant.secondary:
        return AppColors.textPrimary;
      case TimeButtonVariant.outline:
        return AppColors.primary;
      case TimeButtonVariant.ghost:
        return AppColors.iconPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.tooltip ?? '아이콘 버튼', // 툴팁이 없으면 기본 라벨 제공 필요
      child: GestureDetector(
        onTapDown: _isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: _isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: _isDisabled ? null : () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: _decoration,
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.size * 0.5,
              color: _iconColor,
            ),
          ),
        ),
      ),
    );
    
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    
    return button;
  }
}
