import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

/// 기본 국가 데이터 (MVP - 한반도)
class CountryData {
  CountryData._();

  // ============== 아시아 ==============
  static const Country korea = Country(
    id: 'korea',
    regionId: 'asia',
    name: 'Korean Peninsula',
    nameKorean: '한반도',
    description: '삼국시대의 기상부터 미래의 통일 비전까지.\n반만년 역사의 숨결이 서린 약속의 땅.',
    thumbnailAsset: 'assets/images/map/korea.png',
    backgroundAsset: 'assets/images/locations/korea_bg.png',
    position: MapCoordinates(x: 0.82, y: 0.38),
    eraIds: ['korea_three_kingdoms', 'korea_unified_silla', 'korea_goryeo', 'korea_joseon', 'korea_modern', 'korea_contemporary', 'korea_future'],
    status: ContentStatus.locked,
  );

  static const Country china = Country(
    id: 'china',
    regionId: 'asia',
    name: 'China',
    nameKorean: '중국',
    description: '황하 문명부터 청나라까지, 동아시아 문명의 중심',
    thumbnailAsset: 'assets/images/map/china.png',
    backgroundAsset: 'assets/images/locations/china_bg.png',
    position: MapCoordinates(x: 0.75, y: 0.42),
    eraIds: ['china_three_kingdoms', 'china_tang', 'china_ming'],
    status: ContentStatus.locked,
  );

  static const Country japan = Country(
    id: 'japan',
    regionId: 'asia',
    name: 'Japan',
    nameKorean: '일본',
    description: '사무라이와 쇼군의 나라, 독특한 섬나라 문화',
    thumbnailAsset: 'assets/images/map/japan.png',
    backgroundAsset: 'assets/images/locations/japan_bg.png',
    position: MapCoordinates(x: 0.88, y: 0.40),
    eraIds: ['japan_heian', 'japan_sengoku', 'japan_edo'],
    status: ContentStatus.locked,
  );

  // ============== 유럽 ==============
  static const Country greece = Country(
    id: 'greece',
    regionId: 'europe',
    name: 'Ancient Greece',
    nameKorean: '고대 그리스',
    description: '민주주의와 철학의 발상지',
    thumbnailAsset: 'assets/images/map/greece.png',
    backgroundAsset: 'assets/images/locations/greece_bg.png',
    position: MapCoordinates(x: 0.52, y: 0.40),
    eraIds: ['greece_classical', 'greece_hellenistic'],
    status: ContentStatus.locked,
  );

  static const Country rome = Country(
    id: 'rome',
    regionId: 'europe',
    name: 'Roman Empire',
    nameKorean: '로마 제국',
    description: '유럽을 통일한 거대 제국',
    thumbnailAsset: 'assets/images/map/rome.png',
    backgroundAsset: 'assets/images/locations/rome_bg.png',
    position: MapCoordinates(x: 0.48, y: 0.38),
    eraIds: ['rome_republic', 'rome_empire'],
    status: ContentStatus.locked,
  );

  static const Country uk = Country(
    id: 'uk',
    regionId: 'europe',
    name: 'United Kingdom',
    nameKorean: '영국',
    description: '산업혁명의 발상지이자 해가 지지 않는 제국',
    thumbnailAsset: 'assets/images/map/uk.png',
    backgroundAsset: 'assets/images/locations/uk_bg.png',
    position: MapCoordinates(x: 0.44, y: 0.32),
    eraIds: ['europe_industrial_revolution'],
    status: ContentStatus.locked,
  );

  static const Country italy = Country(
    id: 'italy',
    regionId: 'europe',
    name: 'Italy',
    nameKorean: '이탈리아',
    description: '르네상스의 발상지, 예술과 낭만의 나라',
    thumbnailAsset: 'assets/images/map/italy.png',
    backgroundAsset: 'assets/images/locations/italy_bg.png',
    position: MapCoordinates(x: 0.50, y: 0.38), // 로마 근처
    eraIds: ['europe_renaissance'],
    status: ContentStatus.locked,
  );

  // ============== 아프리카 ==============
  static const Country egypt = Country(
    id: 'egypt',
    regionId: 'africa',
    name: 'Ancient Egypt',
    nameKorean: '고대 이집트',
    description: '피라미드와 파라오의 땅, 나일강의 축복',
    thumbnailAsset: 'assets/images/map/egypt.png',
    backgroundAsset: 'assets/images/locations/egypt_bg.png',
    position: MapCoordinates(x: 0.52, y: 0.48),
    eraIds: ['egypt_old_kingdom', 'egypt_new_kingdom'],
    status: ContentStatus.locked,
  );

  // ============== 캐시된 데이터 ==============
  /// 캐시된 전체 국가 목록 (한 번만 생성)
  static final List<Country> _cachedAll = [korea, china, japan, greece, rome, italy, uk, egypt];
  
  /// ID 기반 인덱스 맵 (O(1) 조회)
  static final Map<String, Country> _countryById = {
    for (final country in _cachedAll) country.id: country,
  };
  
  /// 지역별 국가 목록 캐시
  static final Map<String, List<Country>> _countriesByRegion = _buildRegionIndex();
  
  static Map<String, List<Country>> _buildRegionIndex() {
    final map = <String, List<Country>>{};
    for (final country in _cachedAll) {
      map.putIfAbsent(country.regionId, () => []).add(country);
    }
    return map;
  }

  /// 모든 국가 목록 반환
  static List<Country> get all => _cachedAll;

  /// 지역별 국가 목록 조회 (O(1))
  static List<Country> getByRegion(String regionId) {
    return _countriesByRegion[regionId] ?? [];
  }

  /// ID로 국가 조회 (O(1))
  static Country? getById(String id) => _countryById[id];
}
