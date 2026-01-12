import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart' show ContentStatus;
import 'package:time_walker/core/utils/responsive_utils.dart';

/// 강화된 타임라인 거터 위젯
///
/// 시간 포탈 테마의 시각적으로 풍부한 타임라인 노드와 연결선
class EnhancedTimelineGutter extends StatelessWidget {
  final Color accentColor;
  final ContentStatus status;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final String? displayYear;

  const EnhancedTimelineGutter({
    super.key,
    required this.accentColor,
    required this.status,
    this.isFirst = false,
    this.isLast = false,
    this.isSelected = false,
    this.displayYear,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final gutterWidth = responsive.spacing(40);
    final nodeSize = responsive.iconSize(22);

    return SizedBox(
      width: gutterWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 연결선
          if (!isFirst)
            _buildTimelineConnector(
              accentColor,
              responsive,
              isTop: true,
            ),

          // 타임라인 노드
          _TimelineNode(
            accentColor: accentColor,
            status: status,
            isSelected: isSelected,
            nodeSize: nodeSize,
          ),

          // 연도 라벨 (있는 경우)
          if (displayYear != null)
            Padding(
              padding: EdgeInsets.only(top: responsive.spacing(4)),
              child: _buildYearLabel(displayYear!, responsive),
            ),

          // 하단 연결선
          if (!isLast)
            _buildTimelineConnector(
              accentColor,
              responsive,
              isTop: false,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector(
    Color color,
    ResponsiveUtils responsive, {
    required bool isTop,
  }) {
    return Container(
      height: responsive.spacing(16),
      width: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
          end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildYearLabel(String year, ResponsiveUtils responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(6),
        vertical: responsive.padding(2),
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        year,
        style: TextStyle(
          color: Colors.white70,
          fontSize: responsive.fontSize(9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 타임라인 노드 위젯
class _TimelineNode extends StatefulWidget {
  final Color accentColor;
  final ContentStatus status;
  final bool isSelected;
  final double nodeSize;

  const _TimelineNode({
    required this.accentColor,
    required this.status,
    required this.isSelected,
    required this.nodeSize,
  });

  @override
  State<_TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<_TimelineNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 탐험 가능/진행 중 상태에서만 펄스 애니메이션
    if (widget.status == ContentStatus.available ||
        widget.status == ContentStatus.inProgress) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _TimelineNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      if (widget.status == ContentStatus.available ||
          widget.status == ContentStatus.inProgress) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodeColor = _getNodeColor();
    final showGlow = widget.isSelected ||
        widget.status == ContentStatus.completed ||
        widget.status == ContentStatus.inProgress;

    return SizedBox(
      width: widget.nodeSize * 2,
      height: widget.nodeSize * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외부 글로우 링 (선택/완료/진행 중)
          if (showGlow)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                final glowIntensity = widget.status == ContentStatus.completed
                    ? 0.5
                    : 0.3 + (_pulseAnimation.value * 0.3);
                return Container(
                  width: widget.nodeSize * 1.8,
                  height: widget.nodeSize * 1.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        nodeColor.withValues(alpha: glowIntensity),
                        nodeColor.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),

          // 진행 중일 때 회전 링
          if (widget.status == ContentStatus.inProgress)
            _buildProgressRing(),

          // 코어 노드
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.nodeSize,
            height: widget.nodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nodeColor,
              border: Border.all(
                color: widget.isSelected
                    ? Colors.white
                    : widget.accentColor.withValues(alpha: 0.9),
                width: widget.isSelected ? 3 : 2,
              ),
              boxShadow: [
                if (widget.isSelected || widget.status == ContentStatus.completed)
                  BoxShadow(
                    color: nodeColor.withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: _buildNodeIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: widget.nodeSize * 1.5,
      height: widget.nodeSize * 1.5,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.accentColor.withValues(alpha: 0.7),
        ),
        backgroundColor: widget.accentColor.withValues(alpha: 0.2),
      ),
    );
  }

  Widget? _buildNodeIcon() {
    final iconSize = widget.nodeSize * 0.55;

    switch (widget.status) {
      case ContentStatus.locked:
        return Icon(
          Icons.lock,
          size: iconSize,
          color: Colors.white60,
        );
      case ContentStatus.completed:
        return Icon(
          Icons.check,
          size: iconSize,
          color: Colors.white,
        );
      case ContentStatus.inProgress:
        return Icon(
          Icons.play_arrow,
          size: iconSize,
          color: Colors.white,
        );
      case ContentStatus.available:
        return null; // 비어있는 노드
    }
  }

  Color _getNodeColor() {
    switch (widget.status) {
      case ContentStatus.locked:
        return Colors.grey.withValues(alpha: 0.5);
      case ContentStatus.available:
        return widget.isSelected
            ? widget.accentColor.withValues(alpha: 0.9)
            : widget.accentColor.withValues(alpha: 0.6);
      case ContentStatus.inProgress:
        return widget.accentColor.withValues(alpha: 0.85);
      case ContentStatus.completed:
        return Colors.greenAccent.withValues(alpha: 0.9);
    }
  }
}
