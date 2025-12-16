import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 탐험 장소 엔티티
class Location extends Equatable {
  final String id;
  final String eraId;
  final String name;
  final String nameKorean;
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final MapCoordinates position; // 탐험 화면에서의 위치
  final List<String> characterIds; // 이 장소에서 만날 수 있는 인물
  final List<String> eventIds; // 이 장소에서 발생하는 이벤트
  final ContentStatus status;
  final bool isHistorical; // 실제 역사적 장소 여부

  const Location({
    required this.id,
    required this.eraId,
    required this.name,
    required this.nameKorean,
    required this.description,
    required this.thumbnailAsset,
    required this.backgroundAsset,
    required this.position,
    this.characterIds = const [],
    this.eventIds = const [],
    this.status = ContentStatus.locked,
    this.isHistorical = true,
  });

  Location copyWith({
    String? id,
    String? eraId,
    String? name,
    String? nameKorean,
    String? description,
    String? thumbnailAsset,
    String? backgroundAsset,
    MapCoordinates? position,
    List<String>? characterIds,
    List<String>? eventIds,
    ContentStatus? status,
    bool? isHistorical,
  }) {
    return Location(
      id: id ?? this.id,
      eraId: eraId ?? this.eraId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      description: description ?? this.description,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      position: position ?? this.position,
      characterIds: characterIds ?? this.characterIds,
      eventIds: eventIds ?? this.eventIds,
      status: status ?? this.status,
      isHistorical: isHistorical ?? this.isHistorical,
    );
  }

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  /// 만날 수 있는 인물 수
  int get characterCount => characterIds.length;

  @override
  List<Object?> get props => [
    id,
    eraId,
    name,
    nameKorean,
    description,
    thumbnailAsset,
    backgroundAsset,
    position,
    characterIds,
    eventIds,
    status,
    isHistorical,
  ];

  @override
  String toString() => 'Location(id: $id, name: $nameKorean, status: $status)';
}

/// 기본 장소 데이터 (MVP - 조선시대)
class LocationData {
  LocationData._();

  // ============== 조선시대 장소 ==============
  static const Location gyeongbokgung = Location(
    id: 'gyeongbokgung',
    eraId: 'korea_joseon',
    name: 'Gyeongbokgung Palace',
    nameKorean: '경복궁',
    description: '조선의 법궁, 왕과 신하들이 정사를 논하던 곳',
    thumbnailAsset: 'assets/images/locations/gyeongbokgung_thumb.png',
    backgroundAsset: 'assets/images/locations/gyeongbokgung_bg.png',
    position: MapCoordinates(x: 0.5, y: 0.3),
    characterIds: ['sejong', 'jeongjo'],
    eventIds: ['sejong_coronation', 'jeongjo_reform'],
    status: ContentStatus.available,
  );

  static const Location hanyangMarket = Location(
    id: 'hanyang_market',
    eraId: 'korea_joseon',
    name: 'Hanyang Market',
    nameKorean: '한양 저잣거리',
    description: '조선 수도 한양의 번화한 시장 거리',
    thumbnailAsset: 'assets/images/locations/hanyang_market_thumb.png',
    backgroundAsset: 'assets/images/locations/hanyang_market_bg.png',
    position: MapCoordinates(x: 0.6, y: 0.5),
    characterIds: ['merchant', 'scholar'],
    eventIds: [],
    status: ContentStatus.available,
  );

  static const Location suwonHwaseong = Location(
    id: 'suwon_hwaseong',
    eraId: 'korea_joseon',
    name: 'Suwon Hwaseong Fortress',
    nameKorean: '수원화성',
    description: '정조가 건설한 신도시의 성곽, 실학의 결정체',
    thumbnailAsset: 'assets/images/locations/suwon_hwaseong_thumb.png',
    backgroundAsset: 'assets/images/locations/suwon_hwaseong_bg.png',
    position: MapCoordinates(x: 0.55, y: 0.65),
    characterIds: ['jeongjo', 'jeong_yakyong'],
    eventIds: ['hwaseong_construction'],
    status: ContentStatus.locked,
  );

  static const Location geobukseongShip = Location(
    id: 'geobukseon',
    eraId: 'korea_joseon',
    name: 'Geobukseon (Turtle Ship)',
    nameKorean: '거북선',
    description: '이순신 장군의 전설적인 철갑선',
    thumbnailAsset: 'assets/images/locations/geobukseon_thumb.png',
    backgroundAsset: 'assets/images/locations/geobukseon_bg.png',
    position: MapCoordinates(x: 0.35, y: 0.7),
    characterIds: ['yi_sun_sin'],
    eventIds: ['geobukseon_battle'],
    status: ContentStatus.available,
  );

  // ============== 삼국시대 장소 ==============
  static const Location goguryeoPalace = Location(
    id: 'goguryeo_palace',
    eraId: 'korea_three_kingdoms',
    name: 'Gungnae-seong',
    nameKorean: '국내성',
    description: '광개토대왕 시대 고구려의 도읍지',
    thumbnailAsset: 'assets/images/locations/goguryeo_palace_thumb.png',
    backgroundAsset: 'assets/images/locations/goguryeo_palace_bg.png',
    position: MapCoordinates(x: 0.53, y: 0.28), // Adjusted to match background image label
    characterIds: ['gwanggaeto'],
    eventIds: ['gwanggaeto_conquest'],
    status: ContentStatus.available,
  );

  static const Location wiryeseong = Location(
    id: 'wiryeseong',
    eraId: 'korea_three_kingdoms',
    name: 'Wiryeseong (Baekje Capital)',
    nameKorean: '위례성',
    description: '백제의 초기 수도, 한강 유역의 요충지',
    thumbnailAsset: 'assets/images/locations/wiryeseong_thumb.png',
    backgroundAsset: 'assets/images/locations/wiryeseong_bg.png',
    position: MapCoordinates(x: 0.54, y: 0.60), // Adjusted south to Han River area (near Suwon Hwaseong)
    characterIds: [], // Add Baekje characters later
    eventIds: [],
    status: ContentStatus.locked, // Initially locked or available as needed
  );

  static List<Location> get all => [
    gyeongbokgung,
    hanyangMarket,
    suwonHwaseong,
    geobukseongShip,
    goguryeoPalace,
    wiryeseong,
  ];

  static List<Location> getByEra(String eraId) {
    return all.where((l) => l.eraId == eraId).toList();
  }

  static Location? getById(String id) {
    try {
      return all.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
