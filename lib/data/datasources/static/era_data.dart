import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/utils/map_projection.dart';

/// 기본 시대 테마
class EraThemes {
  EraThemes._();

  static const EraTheme threeKingdoms = EraTheme(
    primaryColor: Color(0xFF8B4513), // 갈색
    secondaryColor: Color(0xFF228B22), // 녹색
    accentColor: Color(0xFFFFD700), // 금색
    backgroundColor: Color(0xFFF5DEB3), // 밀색
    textColor: Color(0xFF2F1810),
  );

  static const EraTheme goryeo = EraTheme(
    primaryColor: Color(0xFF4169E1), // 청색
    secondaryColor: Color(0xFF20B2AA), // 청록
    accentColor: Color(0xFFE6BE8A), // 금동색
    backgroundColor: Color(0xFFF0F8FF), // 연청
    textColor: Color(0xFF1C1C1C),
  );

  static const EraTheme joseon = EraTheme(
    primaryColor: Color(0xFF800020), // 적색
    secondaryColor: Color(0xFF2E8B57), // 녹색
    accentColor: Color(0xFFFFD700), // 금색
    backgroundColor: Color(0xFFFFF8DC), // 크림
    textColor: Color(0xFF1C1C1C),
  );

  static const EraTheme renaissance = EraTheme(
    primaryColor: Color(0xFF6A0DAD), // Royal Purple
    secondaryColor: Color(0xFFDAA520), // Goldenrod
    accentColor: Color(0xFFFFD700), // Gold
    backgroundColor: Color(0xFFFDF5E6), // Old Lace
    textColor: Color(0xFF2F1810),
  );

  static const EraTheme unifiedSilla = EraTheme(
    primaryColor: Color(0xFF4B0082), // Indigo (보라빛 - 귀족적/불교적)
    secondaryColor: Color(0xFFFFD700), // Gold (황금의 나라 신라)
    accentColor: Color(0xFF9370DB), // Medium Purple
    backgroundColor: Color(0xFFFAFAE6), // Ivory
    textColor: Color(0xFF2C1B18),
  );

  static const EraTheme modern = EraTheme(
    primaryColor: Color(0xFF263238), // Blue Grey (근대의 차분함과 암울함)
    secondaryColor: Color(0xFFD84315), // Burnt Orange (독립을 향한 열망)
    accentColor: Color(0xFF78909C), // Light Blue Grey
    backgroundColor: Color(0xFFECEFF1), // Light Grey
    textColor: Color(0xFF212121),
  );

  static const EraTheme industrial = EraTheme(
    primaryColor: Color(0xFF37474F), // Charcoal
    secondaryColor: Color(0xFFFF5722), // Furnace Orange
    accentColor: Color(0xFF78909C), // Steel Grey
    backgroundColor: Color(0xFFECEFF1),
    textColor: Color(0xFF263238),
  );
}

/// 기본 시대 데이터 (MVP - 한반도)
class EraData {
  EraData._();

  // ============== 한반도 시대 ==============
  static const Era koreaThreeKingdoms = Era(
    id: 'korea_three_kingdoms',
    countryId: 'korea',
    name: 'Three Kingdoms Period',
    nameKorean: '삼국시대',
    period: 'BC 57 - AD 668',
    startYear: -57,
    endYear: 668,
    description:
        '고구려, 백제, 신라가 한반도를 삼분하여 다스리던 시대. '
        '광개토대왕의 정복 전쟁, 삼국의 치열한 경쟁, 그리고 신라의 삼국통일까지.',
    thumbnailAsset: 'assets/images/eras/three_kingdoms.png',
    backgroundAsset: 'assets/images/locations/three_kingdoms_bg_2.png',
    bgmAsset: 'assets/audio/bgm/three_kingdoms.mp3',
    theme: EraThemes.threeKingdoms,
    chapterIds: ['tk_ch1_rise', 'tk_ch2_gwanggaeto', 'tk_ch3_unification'],
    characterIds: ['gwanggaeto', 'geunchogo', 'kim_yushin', 'eulji_mundeok', 'seondeok'],
    locationIds: ['goguryeo_palace', 'wiryeseong', 'silla_capital', 'baekje_sabi'],
    status: ContentStatus.available, // MVP 기본 해금
    estimatedMinutes: 45,
    unlockCondition: UnlockCondition(), // 기본 해금
    mapBounds: MapBounds(
      minLatitude: 34.0,
      maxLatitude: 42.5,
      minLongitude: 124.0,
      maxLongitude: 130.8,
    ),
  );

