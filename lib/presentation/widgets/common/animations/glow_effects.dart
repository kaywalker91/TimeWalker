import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// 펄스 글로우 애니메이션 위젯
class PulseGlowWidget extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double minGlow;
  final double maxGlow;
  final Duration duration;

  const PulseGlowWidget({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
    this.minGlow = 0.3,
    this.maxGlow = 0.6,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulseGlowWidget> createState() => _PulseGlowWidgetState();
}

class _PulseGlowWidgetState extends State<PulseGlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: widget.minGlow,
      end: widget.maxGlow,
    ).animate(
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
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: _glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// 황금빛 쉬머 효과
class GoldenShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const GoldenShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<GoldenShimmer> createState() => _GoldenShimmerState();
}

class _GoldenShimmerState extends State<GoldenShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + 2 * _controller.value, 0),
              end: Alignment(-0.5 + 2 * _controller.value, 0),
              colors: [
                AppColors.transparent,
                AppColors.primaryLight.withValues(alpha: 0.5),
                AppColors.transparent,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
