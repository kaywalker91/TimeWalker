import 'package:flutter/material.dart';

/// TimeWalker 앱 색상 팔레트
/// 
/// 디자인 컨셉: "시간의 문 (Portal of Time)"
/// - 고대 유물의 황금빛 + 시간 포탈의 신비로운 보라빛
/// - 양피지와 현대적 UI의 조화
/// - 시대를 넘나드는 동적인 느낌
abstract class AppColors {
  // ============================================
  // PRIMARY COLORS - Time Gold (시간의 황금빛)
  // ============================================
  
  /// 메인 골드 - CTA 버튼, 강조 요소
  static const Color primary = Color(0xFFD4AF37);
  
  /// 다크 골드 - 호버/프레스 상태
  static const Color primaryDark = Color(0xFF8B6914);
  
  /// 라이트 골드 - 하이라이트, 글로우 효과
  static const Color primaryLight = Color(0xFFF2D272);
  
  /// 매우 밝은 골드 - 미묘한 악센트
  static const Color primarySubtle = Color(0xFFFAE8B4);

  // ============================================
  // SECONDARY COLORS - Mystic Purple (시간 포탈)
  // ============================================
  
  /// 미스틱 퍼플 - 보조 악센트, 시간 이펙트
  static const Color secondary = Color(0xFF7B68EE);
  
  /// 딥 바이올렛 - 그라데이션 엔드
  static const Color secondaryDark = Color(0xFF4B0082);
  
  /// 템포럴 글로우 - 발광 효과
  static const Color secondaryLight = Color(0xFFB8A9F8);
  
  /// 미묘한 퍼플 - 배경 악센트
  static const Color secondarySubtle = Color(0xFFE0D8F8);

  // ============================================
  // BACKGROUND COLORS - Ancient Night (고대의 밤)
  // ============================================
  
  /// 메인 배경 - 가장 어두운 레이어
  static const Color background = Color(0xFF0D0D1A);
  
  /// 서피스 - 카드/패널 배경
  static const Color surface = Color(0xFF1A1520);
  
  /// 서피스 라이트 - 상위 레이어
  static const Color surfaceLight = Color(0xFF2D2535);
  
  /// 서피스 고급 - 강조된 카드
  static const Color surfaceElevated = Color(0xFF3D3548);
  
  /// 오버레이 - 모달/다이얼로그 배경
  static const Color overlay = Color(0xCC0D0D1A);

  // ============================================
  // ERA THEME COLORS - 시대별 테마
  // ============================================
  
  /// 고대/선사시대 - 테라코타
  static const Color eraAncient = Color(0xFFCD853F);
  
  /// 삼국시대 - 로얄 블루
  static const Color eraThreeKingdoms = Color(0xFF4169E1);
  
  /// 고려시대 - 제이드 그린
  static const Color eraGoryeo = Color(0xFF2E8B57);
  
  /// 조선시대 - 에메랄드 그린
  static const Color eraJoseon = Color(0xFF00A36C);
  
  /// 근현대 - 스틸 그레이
  static const Color eraModern = Color(0xFF708090);
  
  /// 유럽 - 로얄 퍼플
  static const Color eraEurope = Color(0xFF9370DB);
  
  /// 중동 - 사막 샌드
  static const Color eraMiddleEast = Color(0xFFDEB887);
  
  /// 아시아 (중국) - 황제 레드
  static const Color eraChina = Color(0xFFDC143C);
  
  /// 일본 - 벚꽃 핑크
  static const Color eraJapan = Color(0xFFFFB7C5);

  // ============================================
  // THREE KINGDOMS ERA - 삼국시대 왕국별 색상
  // ============================================
  
  /// 고구려 - 붉은색 계열 (주작, 북방 전사 기질)
  static const Color kingdomGoguryeo = Color(0xFF8B2323);
  static const Color kingdomGoguryeoLight = Color(0xFFCD5C5C);
  static const Color kingdomGoguryeoGlow = Color(0xFFFF4500);

  /// 백제 - 황토/금색 계열 (금동대향로, 문화 예술)
  static const Color kingdomBaekje = Color(0xFF8B7355);
  static const Color kingdomBaekjeLight = Color(0xFFDAA520);
  static const Color kingdomBaekjeGlow = Color(0xFFF5DEB3);

  /// 신라 - 녹색/금색 계열 (불국사, 황금 왕관)
  static const Color kingdomSilla = Color(0xFF1E4D2B);
  static const Color kingdomSillaLight = Color(0xFF228B22);
  static const Color kingdomSillaGlow = Color(0xFFFFD700);

