import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/presentation/widgets/common/time_animations.dart';

/// 공통 로딩 상태 위젯
/// 
/// 모든 화면에서 일관된 로딩 UI를 제공합니다.
/// "시간의 문" 테마에 맞는 시계 로더 또는 기본 로더를 표시합니다.
class CommonLoadingState extends StatelessWidget {
  /// 로딩 메시지 (선택)
  final String? message;
  
  /// 로더 색상 (기본: AppColors.primary)
  final Color? color;
  
  /// 로더 크기 (기본: 48)
  final double size;
  
  /// TimeLoader 사용 여부 (기본: true)
  /// false인 경우 기본 CircularProgressIndicator 사용
  final bool useTimeLoader;
  
  /// 배경 오버레이 표시 여부 (기본: false)
  final bool showOverlay;

  const CommonLoadingState({
    super.key,
    this.message,
    this.color,
    this.size = 48,
    this.useTimeLoader = true,
    this.showOverlay = false,
  });

  /// 중앙 로딩 인디케이터만 표시 (간단한 버전)
  const CommonLoadingState.simple({
    super.key,
    this.color,
    this.size = 32,
  })  : message = null,
        useTimeLoader = false,
        showOverlay = false;

  /// 전체 화면 오버레이 로딩 (Modal 스타일)
  const CommonLoadingState.overlay({
    super.key,
    this.message,
    this.color,
    this.size = 48,
  })  : useTimeLoader = true,
        showOverlay = true;

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? AppColors.primary;
    
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 로더
          if (useTimeLoader)
            TimeLoader(
              size: size,
              color: loaderColor,
              strokeWidth: size / 16,
            )
          else
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
              ),
            ),
          
          // 메시지
          if (message != null) ...[
            const SizedBox(height: 16),
            FadeInWidget(
              delay: const Duration(milliseconds: 300),
              child: Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
    
    // 오버레이 모드인 경우
    if (showOverlay) {
      return Container(
        color: AppColors.overlay,
        child: content,
      );
    }
    
    return content;
  }
}

/// 인라인 로딩 인디케이터
/// 
/// 버튼이나 작은 영역에 사용할 수 있는 컴팩트한 로딩 위젯
class InlineLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const InlineLoadingIndicator({
    super.key,
    this.size = 20,
    this.color,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// 스켈레톤 로딩 박스
/// 
/// 콘텐츠 로딩 중 플레이스홀더로 사용할 수 있는 shimmer 효과 박스
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  /// 원형 스켈레톤 (아바타 등)
  const SkeletonBox.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
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
    final isCircle = widget.borderRadius == null && 
                     widget.width == widget.height;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: _animation.value),
            borderRadius: isCircle 
                ? null 
                : (widget.borderRadius ?? BorderRadius.circular(8)),
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          ),
        );
      },
    );
  }
}