  static const Era koreaUnifiedSilla = Era(
    id: 'korea_unified_silla',
    countryId: 'korea',
    name: 'Unified Silla',
    nameKorean: '통일신라',
    period: '676 - 918',
    startYear: 676,
    endYear: 918,
    description:
        '삼국통일 후 찬란한 불교 문화와 해상 무역이 꽃피운 시대. '
        '장보고의 청해진, 불국사와 석굴암 등 국제적인 문화 국가로 발전하다.',
    thumbnailAsset: 'assets/images/eras/unified_silla.png',
    backgroundAsset: 'assets/images/locations/unified_silla_bg.png',
    bgmAsset: 'assets/audio/bgm/unified_silla.mp3',
    theme: EraThemes.unifiedSilla,
    chapterIds: ['us_ch1_unification', 'us_ch2_buddhism', 'us_ch3_maritime'],
    characterIds: ['jang_bogo', 'choi_chiwon', 'wonhyo'],
    locationIds: ['gyeongju', 'cheonghaejin', 'bulguksa'],
    status: ContentStatus.locked,
    estimatedMinutes: 50,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_three_kingdoms',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 40.0,
      minLongitude: 125.0,
      maxLongitude: 130.0,
    ),
  );

  static const Era koreaGoryeo = Era(
    id: 'korea_goryeo',
    countryId: 'korea',
    name: 'Goryeo Dynasty',
    nameKorean: '고려시대',
    period: '918 - 1392',
    startYear: 918,
    endYear: 1392,
    description:
        '불교 문화가 꽃피운 고려. 거란과 몽골의 침입을 막아내고, '
        '팔만대장경을 새기며 문화 강국의 면모를 보여주다.',
    thumbnailAsset: 'assets/images/eras/goryeo.png',
    backgroundAsset: 'assets/images/locations/goryeo_bg.png',
    bgmAsset: 'assets/audio/bgm/goryeo.mp3',
    theme: EraThemes.goryeo,
    chapterIds: ['goryeo_ch1_unification', 'goryeo_ch2_diplomacy', 'goryeo_ch3_defense'],
    characterIds: ['wanggeon', 'seohee', 'gangamchan', 'gongmin', 'choe_museon', 'mun_ikjeom'],
    locationIds: ['gaegyeong', 'gangdong_6ju', 'guju', 'haeinsa', 'cheongju'],
    status: ContentStatus.locked,
    estimatedMinutes: 40,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_three_kingdoms',
      requiredProgress: 0.3,
    ),
  );

  static const Era koreaJoseon = Era(
    id: 'korea_joseon',
    countryId: 'korea',
    name: 'Joseon Dynasty',
    nameKorean: '조선시대',
    period: '1392 - 1897',
    startYear: 1392,
    endYear: 1897,
    description:
        '유교 사상을 바탕으로 세워진 조선. 한글 창제, 임진왜란, '
        '실학의 발전 등 500년 역사의 굵직한 사건들이 펼쳐진다.',
    thumbnailAsset: 'assets/images/eras/joseon.png',
    backgroundAsset: 'assets/images/locations/joseon_bg.png',
    bgmAsset: 'assets/audio/bgm/joseon.mp3',
    theme: EraThemes.joseon,
    chapterIds: [
      'js_ch1_founding',
      'js_ch2_sejong',
      'js_ch3_imjin',
      'js_ch4_yeongjeongjo',
      'js_ch5_decline',
    ],
    characterIds: [
      'sejong',
      'yi_sun_sin',
      'jeongjo',
      'jeong_yakyong',
      'heo_jun',
      'shin_saimdang',
    ],
    locationIds: [
      'gyeongbokgung',
      'hanyang_market',
      'suwon_hwaseong',
      'geobukseon',
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_unified_silla',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 43.1,
      minLongitude: 124.0,
      maxLongitude: 132.0,
    ),
  );

  static const Era koreaModern = Era(
    id: 'korea_modern',
    countryId: 'korea',
    name: 'Modern Era',
    nameKorean: '근대/일제강점기',
    period: '1897 - 1945',
    startYear: 1897,
    endYear: 1945,
    description:
        '자주 독립을 위한 투쟁과 근대 문물이 들어오던 격동의 시기. '
        '대한제국 선포부터 3.1운동, 안중근 의사의 의거 등 민족의 독립 의지가 불타오르다.',
    thumbnailAsset: 'assets/images/eras/modern.png',
    backgroundAsset: 'assets/images/locations/modern_bg.png',
    bgmAsset: 'assets/audio/bgm/modern.mp3',
    theme: EraThemes.modern,
    chapterIds: ['modern_ch1_empire', 'modern_ch2_resistance', 'modern_ch3_independence'],
    characterIds: ['gojong', 'ahn_junggeun', 'yu_gwansun'],
    locationIds: ['deoksugung', 'harbin', 'seodaemun_prison'],
    status: ContentStatus.locked,
    estimatedMinutes: 45,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_joseon',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 45.0,
      minLongitude: 124.0,
      maxLongitude: 132.0,
    ),
  );

  static const Era europeRenaissance = Era(
    id: 'europe_renaissance',
    countryId: 'italy',
    name: 'The Renaissance',
    nameKorean: '르네상스',
    period: '14th - 17th Century',
    startYear: 1300,
    endYear: 1600,
    description: '예술과 과학, 인문주의가 꽃피운 서양 문명의 황금기. 피렌체와 베네치아를 거닐며 천재들의 숨결을 느껴보세요.',
    thumbnailAsset: 'assets/images/eras/renaissance.png',
    backgroundAsset: 'assets/images/locations/renaissance_bg.png',
    bgmAsset: 'assets/audio/bgm/renaissance.mp3',
    theme: EraThemes.renaissance,
    chapterIds: ['rn_ch1_rebirth', 'rn_ch2_masters', 'rn_ch3_discovery'],
    characterIds: ['davinci', 'galileo'],
    locationIds: ['florence', 'venice'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(
      minLatitude: 35.0,
      maxLatitude: 47.5,
      minLongitude: 6.0,
      maxLongitude: 19.0,
    ),
  );

  static const Era europeIndustrialRevolution = Era(
    id: 'europe_industrial_revolution',
    countryId: 'uk',
    name: 'Industrial Revolution',
    nameKorean: '산업혁명',
    period: '1760 - 1840',
    startYear: 1760,
    endYear: 1840,
    description: '증기기관의 발명과 기계화로 시작된 인류 역사의 대전환점. 공장과 철도가 세상을 바꾼 시대를 탐험하세요.',
    thumbnailAsset: 'assets/images/eras/industrial_revolution.png',
    backgroundAsset: 'assets/images/locations/factory_bg.png',
    bgmAsset: 'assets/audio/bgm/industrial.mp3',
    theme: EraThemes.industrial,
    chapterIds: ['ind_ch1_steam', 'ind_ch2_factory', 'ind_ch3_change'],
    characterIds: ['james_watt', 'stephenson', 'adam_smith'],
    locationIds: ['london', 'manchester', 'steam_factory'],
    status: ContentStatus.locked,
    estimatedMinutes: 50,
    unlockCondition: UnlockCondition(requiredLevel: 3),
    mapBounds: MapBounds(
      minLatitude: 49.0,
      maxLatitude: 60.0,
      minLongitude: -10.0,
      maxLongitude: 2.0,
    ),
  );

  static List<Era> get all => [
    koreaThreeKingdoms,
    koreaUnifiedSilla,
    koreaGoryeo,
    koreaJoseon,
    koreaModern,
    europeRenaissance,
    europeIndustrialRevolution,
  ];
}
