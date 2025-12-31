import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// 깜빡이는 커서 위젯
/// 
/// 대화 진행 중 다음으로 넘어갈 수 있음을 표시하는 애니메이션 커서입니다.
/// 타이핑이 완료되고 선택지가 없을 때 화면 우측 하단에 표시됩니다.
class BlinkingCursor extends StatefulWidget {
  /// 커서 아이콘 (기본: 화살표)
  final IconData icon;
  
  /// 커서 크기 (기본: 16)
  final double size;
  
  /// 커서 색상 (기본: AppColors.textPrimary)
  final Color? color;
  
  /// 깜빡임 주기 (기본: 500ms)
  final Duration duration;

  const BlinkingCursor({
    super.key,
    this.icon = Icons.arrow_forward_ios,
    this.size = 16,
    this.color,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Icon(
        widget.icon,
        color: widget.color ?? AppColors.textPrimary,
        size: widget.size,
      ),
    );
  }
}
