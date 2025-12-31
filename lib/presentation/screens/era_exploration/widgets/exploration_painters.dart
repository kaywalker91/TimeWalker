import 'package:flutter/material.dart';
import 'exploration_models.dart';

/// 왕국 영토 표시용 Painter
class KingdomTerritoryPainter extends CustomPainter {
  final Map<String, TerritorySpec> territories;
  final Map<String, KingdomMeta> kingdomMeta;
  final Set<String> activeKingdoms;

  const KingdomTerritoryPainter({
    required this.territories,
    required this.kingdomMeta,
    required this.activeKingdoms,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in territories.entries) {
      final meta = kingdomMeta[entry.key];
      if (meta == null) {
        continue;
      }
      final isActive = activeKingdoms.contains(entry.key);
      final rect = Rect.fromCenter(
        center: Offset(
          entry.value.center.dx * size.width,
          entry.value.center.dy * size.height,
        ),
        width: entry.value.size.width * size.width,
        height: entry.value.size.height * size.height,
      );
      final radius = Radius.circular(rect.shortestSide * 0.18);
      final fillPaint = Paint()
        ..color = meta.color.withValues(alpha: isActive ? 0.12 : 0.05)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = meta.color.withValues(alpha: isActive ? 0.35 : 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), fillPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant KingdomTerritoryPainter oldDelegate) {
    return oldDelegate.activeKingdoms != activeKingdoms ||
        oldDelegate.territories != territories ||
        oldDelegate.kingdomMeta != kingdomMeta;
  }
}

/// 마커 연결선 표시용 Painter
class MarkerConnectionPainter extends CustomPainter {
  final List<MarkerLine> lines;

  const MarkerConnectionPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MarkerConnectionPainter oldDelegate) {
    return oldDelegate.lines != lines;
  }
}
