import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 지역 마커 컴포넌트
/// PositionComponent를 사용하여 스프라이트 없이도 작동하도록 함
class RegionMarkerComponent extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  final Region region;
  final ContentStatus status;
  final String label;
  final double progress;
  final VoidCallback onTapped;

  // 애니메이션 관련
  final double _baseScale = ExplorationConfig.markerIdleScale;
  final double _hoverScale = ExplorationConfig.markerHoverScale;
  double _currentScale = 1.0;
  bool _isHovered = false;
  bool _isPulsing = false;
  double _pulseTime = 0.0;
  late final TextComponent _labelComponent;

  RegionMarkerComponent({
    required this.region,
    required this.status,
    required this.label,
    required this.progress,
    required this.onTapped,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 마커 크기 설정
    size = Vector2(80, 80);
    anchor = Anchor.center;

    _labelComponent = TextComponent(
      text: label,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y / 2 + 10),
      textRenderer: TextPaint(
        style: TextStyle(
          color: _labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          shadows: const [
            Shadow(
              blurRadius: 4,
              color: Colors.black54,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
    add(_labelComponent);

    // 펄스 애니메이션 시작 (탐험 가능/진행 중 지역)
    if (_shouldPulse) {
      _startPulseAnimation();
    }
  }

  /// 펄스 애니메이션 시작
  void _startPulseAnimation() {
    _isPulsing = true;
    // 애니메이션은 update에서 처리
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isPulsing && _shouldPulse) {
      _pulseTime += dt * ExplorationConfig.markerBounceSpeed;
      _currentScale =
          _baseScale + 0.05 * math.sin(_pulseTime * math.pi * 2);
    } else if (_isHovered) {
      // 호버 시 확대
      _currentScale = _hoverScale;
    } else {
      // 기본 크기로 복귀
      _currentScale = _baseScale;
    }

    scale = Vector2.all(_currentScale);
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    
    // 마커 그리기
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _fillColor;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = _borderColor;

    // 그림자 효과
    if (!_isLocked) {
      final shadowPaint = Paint()
        ..color = _borderColor.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawCircle(
        center,
        size.x / 2,
        shadowPaint,
      );
    }

    // 원 그리기
    canvas.drawCircle(center, size.x / 2, paint);
    canvas.drawCircle(center, size.x / 2, borderPaint);

    // 아이콘 그리기
    final iconPaint = Paint()..color = _borderColor;
    if (_isLocked) {
      // 자물쇠 아이콘 (간단한 사각형)
      canvas.drawRect(
        Rect.fromLTWH(center.dx - size.x * 0.15, center.dy - size.x * 0.15, size.x * 0.3, size.y * 0.3),
        iconPaint,
      );
    } else if (_isCompleted) {
      final checkPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = _borderColor;
      final start = Offset(center.dx - size.x * 0.12, center.dy);
      final mid = Offset(center.dx - size.x * 0.02, center.dy + size.x * 0.12);
      final end = Offset(center.dx + size.x * 0.18, center.dy - size.x * 0.1);
      canvas.drawLine(start, mid, checkPaint);
      canvas.drawLine(mid, end, checkPaint);
    } else {
      // 지구본 아이콘 (원)
      canvas.drawCircle(center, size.x * 0.25, iconPaint);
    }
    
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped();
    super.onTapDown(event);
  }

  @override
  void onHoverEnter() {
    _isHovered = true;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    _isHovered = false;
    super.onHoverExit();
  }

  bool get _isLocked => status == ContentStatus.locked;
  bool get _isCompleted => status == ContentStatus.completed;
  bool get _shouldPulse =>
      status == ContentStatus.available || status == ContentStatus.inProgress;

  Color get _baseColor {
    switch (status) {
      case ContentStatus.locked:
        return Colors.grey;
      case ContentStatus.available:
        return Colors.amber;
      case ContentStatus.inProgress:
        return Colors.blue;
      case ContentStatus.completed:
        return Colors.green;
    }
  }

  Color get _fillColor => _baseColor.withValues(alpha: _isLocked ? 0.15 : 0.2);
  Color get _borderColor => _baseColor;
  Color get _labelColor =>
      _isLocked ? Colors.white38 : _baseColor.withValues(alpha: 0.9);
}
