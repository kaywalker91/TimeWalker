import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

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

/// 기본 지역 데이터 (MVP)
class RegionData {
  RegionData._();

  static const Region asia = Region(
    id: 'asia',
    name: 'Asia',
    nameKorean: '아시아',
    description: '동양 문명의 발상지, 5000년 역사를 품은 대륙',
    iconAsset: 'assets/images/ui/icon_asia.png',
    thumbnailAsset: 'assets/images/map/asia.png',
    countryIds: ['korea', 'china', 'japan', 'india', 'mongolia'],
    center: MapCoordinates(x: 0.7, y: 0.4),
    defaultZoom: 1.2,
    status: ContentStatus.available, // 기본 해금
    unlockLevel: 0,
  );

  static const Region europe = Region(
    id: 'europe',
    name: 'Europe',
    nameKorean: '유럽',
    description: '서양 문명의 중심, 그리스와 로마의 유산',
    iconAsset: 'assets/images/ui/icon_europe.png',
    thumbnailAsset: 'assets/images/map/europe.png',
    countryIds: ['greece', 'rome', 'britain', 'france', 'germany'],
    center: MapCoordinates(x: 0.45, y: 0.35),
    defaultZoom: 1.3,
    status: ContentStatus.locked,
    unlockLevel: 5, // 아시아 1시대 완료 후
  );

  static const Region africa = Region(
    id: 'africa',
    name: 'Africa',
    nameKorean: '아프리카',
    description: '인류의 요람, 고대 이집트 문명의 땅',
    iconAsset: 'assets/images/ui/icon_africa.png',
    thumbnailAsset: 'assets/images/map/africa.png',
    countryIds: ['egypt', 'ethiopia', 'mali'],
    center: MapCoordinates(x: 0.48, y: 0.55),
    defaultZoom: 1.1,
    status: ContentStatus.locked,
    unlockLevel: 10, // 탐험 레벨 5
  );

  static const Region americas = Region(
    id: 'americas',
    name: 'Americas',
    nameKorean: '아메리카',
    description: '신대륙의 고대 문명, 마야와 잉카의 신비',
    iconAsset: 'assets/images/ui/icon_americas.png',
    thumbnailAsset: 'assets/images/map/americas.png',
    countryIds: ['maya', 'aztec', 'inca', 'usa'],
    center: MapCoordinates(x: 0.25, y: 0.45),
    defaultZoom: 1.0,
    status: ContentStatus.locked,
    unlockLevel: 15, // 탐험 레벨 10
  );

  static const Region middleEast = Region(
    id: 'middle_east',
    name: 'Middle East',
    nameKorean: '중동',
    description: '문명의 교차로, 메소포타미아와 페르시아',
    iconAsset: 'assets/images/ui/icon_middle_east.png',
    thumbnailAsset: 'assets/images/map/middle_east.png',
    countryIds: ['mesopotamia', 'persia', 'ottoman'],
    center: MapCoordinates(x: 0.55, y: 0.42),
    defaultZoom: 1.4,
    status: ContentStatus.locked,
    unlockLevel: 20, // 탐험 레벨 15
  );

  static List<Region> get all => [asia, europe, africa, americas, middleEast];

  static Region? getById(String id) {
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
