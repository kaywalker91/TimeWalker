import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/constants/era_theme_ids.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/shared/geo/map_bounds.dart';

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
    themeId: EraThemeIds.threeKingdoms,
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
    themeId: EraThemeIds.unifiedSilla,
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
    themeId: EraThemeIds.goryeo,
    chapterIds: ['goryeo_ch1_unification', 'goryeo_ch2_diplomacy', 'goryeo_ch3_defense'],
    characterIds: ['wanggeon', 'seohee', 'gangamchan', 'gongmin', 'choe_museon', 'mun_ikjeom'],
    locationIds: ['manwoldae', 'haeinsa', 'ganghwa_island', 'sambyeolcho_jindo', 'gaegyeong_market'],
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
    themeId: EraThemeIds.joseon,
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
    themeId: EraThemeIds.modern,
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
    themeId: EraThemeIds.contemporary,
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
    themeId: EraThemeIds.contemporary1,
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
    themeId: EraThemeIds.contemporary2,
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
    themeId: EraThemeIds.contemporary3,
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
    themeId: EraThemeIds.contemporary,
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
    themeId: EraThemeIds.future,
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

  // ============== 유럽 고대 ==============
  static const Era greeceClassical = Era(
    id: 'greece_classical',
    countryId: 'greece',
    name: 'Classical Greece',
    nameKorean: '고대 그리스',
    period: 'BC 510 - BC 323',
    startYear: -510,
    endYear: -323,
    description: '아테네의 민주주의와 스파르타의 규율, 소크라테스와 플라톤의 철학이 꽃피운 시기.',
    thumbnailAsset: 'assets/images/eras/greece_classical.png',
    backgroundAsset: 'assets/images/locations/greece_bg.png',
    bgmAsset: 'assets/audio/bgm/greece.mp3',
    themeId: EraThemeIds.renaissance, // 임시 재사용
    chapterIds: ['gr_ch1_athens', 'gr_ch2_sparta', 'gr_ch3_persian_war'],
    characterIds: ['socrates', 'pericles', 'leonidas'],
    locationIds: ['parthenon', 'agora', 'thermopylae'],
    status: ContentStatus.locked,
    estimatedMinutes: 50,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(minLatitude: 35.0, maxLatitude: 42.0, minLongitude: 19.0, maxLongitude: 27.0),
  );

  static const Era greeceHellenistic = Era(
    id: 'greece_hellenistic',
    countryId: 'greece',
    name: 'Hellenistic Period',
    nameKorean: '헬레니즘 시대',
    period: 'BC 323 - BC 31',
    startYear: -323,
    endYear: -31,
    description: '알렉산드로스 대왕의 동방 원정으로 그리스 문화가 세계로 뻗어나간 시대.',
    thumbnailAsset: 'assets/images/eras/greece_hellenistic.png',
    backgroundAsset: 'assets/images/locations/hellenistic_bg.png',
    bgmAsset: 'assets/audio/bgm/greece.mp3',
    themeId: EraThemeIds.renaissance,
    chapterIds: ['gr_ch4_alexander', 'gr_ch5_library'],
    characterIds: ['alexander', 'archimedes'],
    locationIds: ['alexandria', 'pergamon'],
    status: ContentStatus.locked,
    estimatedMinutes: 45,
    unlockCondition: UnlockCondition(previousEraId: 'greece_classical', requiredProgress: 0.3),
    mapBounds: MapBounds(minLatitude: 30.0, maxLatitude: 45.0, minLongitude: 20.0, maxLongitude: 70.0),
  );

  static const Era romeRepublic = Era(
    id: 'rome_republic',
    countryId: 'rome',
    name: 'Roman Republic',
    nameKorean: '로마 공화정',
    period: 'BC 509 - BC 27',
    startYear: -509,
    endYear: -27,
    description: '원로원과 인민의 이름으로(SPQR). 카르타고와의 전쟁과 카이사르의 등장이 있었던 공화정 시대.',
    thumbnailAsset: 'assets/images/eras/rome_republic.png',
    backgroundAsset: 'assets/images/locations/rome_bg.png',
    bgmAsset: 'assets/audio/bgm/rome.mp3',
    themeId: EraThemeIds.renaissance,
    chapterIds: ['rm_ch1_punic', 'rm_ch2_caesar'],
    characterIds: ['caesar', 'scipio', 'cicero'],
    locationIds: ['forum_romanum', 'colosseum_construction'],
    status: ContentStatus.locked,
    estimatedMinutes: 55,
    unlockCondition: UnlockCondition(requiredLevel: 3),
    mapBounds: MapBounds(minLatitude: 30.0, maxLatitude: 50.0, minLongitude: -10.0, maxLongitude: 40.0),
  );

  static const Era romeEmpire = Era(
    id: 'rome_empire',
    countryId: 'rome',
    name: 'Roman Empire',
    nameKorean: '로마 제국',
    period: 'BC 27 - AD 476',
    startYear: -27,
    endYear: 476,
    description: '팍스 로마나. 모든 길은 로마로 통한다. 지중해를 호수처럼 품었던 대제국의 영광.',
    thumbnailAsset: 'assets/images/eras/rome_empire.png',
    backgroundAsset: 'assets/images/locations/rome_empire_bg.png',
    bgmAsset: 'assets/audio/bgm/rome.mp3',
    themeId: EraThemeIds.renaissance,
    chapterIds: ['rm_ch3_augustus', 'rm_ch4_pax'],
    characterIds: ['augustus', 'trajan', 'marcus_aurelius'],
    locationIds: ['pantheon', 'pompeii'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(previousEraId: 'rome_republic', requiredProgress: 0.3),
    mapBounds: MapBounds(minLatitude: 20.0, maxLatitude: 60.0, minLongitude: -10.0, maxLongitude: 50.0),
  );

  static const Era europeRenaissance = Era(
    id: 'europe_renaissance',
    countryId: 'italy',
    name: 'The Renaissance',
    nameKorean: '르네상스',
    period: '14th - 17th Century',
    startYear: 1300,
    endYear: 1650,
    description: '예술과 과학, 인문주의가 꽃피운 서양 문명의 황금기. 피렌체와 베네치아를 거닐며 천재들의 숨결을 느껴보세요.',
    thumbnailAsset: 'assets/images/eras/renaissance.png',
    backgroundAsset: 'assets/images/locations/renaissance_bg.png',
    bgmAsset: 'assets/audio/bgm/renaissance.mp3',
    themeId: EraThemeIds.renaissance,
    chapterIds: ['rn_ch1_rebirth', 'rn_ch2_masters', 'rn_ch3_discovery'],
    characterIds: ['davinci', 'michelangelo', 'galileo', 'shakespeare', 'gutenberg'],
    locationIds: ['florence', 'rome_vatican', 'venice', 'london_globe', 'mainz'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(
      minLatitude: 35.0,
      maxLatitude: 55.0,
      minLongitude: -5.0,
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
    themeId: EraThemeIds.industrial,
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

  // ============== 중국 ==============
  static const Era chinaThreeKingdoms = Era(
    id: 'china_three_kingdoms',
    countryId: 'china',
    name: 'Three Kingdoms Period',
    nameKorean: '삼국시대',
    period: 'AD 220 - 280',
    startYear: 220,
    endYear: 280,
    description:
        '위, 촉, 오 세 나라가 천하를 다투던 영웅들의 시대. '
        '조조의 야심, 유비의 인의, 제갈량의 지략이 펼쳐지는 불멸의 서사시.',
    thumbnailAsset: 'assets/images/eras/china_three_kingdoms.png',
    backgroundAsset: 'assets/images/locations/china_three_kingdoms_bg.png',
    bgmAsset: 'assets/audio/bgm/china_epic.mp3',
    themeId: EraThemeIds.threeKingdoms,
    chapterIds: ['cn3k_ch1_chaos', 'cn3k_ch2_heroes', 'cn3k_ch3_unification'],
    characterIds: ['cao_cao', 'liu_bei', 'zhuge_liang', 'guan_yu', 'sun_quan'],
    locationIds: ['chibi', 'chengdu', 'luoyang_wei', 'jianye'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(
      minLatitude: 22.0,
      maxLatitude: 42.0,
      minLongitude: 100.0,
      maxLongitude: 125.0,
    ),
  );

  // ============== 일본 ==============
  static const Era japanSengoku = Era(
    id: 'japan_sengoku',
    countryId: 'japan',
    name: 'Sengoku Period',
    nameKorean: '전국시대',
    period: 'AD 1467 - 1615',
    startYear: 1467,
    endYear: 1615,
    description:
        '하극상의 시대, 전국대명들이 천하통일을 꿈꾸던 격동기. '
        '오다 노부나가, 도요토미 히데요시, 도쿠가와 이에야스 세 영웅의 이야기.',
    thumbnailAsset: 'assets/images/eras/japan_sengoku.png',
    backgroundAsset: 'assets/images/locations/japan_sengoku_bg.png',
    bgmAsset: 'assets/audio/bgm/japan_samurai.mp3',
    themeId: EraThemeIds.joseon, // 임시 - 비슷한 시대
    chapterIds: ['jp_ch1_chaos', 'jp_ch2_unification', 'jp_ch3_peace'],
    characterIds: ['oda_nobunaga', 'toyotomi_hideyoshi', 'tokugawa_ieyasu'],
    locationIds: ['osaka_castle', 'azuchi_castle', 'sekigahara'],
    status: ContentStatus.locked,
    estimatedMinutes: 55,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(
      minLatitude: 31.0,
      maxLatitude: 42.0,
      minLongitude: 129.0,
      maxLongitude: 146.0,
    ),
  );

  // ============== 이집트 ==============
  static const Era egyptAncient = Era(
    id: 'egypt_ancient',
    countryId: 'egypt',
    name: 'Ancient Egypt',
    nameKorean: '고대 이집트',
    period: 'BC 3100 - 30',
    startYear: -3100,
    endYear: 30,
    description:
        '나일강의 축복 아래 피라미드와 스핑크스를 건설한 찬란한 문명. '
        '람세스 2세, 클레오파트라, 투탕카멘 등 파라오들의 신비로운 이야기.',
    thumbnailAsset: 'assets/images/eras/egypt_ancient.png',
    backgroundAsset: 'assets/images/locations/egypt_bg.png',
    bgmAsset: 'assets/audio/bgm/egypt_mystic.mp3',
    themeId: EraThemeIds.threeKingdoms, // 임시 테마
    chapterIds: ['eg_ch1_pyramids', 'eg_ch2_empire', 'eg_ch3_twilight'],
    characterIds: ['ramesses_ii', 'cleopatra', 'tutankhamun', 'imhotep'],
    locationIds: ['pyramids', 'luxor', 'abushimbel', 'alexandria'],
    status: ContentStatus.locked,
    estimatedMinutes: 60,
    unlockCondition: UnlockCondition(requiredLevel: 2),
    mapBounds: MapBounds(
      minLatitude: 22.0,
      maxLatitude: 32.0,
      minLongitude: 25.0,
      maxLongitude: 35.0,
    ),
  );

  // ============== 캐시된 데이터 ==============
  /// 캐시된 전체 시대 목록 (한 번만 생성)
  static final List<Era> _cachedAll = [
    koreaThreeKingdoms,
    koreaUnifiedSilla,
    koreaGoryeo,
    koreaJoseon,
    koreaModern,
    koreaContemporary1,
    koreaContemporary2,
    koreaContemporary3,
    koreaFuture,
    greeceClassical,
    greeceHellenistic,
    romeRepublic,
    romeEmpire,
    europeRenaissance,
    europeIndustrialRevolution,
    chinaThreeKingdoms,
    japanSengoku,
    egyptAncient,
  ];
  
  /// ID 기반 인덱스 맵 (O(1) 조회)
  static final Map<String, Era> _eraById = {
    for (final era in _cachedAll) era.id: era,
  };
  
  /// 국가별 시대 목록 캐시
  static final Map<String, List<Era>> _erasByCountry = _buildCountryIndex();
  
  static Map<String, List<Era>> _buildCountryIndex() {
    final map = <String, List<Era>>{};
    for (final era in _cachedAll) {
      map.putIfAbsent(era.countryId, () => []).add(era);
    }
    return map;
  }

  /// 모든 시대 목록 반환
  static List<Era> get all => _cachedAll;

  /// ID로 시대 조회 (O(1))
  static Era? getById(String id) => _eraById[id];
  
  /// 국가별 시대 목록 조회 (O(1))
  static List<Era> getByCountry(String countryId) {
    return _erasByCountry[countryId] ?? [];
  }
}
