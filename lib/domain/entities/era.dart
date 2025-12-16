import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart';

/// 시대 엔티티
/// 예: 삼국시대, 고려시대, 조선시대
class Era extends Equatable {
  final String id;
  final String countryId;
  final String name;
  final String nameKorean;
  final String period; // "57 BC - 668 AD"
  final int startYear;
  final int endYear;
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final String bgmAsset;
  final EraTheme theme;
  final List<String> chapterIds;
  final List<String> characterIds;
  final List<String> locationIds;
  final ContentStatus status;
  final double progress;
  final int estimatedMinutes;
  final UnlockCondition unlockCondition;

  const Era({
    required this.id,
    required this.countryId,
    required this.name,
    required this.nameKorean,
    required this.period,
    required this.startYear,
    required this.endYear,
    required this.description,
    required this.thumbnailAsset,
    required this.backgroundAsset,
    required this.bgmAsset,
    required this.theme,
    required this.chapterIds,
    required this.characterIds,
    required this.locationIds,
    this.status = ContentStatus.locked,
    this.progress = 0.0,
    this.estimatedMinutes = 30,
    this.unlockCondition = const UnlockCondition(),
  });

  Era copyWith({
    String? id,
    String? countryId,
    String? name,
    String? nameKorean,
    String? period,
    int? startYear,
    int? endYear,
    String? description,
    String? thumbnailAsset,
    String? backgroundAsset,
    String? bgmAsset,
    EraTheme? theme,
    List<String>? chapterIds,
    List<String>? characterIds,
    List<String>? locationIds,
    ContentStatus? status,
    double? progress,
    int? estimatedMinutes,
    UnlockCondition? unlockCondition,
  }) {
    return Era(
      id: id ?? this.id,
      countryId: countryId ?? this.countryId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      period: period ?? this.period,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      description: description ?? this.description,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      bgmAsset: bgmAsset ?? this.bgmAsset,
      theme: theme ?? this.theme,
      chapterIds: chapterIds ?? this.chapterIds,
      characterIds: characterIds ?? this.characterIds,
      locationIds: locationIds ?? this.locationIds,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      unlockCondition: unlockCondition ?? this.unlockCondition,
    );
  }

  /// 진행률 백분율 (0-100)
  int get progressPercent => (progress * 100).round();

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  /// 기간 (년 수)
  int get durationYears => endYear - startYear;

  /// 인물 수
  int get characterCount => characterIds.length;

  /// 장소 수
  int get locationCount => locationIds.length;

  @override
  List<Object?> get props => [
    id,
    countryId,
    name,
    nameKorean,
    period,
    startYear,
    endYear,
    description,
    thumbnailAsset,
    backgroundAsset,
    bgmAsset,
    theme,
    chapterIds,
    characterIds,
    locationIds,
    status,
    progress,
    estimatedMinutes,
    unlockCondition,
  ];

  @override
  String toString() => 'Era(id: $id, name: $nameKorean, status: $status)';
}

/// 시대 테마 (색상, 분위기)
class EraTheme extends Equatable {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final String fontFamily;

  const EraTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    this.fontFamily = 'NotoSansKR',
  });

  @override
  List<Object?> get props => [
    primaryColor,
    secondaryColor,
    accentColor,
    backgroundColor,
    textColor,
    fontFamily,
  ];
}

/// 해금 조건
class UnlockCondition extends Equatable {
  final String? previousEraId; // 이전 시대 ID
  final double requiredProgress; // 필요 진행률 (0.0 ~ 1.0)
  final int? requiredLevel; // 필요 탐험가 레벨
  final bool isPremium; // 프리미엄 구매 필요 여부

  const UnlockCondition({
    this.previousEraId,
    this.requiredProgress = 0.3,
    this.requiredLevel,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
    previousEraId,
    requiredProgress,
    requiredLevel,
    isPremium,
  ];
}

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
    backgroundAsset: 'assets/images/locations/three_kingdoms_bg.png',
    bgmAsset: 'assets/audio/bgm/three_kingdoms.mp3',
    theme: EraThemes.threeKingdoms,
    chapterIds: ['tk_ch1_rise', 'tk_ch2_gwanggaeto', 'tk_ch3_unification'],
    characterIds: ['gwanggaeto', 'kim_yushin', 'eulji_mundeok', 'seondeok'],
    locationIds: ['goguryeo_palace', 'silla_capital', 'baekje_sabi'],
    status: ContentStatus.available, // MVP 기본 해금
    estimatedMinutes: 45,
    unlockCondition: UnlockCondition(), // 기본 해금
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
    chapterIds: ['gr_ch1_founding', 'gr_ch2_mongol', 'gr_ch3_culture'],
    characterIds: ['wang_geon', 'seo_hui', 'gang_gamchan', 'gongmin'],
    locationIds: ['gaeseong', 'manwoldae', 'haeinsa'],
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
      previousEraId: 'korea_goryeo',
      requiredProgress: 0.3,
    ),
  );

  static List<Era> get all => [koreaThreeKingdoms, koreaGoryeo, koreaJoseon];

  static List<Era> getByCountry(String countryId) {
    return all.where((e) => e.countryId == countryId).toList();
  }

  static Era? getById(String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