  /// 가야 - 철색/은색 계열 (철기 문화)
  static const Color kingdomGaya = Color(0xFF4A4A4A);
  static const Color kingdomGayaLight = Color(0xFF708090);
  static const Color kingdomGayaGlow = Color(0xFFA9A9A9);

  // ============================================
  // SEMANTIC COLORS - 의미론적 색상
  // ============================================
  
  /// 성공/발견/해금
  static const Color success = Color(0xFF50C878);
  static const Color successDark = Color(0xFF228B22);
  static const Color successLight = Color(0xFF90EE90);
  
  /// 경고/주의/잠금
  static const Color warning = Color(0xFFFFB347);
  static const Color warningDark = Color(0xFFFF8C00);
  static const Color warningLight = Color(0xFFFFDAB9);
  
  /// 오류/실패
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorDark = Color(0xFFDC143C);
  static const Color errorLight = Color(0xFFFFB4B4);
  
  /// 정보/힌트
  static const Color info = Color(0xFF87CEEB);
  static const Color infoDark = Color(0xFF4682B4);
  static const Color infoLight = Color(0xFFB0E0E6);

  // ============================================
  // TEXT COLORS - 텍스트 색상
  // ============================================
  
  /// 주요 텍스트 - 밝은 크림색
  static const Color textPrimary = Color(0xFFF5F5DC);
  
  /// 보조 텍스트
  static const Color textSecondary = Color(0xFFB8B8A8);
  
  /// 비활성 텍스트
  static const Color textDisabled = Color(0xFF6B6B60);
  
  /// 힌트 텍스트
  static const Color textHint = Color(0xFF8B8B7A);
  
  /// 강조 텍스트 - 골드
  static const Color textAccent = primary;
  
  /// 링크 텍스트
  static const Color textLink = secondary;

  // ============================================
  // BORDER & DIVIDER COLORS - 테두리/구분선
  // ============================================
  
  /// 기본 테두리
  static const Color border = Color(0xFF3D3548);
  
  /// 강조 테두리 (골드)
  static const Color borderAccent = Color(0x80D4AF37);
  
  /// 구분선
  static const Color divider = Color(0xFF2D2535);
  
  /// 미묘한 구분선
  static const Color dividerSubtle = Color(0xFF1F1A28);

  // ============================================
  // ICON COLORS - 아이콘 색상
  // ============================================
  
  /// 기본 아이콘 - 크림색
  static const Color iconPrimary = Color(0xFFF5F5DC);
  
  /// 보조 아이콘
  static const Color iconSecondary = Color(0xFFB8B8A8);
  
  /// 비활성 아이콘
  static const Color iconDisabled = Color(0xFF6B6B60);
  
  /// 강조 아이콘 - 골드
  static const Color iconAccent = primary;

  // ============================================
  // SPECIAL COLORS - 특수 효과
  // ============================================
  
  /// 시간 포탈 글로우
  static const Color portalGlow = Color(0xFF7B68EE);
  
  /// 황금 글로우
  static const Color goldenGlow = Color(0xFFD4AF37);
  
  /// 양피지 톤
  static const Color parchment = Color(0xFFF5DEB3);
  
  /// 잉크 색상 (텍스트용)
  static const Color ink = Color(0xFF2C1810);
  
  /// 별빛 반짝임
  static const Color starlight = Color(0xFFFFFACD);

  // ============================================
  // SHOP SPECIFIC COLORS - 상점 전용 색상
  // ============================================
  
  /// 상점 배경
  static const Color shopBackground = surface;
  
  /// 상점 카드 배경
  static const Color shopCardBackground = surfaceLight;
  
  /// 프리미엄 골드
  static const Color premiumGold = Color(0xFFFFD700);
  
  /// 실버
  static const Color silver = Color(0xFFC0C0C0);
  
  /// 브론즈
  static const Color bronze = Color(0xFFCD7F32);

  // ============================================
  // QUIZ SPECIFIC COLORS - 퀴즈 전용 색상
  // ============================================
  
  /// 퀴즈 배경
  static const Color quizBackground = surface;
  
  /// 완료된 퀴즈 카드
  static const Color quizCardCompleted = Color(0xFF2A3C2A);
  
  /// 기본 퀴즈 카드
  static const Color quizCardDefault = surfaceLight;
  
  /// 정답
  static const Color quizCorrect = success;
  
  /// 오답
  static const Color quizIncorrect = error;

