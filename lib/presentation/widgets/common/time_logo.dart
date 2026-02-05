import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// TimeWalker 로고 위젯
/// 
/// 시간 포탈 컨셉의 앱 로고
class TimeLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final bool animate;

  const TimeLogo({
    super.key,
    this.size = 100,
    this.showGlow = true,
    this.animate = false,
  });
  
  /// 작은 로고
  const TimeLogo.small({super.key})
      : size = 60,
        showGlow = false,
        animate = false;
  
  /// 중간 로고
  const TimeLogo.medium({super.key})
      : size = 100,
        showGlow = true,
        animate = false;
  
  /// 큰 로고 (스플래시용)
  const TimeLogo.large({super.key})
      : size = 150,
        showGlow = true,
        animate = true;

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.goldenButton,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: showGlow ? AppShadows.goldenGlowLg : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외곽 링 효과
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.background.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          // 시계 아이콘
          Icon(
            Icons.schedule,
            size: size * 0.5,
            color: AppColors.background,
          ),
          // 시간 여행 효과 (회전하는 화살표)
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Transform.rotate(
              angle: -0.3,
              child: Icon(
                Icons.arrow_forward,
                size: size * 0.18,
                color: AppColors.background.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
    
    if (animate) {
      logo = _AnimatedLogo(
        size: size,
        child: logo,
      );
    }
    
    return logo;
  }
}

class _AnimatedLogo extends StatefulWidget {
  final double size;
  final Widget child;

  const _AnimatedLogo({
    required this.size,
    required this.child,
  });

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.5 * _glowAnimation.value),
                blurRadius: 30 * _glowAnimation.value,
                spreadRadius: 5 * _glowAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// 앱 타이틀 텍스트 (그라데이션)
class TimeTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final double letterSpacing;

  const TimeTitle({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.letterSpacing = 3,
  });
  
  /// 작은 타이틀
  const TimeTitle.small({
    super.key,
    required this.text,
  }) : fontSize = 18,
       letterSpacing = 2;
  
  /// 중간 타이틀
  const TimeTitle.medium({
    super.key,
    required this.text,
  }) : fontSize = 24,
       letterSpacing = 3;
  
  /// 큰 타이틀
  const TimeTitle.large({
    super.key,
    required this.text,
  }) : fontSize = 32,
       letterSpacing = 5;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.goldenText.createShader(bounds),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: letterSpacing,
          color: AppColors.white,
          fontFamily: AppTextStyles.fontFamilyDisplay,
        ),
      ),
    );
  }
}
