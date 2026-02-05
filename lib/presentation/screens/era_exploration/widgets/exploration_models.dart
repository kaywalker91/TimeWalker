import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';
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

/// Kingdom tab data
class KingdomTab {
  final String id;
  final String label;

  const KingdomTab({required this.id, required this.label});
}

/// Static kingdom configuration data
abstract class KingdomConfig {
  static const Map<String, KingdomMeta> meta = {
    'goguryeo': KingdomMeta(
      label: '고구려',
      color: AppColors.kingdomGoguryeo,
      lightColor: AppColors.kingdomGoguryeoLight,
      glowColor: AppColors.kingdomGoguryeoGlow,
    ),
    'baekje': KingdomMeta(
      label: '백제',
      color: AppColors.kingdomBaekje,
      lightColor: AppColors.kingdomBaekjeLight,
      glowColor: AppColors.kingdomBaekjeGlow,
    ),
    'silla': KingdomMeta(
      label: '신라',
      color: AppColors.kingdomSilla,
      lightColor: AppColors.kingdomSillaLight,
      glowColor: AppColors.kingdomSillaGlow,
    ),
    'gaya': KingdomMeta(
      label: '가야',
      color: AppColors.kingdomGaya,
      lightColor: AppColors.kingdomGayaLight,
      glowColor: AppColors.kingdomGayaGlow,
    ),
  };

  static const List<KingdomTab> tabs = [
    KingdomTab(id: 'goguryeo', label: '고구려'),
    KingdomTab(id: 'baekje', label: '백제'),
    KingdomTab(id: 'silla', label: '신라'),
    KingdomTab(id: 'gaya', label: '가야'),
  ];

  /// 역사 서순에 맞춘 수동 정렬
  static const Map<String, List<String>> timelineOrder = {
    'goguryeo': [
      'goguryeo_palace',
      'salsu',
      'pyongyang_fortress',
    ],
    'baekje': [
      'wiryeseong',
      'sabi',
      'hwangsanbeol',
    ],
    'silla': [
      'gyeongju_palace',
      'cheomseongdae',
    ],
    'gaya': [
      'gujibong',
      'gimhae_palace',
      'goryeong_palace',
    ],
  };
}

