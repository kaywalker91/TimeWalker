import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

// Re-export RegionData for backward compatibility
export 'package:time_walker/data/datasources/static/region_data.dart';


/// 지역 (대륙) 엔티티
/// 예: 아시아, 유럽, 아프리카, 아메리카, 중동
class Region extends Equatable {
  final String id;
  final String name;
  final String nameKorean;
  final String description;
  final String iconAsset;
  final String thumbnailAsset;
  final List<String> countryIds;
  final MapCoordinates center;
  final double defaultZoom;
  final ContentStatus status;
  final double progress;
  final int unlockLevel; // 해금에 필요한 탐험가 레벨

  const Region({
    required this.id,
    required this.name,
    required this.nameKorean,
    required this.description,
    required this.iconAsset,
    required this.thumbnailAsset,
    required this.countryIds,
    required this.center,
    this.defaultZoom = 1.0,
    this.status = ContentStatus.locked,
    this.progress = 0.0,
    this.unlockLevel = 0,
  });

  Region copyWith({
    String? id,
    String? name,
    String? nameKorean,
    String? description,
    String? iconAsset,
    String? thumbnailAsset,
    List<String>? countryIds,
    MapCoordinates? center,
    double? defaultZoom,
    ContentStatus? status,
    double? progress,
    int? unlockLevel,
  }) {
    return Region(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      countryIds: countryIds ?? this.countryIds,
      center: center ?? this.center,
      defaultZoom: defaultZoom ?? this.defaultZoom,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      unlockLevel: unlockLevel ?? this.unlockLevel,
    );
  }

  /// 진행률 백분율 (0-100)
  int get progressPercent => (progress * 100).round();

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  @override
  List<Object?> get props => [
    id,
    name,
    nameKorean,
    description,
    iconAsset,
    thumbnailAsset,
    countryIds,
    center,
    defaultZoom,
    status,
    progress,
    unlockLevel,
  ];

  @override
  String toString() => 'Region(id: $id, name: $nameKorean, status: $status)';
}

/// 지도 좌표
class MapCoordinates extends Equatable {
  final double x;
  final double y;

  const MapCoordinates({required this.x, required this.y});

  MapCoordinates copyWith({double? x, double? y}) {
    return MapCoordinates(x: x ?? this.x, y: y ?? this.y);
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => 'MapCoordinates(x: $x, y: $y)';
}