  // ============================================
  // DIALOGUE SPECIFIC COLORS - 대화 전용 색상
  // ============================================
  
  /// 대화 화면 배경 (가장 어두운)
  static const Color dialogueBackground = Color(0xFF1E1E2C);
  
  /// 대화 박스 배경
  static const Color dialogueSurface = Color(0xFF2C2C3E);
  
  /// 대화 박스 테두리
  static const Color dialogueBorder = Color(0xFF3C3C4C);
  
  /// 비활성/잠금 선택지 배경
  static const Color dialogueChoiceInactive = Color(0xFF1A1A2E);
  
  /// 활성 선택지 배경
  static const Color dialogueChoiceActive = Color(0xFF2C2C3E);
  
  /// 선택지 테두리 (골드)
  static const Color dialogueChoiceBorder = premiumGold;
  
  /// 화자 이름 색상
  static const Color dialogueSpeakerName = premiumGold;
  
  /// 대화 텍스트 색상
  static const Color dialogueText = textPrimary;
  
  /// 대화 텍스트 보조 색상
  static const Color dialogueTextSecondary = textSecondary;
  
  /// 대화 완료/보상 강조 색상
  static const Color dialogueReward = premiumGold;

  // ============================================
  // ATMOSPHERE COLORS - 분위기 오버레이 색상
  // ============================================
  
  /// 고대 분위기 - 테라코타/흙빛
  static const Color atmosphereAncient = Color(0xFF8B4513);
  
  /// 자연 분위기 - 짙은 청록색
  static const Color atmosphereNature = Color(0xFF2F4F4F);
  
  /// 왕실/귀족 분위기 - 황토색
  static const Color atmosphereRoyal = Color(0xFF8B7355);
  
  /// 산업/도시 분위기 - 슬레이트 블루
  static const Color atmosphereIndustrial = Color(0xFF2C3E50);
  
  /// 기본 분위기 색상
  static const Color atmosphereDefault = Color(0xFF3D3D3D);
  
  /// 불꽃/화염 파티클 색상
  static const Color particleFlame = Color(0xFFFF6B35);
  
  /// 자연/잎사귀 파티클 색상
  static const Color particleNature = Color(0xFF90EE90);
  
  /// 철/금속 파티클 색상
  static const Color particleMetal = Color(0xFFB8B8B8);

  // ============================================
  // SPACE/PORTAL COLORS - 우주/포탈 배경 색상
  // ============================================
  
  /// 깊은 우주 색상
  static const Color spaceDeep = Color(0xFF0D1B2A);
  
  /// 중간 톤 우주 색상
  static const Color spaceMid = Color(0xFF1B263B);
  
  /// 우주 그라데이션 시작 (위)
  static const Color spaceGradientTop = Color(0xFF1a1a2e);
  
  /// 우주 그라데이션 중간
  static const Color spaceGradientMid = Color(0xFF16213e);
  
  /// 우주 그라데이션 끝 (아래)
  static const Color spaceGradientBottom = Color(0xFF0f3460);

  // ============================================
  // COMMON DARK UI COLORS - 공통 다크 UI
  // ============================================
  
  /// 다크 시트/패널 배경
  static const Color darkSheet = Color(0xFF1E1E2C);
  
  /// 다크 카드 배경
  static const Color darkCard = Color(0xFF2C2C3E);
  
  /// 다크 테두리
  static const Color darkBorder = Color(0xFF3C3C4C);
  
  /// 진한 서피스 (시트 핸들 등)
  static const Color darkSurfaceDeep = Color(0xFF1A1A2E);
  
  /// 반투명 다크 오버레이
  static const Color darkOverlay = Color(0xFF151020);

  // ============================================
  // LEGACY COMPATIBILITY - 레거시 호환
  // ============================================

  /// 레거시 골드 (amber 대체)
  static const Color gold = primary;

  // ============================================
  // OPACITY VARIANTS - 투명도 변형
  // ============================================

  /// 화이트 100% (Colors.white 대체)
  static const Color white = Color(0xFFFFFFFF);

  /// 화이트 70% (Colors.white70 대체)
  static const Color white70 = Color(0xB3FFFFFF);

  /// 화이트 60% (Colors.white60 대체)
  static const Color white60 = Color(0x99FFFFFF);

  /// 화이트 54% (Colors.white54 대체)
  static const Color white54 = Color(0x8AFFFFFF);

  /// 화이트 38% (Colors.white38 대체)
  static const Color white38 = Color(0x62FFFFFF);

