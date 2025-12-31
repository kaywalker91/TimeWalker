import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

/// 기본 국가 데이터 (MVP - 한반도)
class CountryData {
  CountryData._();

  // ============== 아시아 ==============
  static const Country korea = Country(
    id: 'korea',
    regionId: 'asia',
    name: 'Korean Peninsula',
    nameKorean: '한반도',
    description: '5000년 역사의 땅, 삼국시대부터 조선까지',
    thumbnailAsset: 'assets/images/map/korea.png',
    backgroundAsset: 'assets/images/locations/korea_bg.png',
    position: MapCoordinates(x: 0.82, y: 0.38),
    eraIds: ['korea_three_kingdoms', 'korea_goryeo', 'korea_joseon'],
    status: ContentStatus.available, // MVP 기본 해금
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

  static List<Country> get all => [korea, china, japan, greece, rome, uk, egypt];

  static List<Country> getByRegion(String regionId) {
    return all.where((c) => c.regionId == regionId).toList();
  }

  static Country? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
