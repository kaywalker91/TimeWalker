import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/presentation/widgets/common/cards/base_time_card.dart';

/// TimeWalker 공통 카드 위젯
/// 
/// 시간여행 컨셉에 맞는 고풍스러운 카드
enum TimeCardVariant {
  /// 기본 카드
  standard,
  
  /// 강조 카드 (골드 테두리)
  highlight,
  
  /// 선택된 카드
  selected,
  
  /// 잠긴 카드
  locked,
  
  /// 성공/완료 카드
  success,
}

class TimeCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TimeCardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enableHoverEffect;

  const TimeCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.variant = TimeCardVariant.standard,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.enableHoverEffect = true,
  });
  
  /// 기본 카드 생성자
  const TimeCard.standard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.enableHoverEffect = true,
  }) : variant = TimeCardVariant.standard;
  
  /// 강조 카드 생성자
  const TimeCard.highlight({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.enableHoverEffect = true,
  }) : variant = TimeCardVariant.highlight;
  
  /// 잠긴 카드 생성자
  const TimeCard.locked({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.enableHoverEffect = false,
  }) : variant = TimeCardVariant.locked;

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> with TimeCardMixin {
  @override
  bool get isLocked => widget.variant == TimeCardVariant.locked;
  
  BorderRadius get _borderRadius => 
      widget.borderRadius ?? BorderRadius.circular(16);
  
  BoxDecoration get _decoration {
    switch (widget.variant) {
      case TimeCardVariant.standard:
        if (isHovered && widget.enableHoverEffect) {
          return BoxDecoration(
            gradient: AppGradients.card,
            borderRadius: _borderRadius,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: AppShadows.cardHover,
          );
        }
        return BoxDecoration(
          color: AppColors.surface,
          borderRadius: _borderRadius,
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: AppShadows.card,
        );
        
      case TimeCardVariant.highlight:
        return BoxDecoration(
          gradient: AppGradients.card,
          borderRadius: _borderRadius,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: AppShadows.cardHighlight,
        );
        
      case TimeCardVariant.selected:
        return BoxDecoration(
          gradient: AppGradients.cardHighlight,
          borderRadius: _borderRadius,
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
          boxShadow: AppShadows.goldenGlowMd,
        );
        
      case TimeCardVariant.locked:
        return BoxDecoration(
          gradient: AppGradients.cardLocked,
          borderRadius: _borderRadius,
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: AppShadows.locked,
        );
        
      case TimeCardVariant.success:
        return BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: _borderRadius,
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null || widget.onLongPress != null;
    
    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: _decoration,
      transform: pressTransform,
      child: widget.child,
    );
    
    if (isInteractive) {
      // TimeCardMixin의 buildHoverRegion과 buildPressDetector 사용
      cardContent = buildHoverRegion(
        child: buildPressDetector(
          onTap: widget.onTap,
          child: GestureDetector(
            onLongPress: widget.onLongPress,
            child: cardContent,
          ),
        ),
      );
    }
    
    // 잠긴 카드에 오버레이 추가
    if (widget.variant == TimeCardVariant.locked) {
      cardContent = Stack(
        children: [
          cardContent,
          Positioned.fill(
            child: Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.4),
                borderRadius: _borderRadius,
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_outline,
                  color: AppColors.textDisabled,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // 접근성 지원 추가
    return Semantics(
      button: isInteractive,
      enabled: widget.variant != TimeCardVariant.locked,
      selected: widget.variant == TimeCardVariant.selected,
      label: widget.variant == TimeCardVariant.locked ? '잠김' : null,
      child: cardContent,
    );
  }
}

/// 시대별 테마 카드
class EraCard extends StatefulWidget {
  final Widget child;
  final Color themeColor;
  final VoidCallback? onTap;
  final bool isLocked;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;

  const EraCard({
    super.key,
    required this.child,
    required this.themeColor,
    this.onTap,
    this.isLocked = false,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  State<EraCard> createState() => _EraCardState();
}

class _EraCardState extends State<EraCard> with TimeCardMixin, ThemedCardMixin {
  @override
  bool get isLocked => widget.isLocked;
  
  @override
  Color get themeColor => widget.themeColor;
  
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);
    
    final decoration = isLocked
        ? AppDecorations.eraCardLocked
        : BoxDecoration(
            color: AppColors.surface,
            borderRadius: borderRadius,
            border: Border.all(
              color: isHovered 
                  ? themeColor 
                  : themeColor.withValues(alpha: 0.7),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: themeColor.withValues(alpha: isHovered ? 0.4 : 0.3),
                blurRadius: isHovered ? 24 : 20,
                offset: const Offset(0, 10),
              ),
            ],
          );
    
    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: decoration,
      child: widget.child,
    );
    
    if (widget.onTap != null) {
      // TimeCardMixin의 buildHoverRegion과 buildPressDetector 사용
      cardContent = buildHoverRegion(
        child: buildPressDetector(
          onTap: widget.onTap,
          child: cardContent,
        ),
      );
    }
    
    if (isLocked) {
      cardContent = Stack(
        children: [
          cardContent,
          Positioned.fill(
            child: Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.5),
                borderRadius: borderRadius,
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_outline,
                  color: AppColors.textDisabled,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // 접근성 지원 추가
    return Semantics(
      button: widget.onTap != null,
      enabled: !isLocked,
      label: isLocked ? '잠긴 시대' : '시대 선택',
      child: cardContent,
    );
  }
}
