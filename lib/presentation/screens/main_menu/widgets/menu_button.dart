import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';

/// 메인 메뉴 아이템 데이터 모델
class MenuItem {
  final String label;
  final IconData icon;
  final String route;
  final bool isPrimary;
  final bool isDisabled;
  final String? heroTag;

  const MenuItem({
    required this.label,
    required this.icon,
    required this.route,
    this.isPrimary = false,
    this.isDisabled = false,
    this.heroTag,
  });
}

/// 애니메이션이 적용된 메뉴 버튼 위젯
/// 
/// 메인 메뉴에서 사용되는 버튼으로, hover/press 상태에 따라 시각적 피드백 제공
class MenuButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final ResponsiveUtils responsive;
  final String? heroTag;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.responsive,
    this.isPrimary = false,
    this.isDisabled = false,
    this.heroTag,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;

  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  bool get _isActive => !widget.isDisabled;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.responsive.buttonHeight(phone: 52, tablet: 60);
    final fontSize = widget.responsive.fontSize(15);
    final iconSize = widget.responsive.iconSize(22);

    // 데코레이션 결정
    final (decoration, textColor) = _buildDecoration();

    // 접근성 지원 추가
    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      label: widget.label,
      hint: widget.isDisabled ? '준비 중인 기능입니다' : null,
      child: MouseRegion(
        onEnter: _isActive ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isActive ? (_) => setState(() => _isHovered = false) : null,
        child: GestureDetector(
          onTapDown: _isActive
              ? (_) {
                  setState(() => _isPressed = true);
                  _pressController.forward();
                }
              : null,
          onTapUp: _isActive
              ? (_) {
                  setState(() => _isPressed = false);
                  _pressController.reverse();
                }
              : null,
          onTapCancel: _isActive
              ? () {
                  setState(() => _isPressed = false);
                  _pressController.reverse();
                }
              : null,
          onTap: _isActive ? widget.onPressed : null,
          child: AnimatedBuilder(
            animation: _pressAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pressAnimation.value,
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: double.infinity,
                  height: buttonHeight,
                  decoration: decoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.heroTag != null 
                          ? Hero(
                              tag: widget.heroTag!,
                              child: Icon(
                                widget.icon,
                                size: iconSize,
                                color: textColor,
                              ),
                            )
                          : Icon(
                              widget.icon,
                              size: iconSize,
                              color: textColor,
                            ),
                      SizedBox(width: widget.responsive.spacing(10)),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: widget.responsive.isSmallPhone ? 1 : 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  (BoxDecoration, Color) _buildDecoration() {
    if (widget.isDisabled) {
      return (
        BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        AppColors.textDisabled,
      );
    }

    if (widget.isPrimary) {
      return (
        BoxDecoration(
          gradient: _isPressed
              ? AppGradients.goldenButtonPressed
              : AppGradients.goldenButton,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isPressed
              ? null
              : (_isHovered ? AppShadows.goldenGlowLg : AppShadows.goldenGlowMd),
        ),
        AppColors.background,
      );
    }

    return (
      BoxDecoration(
        color: _isHovered
            ? AppColors.surface.withValues(alpha: 0.6)
            : AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      AppColors.textPrimary,
    );
  }
}
