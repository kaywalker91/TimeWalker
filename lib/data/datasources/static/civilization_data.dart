import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/domain/value_objects/color_value.dart';
import 'package:time_walker/domain/value_objects/point2.dart';

/// 5대 문명 정적 데이터
/// 
/// 시공의 회랑에서 표시되는 문명 데이터를 정의합니다.
class CivilizationData {
  CivilizationData._();

  /// 아시아 문명 (기본 해금)
  static const Civilization asia = Civilization(
    id: 'asia',
    name: '아시아',
    nameEnglish: 'Asia',
    description: '동양 문명의 발상지, 5000년 역사를 품은 대륙',
    iconAsset: 'assets/images/portals/portal_asia.png',
    portalColor: ColorValue(0xFF3B82F6),  // 청색
    glowColor: ColorValue(0xFFFFD700),     // 황금
    countryIds: ['korea', 'china', 'japan'],
    position: Point2(x: 0.25, y: 0.22),     // 좌상단
    unlockLevel: 0,
    status: CivilizationStatus.available,
  );

  /// 유럽 문명
  static const Civilization europe = Civilization(
    id: 'europe',
    name: '유럽',
    nameEnglish: 'Europe',
    description: '서양 문명의 중심, 그리스와 로마의 유산',
    iconAsset: 'assets/images/portals/portal_europe.png',
    portalColor: ColorValue(0xFF22C55E),  // 청록
    glowColor: ColorValue(0xFF60A5FA),     // 하늘색
    countryIds: ['greece', 'rome', 'italy', 'uk'],
    position: Point2(x: 0.75, y: 0.22),     // 우상단
    unlockLevel: 5,
    status: CivilizationStatus.locked,
  );

  /// 아메리카 문명
  static const Civilization americas = Civilization(
    id: 'americas',
    name: '아메리카',
    nameEnglish: 'Americas',
    description: '마야, 아즈텍, 잉카의 신비로운 고대 문명',
    iconAsset: 'assets/images/portals/portal_americas.png',
    portalColor: ColorValue(0xFFEF4444),  // 적색
    glowColor: ColorValue(0xFFFBBF24),     // 태양색
    countryIds: ['maya', 'aztec', 'inca'],
    position: Point2(x: 0.50, y: 0.52),     // 중앙
    unlockLevel: 10,
    status: CivilizationStatus.locked,
  );

  /// 중동 문명
  static const Civilization middleEast = Civilization(
    id: 'middle_east',
    name: '중동',
    nameEnglish: 'Middle East',
    description: '문명의 교차로, 메소포타미아와 페르시아',
    iconAsset: 'assets/images/portals/portal_middle_east.png',
    portalColor: ColorValue(0xFF8B5CF6),  // 자주색
    glowColor: ColorValue(0xFFC084FC),     // 연보라
    countryIds: ['mesopotamia', 'persia', 'ottoman'],
    position: Point2(x: 0.20, y: 0.78),     // 좌하단
    unlockLevel: 15,
    status: CivilizationStatus.locked,
  );

  /// 아프리카 문명
  static const Civilization africa = Civilization(
    id: 'africa',
    name: '아프리카',
    nameEnglish: 'Africa',
    description: '인류의 요람, 고대 이집트 문명의 땅',
    iconAsset: 'assets/images/portals/portal_africa.png',
    portalColor: ColorValue(0xFFF59E0B),  // 황금색
    glowColor: ColorValue(0xFFFCD34D),     // 밝은 황금
    countryIds: ['egypt', 'ethiopia', 'mali'],
    position: Point2(x: 0.80, y: 0.78),     // 우하단
    unlockLevel: 15,
    status: CivilizationStatus.locked,
  );

  // ============== 캐시된 데이터 ==============
  /// 캐시된 전체 문명 목록 (한 번만 생성)
  static final List<Civilization> _cachedAll = [
    asia,
    europe,
    americas,
    middleEast,
    africa,
  ];
  
  /// ID 기반 인덱스 맵 (O(1) 조회)
  static final Map<String, Civilization> _civilizationById = {
    for (final civ in _cachedAll) civ.id: civ,
  };

  /// 모든 문명 목록 반환
  static List<Civilization> get all => _cachedAll;

  /// ID로 문명 조회 (O(1))
  static Civilization? getById(String id) => _civilizationById[id];

  /// 해금된 문명 목록
  static List<Civilization> getUnlocked(int userLevel) {
    return _cachedAll.where((c) => c.unlockLevel <= userLevel).toList();
  }
}
