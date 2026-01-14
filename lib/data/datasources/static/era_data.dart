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
    accentColor: Color(0xFFCFD8DC),
    backgroundColor: Color(0xFFF5F5F5),
    textColor: Color(0xFF263238),
  );

  static const EraTheme contemporary1 = EraTheme(
    primaryColor: Color(0xFF5D4037), // Deep Brown (전쟁, 흙)
    secondaryColor: Color(0xFF33691E), // Military Green
    accentColor: Color(0xFFD84315),
    backgroundColor: Color(0xFFEFEBE9),
    textColor: Color(0xFF3E2723),
  );

  static const EraTheme contemporary2 = EraTheme(
    primaryColor: Color(0xFF455A64), // Industrial Grey
    secondaryColor: Color(0xFFFF6F00), // Flame Orange
    accentColor: Color(0xFFCFD8DC),
    backgroundColor: Color(0xFFECEFF1),
    textColor: Color(0xFF263238),
  );

  static const EraTheme contemporary3 = EraTheme( // 기존 contemporary theme 재사용 또는 수정
    primaryColor: Color(0xFF3F51B5), // Indigo (IT, 미래지향)
    secondaryColor: Color(0xFFE91E63), // Pink (K-Culture)
    accentColor: Color(0xFF03A9F4), // Light Blue
    backgroundColor: Color(0xFFFAFAFA),
    textColor: Color(0xFF212121),
  );



  /// 대한민국 현대사 테마 (1945-2025)
  static const EraTheme contemporary = EraTheme(
    primaryColor: Color(0xFF37474F), // Steel Grey (산업화/발전)
    secondaryColor: Color(0xFFE53935), // Korean Red (태극기)
    accentColor: Color(0xFF00BCD4), // Cyan (IT/미래지향)
    backgroundColor: Color(0xFFF5F5F5), // Light Grey
    textColor: Color(0xFF212121),
  );

  /// 미래 한반도 테마 (2026-2100)
  static const EraTheme future = EraTheme(
    primaryColor: Color(0xFF6200EE), // Deep Purple (미래/혁신)
    secondaryColor: Color(0xFF00E5FF), // Cyan Accent (첨단)
    accentColor: Color(0xFFE040FB), // Purple Accent (사이버펑크)
    backgroundColor: Color(0xFF121212), // Dark Mode
    textColor: Color(0xFFE0E0E0),
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
    status: ContentStatus.locked,
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
    name: 'North-South States Period',
    nameKorean: '남북국시대',
    period: '668 - 935',
    startYear: 668,
    endYear: 935,
    description:
        '신라의 삼국통일과 발해의 건국으로 시작된 남북국 시대. '
        '장보고의 청해진이 동아시아 해상을 장악하고, '
        '불국사와 석굴암이 건립되며, 발해는 해동성국으로 불리었다.',
    thumbnailAsset: 'assets/images/eras/unified_silla.png',
    backgroundAsset: 'assets/images/locations/unified_silla_bg.png',
    bgmAsset: 'assets/audio/bgm/unified_silla.mp3',
    theme: EraThemes.unifiedSilla,
    chapterIds: ['us_ch1_unification', 'us_ch2_buddhism', 'us_ch3_maritime', 'us_ch4_balhae'],
    characterIds: ['jangbogo', 'wonhyo', 'choi_chiwon', 'dae_joyeong', 'dae_muye'],
    locationIds: ['cheonghaejin', 'bulguksa', 'seokguram', 'gyeongju_anapji', 'sanggyeong'],
    status: ContentStatus.locked,
    estimatedMinutes: 50,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_three_kingdoms',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 45.0,
      minLongitude: 124.0,
      maxLongitude: 135.0,
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
    nameKorean: '근현대(대한제국~해방)',
    period: '1897 - 1950',
    startYear: 1897,
    endYear: 1950,
    description:
        '대한제국 선포부터 일제강점기, 광복, 그리고 분단까지. '
        '안중근, 유관순, 김구 등 수많은 독립운동가들이 나라를 되찾고자 피 흘린 역사.',
    thumbnailAsset: 'assets/images/eras/modern.png',
    backgroundAsset: 'assets/images/locations/modern_bg.png',
    bgmAsset: 'assets/audio/bgm/modern.mp3',
    theme: EraThemes.modern,
    chapterIds: ['modern_ch1_empire', 'modern_ch2_resistance', 'modern_ch3_independence', 'modern_ch4_liberation'],
    characterIds: ['gojong', 'ahn_junggeun', 'yu_gwansun', 'kim_gu', 'ahn_changho', 'yeo_unhyeong', 'syngman_rhee'],
    locationIds: ['deoksugung', 'harbin_station', 'seodaemun_prison', 'shanghai_provisional', 'tapgol_park', 'line_38'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_joseon',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 50.0,
      minLongitude: 120.0,
      maxLongitude: 135.0,
    ),
  );

  /* Deprecated: 현대사 세분화로 인해 삭제 예정
  static const Era koreaContemporary = Era(
    id: 'korea_contemporary',
    countryId: 'korea',
    name: 'Contemporary Korea',
    nameKorean: '대한민국 현대사',
    period: '1945 - 2025',
    startYear: 1945,
    endYear: 2025,
    description:
        '광복 이후의 혼란과 전쟁, 그리고 한강의 기적을 이뤄낸 시기. '
        '민주화와 경제 성장을 동시에 달성하고 세계적인 문화 강국으로 도약하다.',
    thumbnailAsset: 'assets/images/eras/contemporary.png',
    backgroundAsset: 'assets/images/locations/contemporary_bg.png',
    bgmAsset: 'assets/audio/bgm/contemporary.mp3',
    theme: EraThemes.contemporary,
    chapterIds: ['cont_ch1_rebuild', 'cont_ch2_miracle', 'cont_ch3_global'],
    characterIds: [
      'kim_gu', 'sohn_kee_chung', 'student_soldier', // 초기
      'chung_juyoung', 'german_worker', 'democracy_activist', // 중기
      'it_pioneer' // 후기
    ],
    locationIds: [
      'seoul_olympic_stadium',
      'incheon_airport',
      'gangnam_teheran',
      'ddp_dongdaemun'
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_modern',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 39.0,
      minLongitude: 125.0,
      maxLongitude: 130.0,
    ),
  );
  */

  // Era 1: 격동의 태동기 (1945-1959)
  static const Era koreaContemporary1 = Era(
    id: 'korea_contemporary_1',
    countryId: 'korea',
    name: 'The Turbulent Dawn',
    nameKorean: '격동의 태동기',
    period: '1945 - 1959',
    startYear: 1945,
    endYear: 1959,
    description:
        '광복의 기쁨도 잠시, 분단과 전쟁의 아픔을 겪은 시기. '
        '폐허 속에서도 희망을 잃지 않고 생존을 위해 치열하게 살아간 사람들의 이야기.',
    thumbnailAsset: 'assets/images/eras/contemporary_1.png',
    backgroundAsset: 'assets/images/locations/contemporary_1_bg.png',
    bgmAsset: 'assets/audio/bgm/war_memorial.mp3', // 임시
    theme: EraThemes.contemporary1,
    chapterIds: ['cont1_ch1_liberation', 'cont1_ch2_war', 'cont1_ch3_survival'],
    characterIds: [
      'kim_gu', // 광복 직후
      'student_soldier', // 전쟁
      'refugee_merchant' // (신규) 피난민 상인
    ],
    locationIds: [
      'busan_provisional_capital', // (신규) 부산 임시수도
      'gukje_market', // (신규) 국제시장
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 30,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_modern',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 34.0,
      maxLatitude: 39.0, // 휴전선 이남 위주
      minLongitude: 125.0,
      maxLongitude: 130.0,
    ),
  );

  // Era 2: 한강의 기적 (1960-1987)
  static const Era koreaContemporary2 = Era(
    id: 'korea_contemporary_2',
    countryId: 'korea',
    name: 'Miracle on the Han River',
    nameKorean: '한강의 기적',
    period: '1960 - 1987',
    startYear: 1960,
    endYear: 1987,
    description:
        '가난을 벗어나기 위한 땀과 눈물, 그리고 민주화를 향한 뜨거운 외침. '
        '경부고속도로를 달리는 트럭과 광장에서 울려 퍼지는 함성이 교차하는 시대.',
    thumbnailAsset: 'assets/images/eras/contemporary_2.png',
    backgroundAsset: 'assets/images/locations/contemporary_2_bg.png',
    bgmAsset: 'assets/audio/bgm/industrial_city.mp3', // 임시
    theme: EraThemes.contemporary2,
    chapterIds: ['cont2_ch1_industry', 'cont2_ch2_sacrifice', 'cont2_ch3_democracy'],
    characterIds: [
      'sohn_kee_chung', // 이 시기 고문/코치 활동
      'chung_juyoung',
      'german_worker',
      'sewing_worker', // (신규) 여공
      'democracy_activist'
    ],
    locationIds: [
      'ulsan_shipyard', // (이름 변경 필요할수도)
      'seoul_expressway', 
      'pyeonghwa_market' // (신규) 평화시장
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 45,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_contemporary_1',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 39.0,
      minLongitude: 125.0,
      maxLongitude: 130.0,
    ),
  );

  // Era 3: 글로벌 대한민국 (1988-2025)
  static const Era koreaContemporary3 = Era(
    id: 'korea_contemporary_3',
    countryId: 'korea',
    name: 'Global Korea',
    nameKorean: '글로벌 대한민국',
    period: '1988 - 2025',
    startYear: 1988,
    endYear: 2025,
    description:
        '서울올림픽에서 K-Culture까지. IMF 위기를 극복하고 세계의 중심에 서다. '
        '디지털 혁명과 문화의 힘으로 새로운 미래를 여는 대한민국.',
    thumbnailAsset: 'assets/images/eras/contemporary_3.png',
    backgroundAsset: 'assets/images/locations/contemporary_3_bg.png',
    bgmAsset: 'assets/audio/bgm/contemporary.mp3',
    theme: EraThemes.contemporary3,
    chapterIds: ['cont3_ch1_globalstage', 'cont3_ch2_crisis', 'cont3_ch3_culture'],
    characterIds: [
      'imf_survivor', // (신규) IMF 기업가
      'it_pioneer',
      // K-Pop 관련 인물 추가 고려
    ],
    locationIds: [
      'seoul_olympic_stadium',
      'incheon_airport',
      'gangnam_teheran',
      'ddp_dongdaemun'
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 40,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_contemporary_2',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 39.0,
      minLongitude: 125.0,
      maxLongitude: 130.0,
    ),
  );

  /// 대한민국 현대사 (1945-2025)
  static const Era koreaContemporary = Era(
    id: 'korea_contemporary',
    countryId: 'korea',
    name: 'Contemporary Korea',
    nameKorean: '대한민국 현대사',
    period: '1945 - 2025',
    startYear: 1945,
    endYear: 2025,
    description:
        '해방의 기쁨과 분단의 아픔, 전쟁의 폐허에서 일어나 '
        '세계 10위권 경제대국과 IT 강국으로 도약한 대한민국 80년의 역사. '
        '한강의 기적, 민주화 운동, K-문화의 세계화까지.',
    thumbnailAsset: 'assets/images/eras/contemporary.png',
    backgroundAsset: 'assets/images/locations/contemporary_bg.png',
    bgmAsset: 'assets/audio/bgm/contemporary.mp3',
    theme: EraThemes.contemporary,
    chapterIds: [
      'cont_ch1_liberation',   // 해방과 분단
      'cont_ch2_war',          // 전쟁과 재건
      'cont_ch3_miracle',      // 한강의 기적
      'cont_ch4_democracy',    // 민주화의 함성
      'cont_ch5_it',           // IT 강국
    ],
    characterIds: [
      'kim_gu',              // 김구
      'sohn_kee_chung',      // 손기정
      'student_soldier',     // 학도병 (가상)
      'chung_juyoung',       // 정주영
      'german_worker',       // 파독 광부 (가상)
      'democracy_activist',  // 민주화 활동가 (가상)
      'it_pioneer',          // IT 혁신가 (가상)
    ],
    locationIds: [
      'cheonggyecheon_1950',  // 청계천 판자촌
      'ulsan_shipyard',       // 울산 조선소
      'gwanghwamun_1987',     // 광화문 광장 1987
      'gangnam_teheran',      // 테헤란로
      'ddp_dongdaemun',       // DDP
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_modern',
      requiredProgress: 0.3,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 43.0,
      minLongitude: 124.0,
      maxLongitude: 132.0,
    ),
  );

  /// 미래 한반도 (2026-2100)
  static const Era koreaFuture = Era(
    id: 'korea_future',
    countryId: 'korea',
    name: 'Future Korea',
    nameKorean: '미래 한반도',
    period: '2026 - 2100',
    startYear: 2026,
    endYear: 2100,
    description:
        'AI와 로봇이 일상이 된 시대, 기후위기를 극복하고 우주로 나아가며, '
        '통일 한반도의 새로운 역사를 써나가는 미래 세대의 이야기. '
        '상상력과 과학이 만나는 시간 여행의 종착지.',
    thumbnailAsset: 'assets/images/eras/future.png',
    backgroundAsset: 'assets/images/locations/future_bg.png',
    bgmAsset: 'assets/audio/bgm/future.mp3',
    theme: EraThemes.future,
    chapterIds: [
      'future_ch1_ai',          // AI 시대
      'future_ch2_climate',     // 기후위기 극복
      'future_ch3_space',       // 우주 개척
      'future_ch4_unification', // 통일 비전
      'future_ch5_connected',   // 초연결 사회
    ],
    characterIds: [
      'han_jinue',    // AI 연구자 한지능
      'pureunsol',    // 환경 과학자 푸른솔
      'byeolhaneul',  // 우주비행사 별하늘
      'hanaro',       // 통일 세대 청년 하나로
      'youngwon',     // 미래 철학자 영원
    ],
    locationIds: [
      'seoul_metaverse_hub',     // 메타버스 센터
      'jeju_eco_city',           // 제주 에코시티
      'moon_base_baekdu',        // 달 기지 백두
      'pyongyang_seoul_rail',    // 평양-서울 초고속철도역
      'brain_interface_lab',     // 뇌공학 연구소
    ],
    status: ContentStatus.locked,
    estimatedMinutes: 50,
    unlockCondition: UnlockCondition(
      previousEraId: 'korea_contemporary_3',
      requiredProgress: 0.5,
    ),
    mapBounds: MapBounds(
      minLatitude: 33.0,
      maxLatitude: 43.5,
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
    koreaContemporary1,
    koreaContemporary2,
    koreaContemporary3,
    koreaFuture,
    // renaissance,
    // industrialRevolution,
  ];
}