  /// 화이트 30% (Colors.white30 대체)
  static const Color white30 = Color(0x4DFFFFFF);

  /// 화이트 24% (Colors.white24 대체)
  static const Color white24 = Color(0x3DFFFFFF);

  /// 화이트 12% (Colors.white12 대체)
  static const Color white12 = Color(0x1FFFFFFF);

  /// 화이트 10% (Colors.white10 대체)
  static const Color white10 = Color(0x1AFFFFFF);

  /// 블랙 100% (Colors.black 대체)
  static const Color black = Color(0xFF000000);

  /// 블랙 87% (Colors.black87 대체)
  static const Color black87 = Color(0xDE000000);

  /// 블랙 54% (Colors.black54 대체)
  static const Color black54 = Color(0x8A000000);

  /// 블랙 45% (Colors.black45 대체)
  static const Color black45 = Color(0x73000000);

  /// 블랙 38% (Colors.black38 대체)
  static const Color black38 = Color(0x62000000);

  /// 블랙 26% (Colors.black26 대체)
  static const Color black26 = Color(0x42000000);

  /// 블랙 12% (Colors.black12 대체)
  static const Color black12 = Color(0x1F000000);

  // ============================================
  // SEMANTIC ACCENT COLORS - 의미론적 강조 색상
  // ============================================

  /// 레드 (Colors.red 대체)
  static const Color red = Color(0xFFF44336);

  /// 레드 다크
  static const Color redDark = Color(0xFFD32F2F);

  /// 앰버 (Colors.amber 대체)
  static const Color amber = Color(0xFFFFC107);

  /// 앰버 다크
  static const Color amberDark = Color(0xFFFFA000);

  /// 앰버 라이트 (Colors.amber[300] 대체)
  static const Color amberLight = Color(0xFFFFD54F);

  /// 블루 (Colors.blue 대체)
  static const Color blue = Color(0xFF2196F3);

  /// 블루 다크
  static const Color blueDark = Color(0xFF1976D2);

  /// 그린 (Colors.green 대체)
  static const Color green = Color(0xFF4CAF50);

  /// 그린 다크
  static const Color greenDark = Color(0xFF388E3C);

  /// 오렌지 (Colors.orange 대체)
  static const Color orange = Color(0xFFFF9800);

  /// 오렌지 다크
  static const Color orangeDark = Color(0xFFF57C00);

  /// 옐로우 (Colors.yellow 대체)
  static const Color yellow = Color(0xFFFFEB3B);

  /// 옐로우 다크
  static const Color yellowDark = Color(0xFFFBC02D);

  /// 그레이 (Colors.grey 대체)
  static const Color grey = Color(0xFF9E9E9E);

  /// 그레이 다크 (Colors.grey[700] 대체)
  static const Color greyDark = Color(0xFF616161);

  /// 그레이 라이트 (Colors.grey[300] 대체)
  static const Color greyLight = Color(0xFFE0E0E0);

  /// 그레이 400 (Colors.grey[400] 대체)
  static const Color grey400 = Color(0xFFBDBDBD);

  /// 그레이 500 (Colors.grey[500] 대체)
  static const Color grey500 = Color(0xFF9E9E9E);

  /// 그레이 600 (Colors.grey[600] 대체)
  static const Color grey600 = Color(0xFF757575);

  /// 그레이 700 (Colors.grey[700] 대체)
  static const Color grey700 = Color(0xFF616161);

  /// 그레이 800 (Colors.grey[800] 대체)
  static const Color grey800 = Color(0xFF424242);

  /// 틸 (Colors.teal 대체)
  static const Color teal = Color(0xFF009688);

  /// 퍼플 (Colors.purple 대체)
  static const Color purple = Color(0xFF9C27B0);

  /// 핑크 (Colors.pink 대체)
  static const Color pink = Color(0xFFE91E63);

  /// 인디고 (Colors.indigo 대체)
  static const Color indigo = Color(0xFF3F51B5);

  /// 시안 (Colors.cyan 대체)
  static const Color cyan = Color(0xFF00BCD4);

  /// 라임 (Colors.lime 대체)
  static const Color lime = Color(0xFFCDDC39);

  /// 시안 악센트 (Colors.cyanAccent 대체)
  static const Color cyanAccent = Color(0xFF18FFFF);

  /// 그린 악센트 (Colors.greenAccent 대체)
  static const Color greenAccent = Color(0xFF69F0AE);

  /// 투명 (Colors.transparent 대체)
  static const Color transparent = Color(0x00000000);
}

