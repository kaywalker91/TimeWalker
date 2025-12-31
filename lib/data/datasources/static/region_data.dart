import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 기본 지역 데이터 (MVP)
/// 
/// 이 파일은 도메인 엔티티와 분리된 정적 데이터를 포함합니다.
/// 추후 API 또는 로컬 DB에서 데이터를 가져올 때 이 클래스만 수정하면 됩니다.
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
    center: MapCoordinates(x: 0.83, y: 0.31), // East Asia: ~120°E, ~35°N
    defaultZoom: 1.2,
    status: ContentStatus.available,
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
    center: MapCoordinates(x: 0.48, y: 0.18), // Europe: Central Europe
    defaultZoom: 1.3,
    status: ContentStatus.available,
    unlockLevel: 5,
  );

  static const Region africa = Region(
    id: 'africa',
    name: 'Africa',
    nameKorean: '아프리카',
    description: '인류의 요람, 고대 이집트 문명의 땅',
    iconAsset: 'assets/images/ui/icon_africa.png',
    thumbnailAsset: 'assets/images/map/africa.png',
    countryIds: ['egypt', 'ethiopia', 'mali'],
    center: MapCoordinates(x: 0.56, y: 0.50), // Africa: ~20°E, ~0°
    defaultZoom: 1.1,
    status: ContentStatus.available,
    unlockLevel: 10,
  );

  static const Region northAmerica = Region(
    id: 'north_america',
    name: 'North America',
    nameKorean: '북아메리카',
    description: '광활한 대륙, 원주민 문명과 신대륙의 역사',
    iconAsset: 'assets/images/ui/icon_americas.png',
    thumbnailAsset: 'assets/images/map/americas.png',
    countryIds: ['usa', 'aztec'],
    center: MapCoordinates(x: 0.15, y: 0.28), // North America: USA/Canada
    defaultZoom: 1.0,
    status: ContentStatus.available,
    unlockLevel: 15,
  );

  static const Region southAmerica = Region(
    id: 'south_america',
    name: 'South America',
    nameKorean: '남아메리카',
    description: '잉카와 마야의 신비, 고대 문명의 보고',
    iconAsset: 'assets/images/ui/icon_americas.png',
    thumbnailAsset: 'assets/images/map/americas.png',
    countryIds: ['maya', 'inca'],
    center: MapCoordinates(x: 0.28, y: 0.62), // South America: Brazil/Peru
    defaultZoom: 1.0,
    status: ContentStatus.available,
    unlockLevel: 15,
  );

  static const Region middleEast = Region(
    id: 'middle_east',
    name: 'Middle East',
    nameKorean: '중동',
    description: '문명의 교차로, 메소포타미아와 페르시아',
    iconAsset: 'assets/images/ui/icon_middle_east.png',
    thumbnailAsset: 'assets/images/map/middle_east.png',
    countryIds: ['mesopotamia', 'persia', 'ottoman'],
    center: MapCoordinates(x: 0.58, y: 0.32), // Middle East: Arabia/Iraq
    defaultZoom: 1.4,
    status: ContentStatus.available,
    unlockLevel: 20,
  );

  static List<Region> get all => [asia, europe, africa, northAmerica, southAmerica, middleEast];

  static Region? getById(String id) {
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
