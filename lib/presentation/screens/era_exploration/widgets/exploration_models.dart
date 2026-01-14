import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/location.dart';

/// 왕국 메타 데이터
/// 
/// 삼국시대 각 왕국의 시각적 정체성을 정의
class KingdomMeta {
  final String label;
  final Color color;
  final Color? lightColor;
  final Color? glowColor;

  const KingdomMeta({
    required this.label,
    required this.color,
    this.lightColor,
    this.glowColor,
  });
}

/// 영토 명세
class TerritorySpec {
  final Offset center;
  final Size size;

  const TerritorySpec(this.center, this.size);
}

/// 마커 엔트리
class MarkerEntry {
  final Location location;
  final Offset position;
  final Color baseColor;
  final bool isDimmed;
  final bool isSelected;

  const MarkerEntry({
    required this.location,
    required this.position,
    required this.baseColor,
    required this.isDimmed,
    required this.isSelected,
  });
}

/// 마커 연결선 정보
class MarkerLine {
  final Offset start;
  final Offset end;
  final Color color;

  const MarkerLine({
    required this.start,
    required this.end,
    required this.color,
  });
}

