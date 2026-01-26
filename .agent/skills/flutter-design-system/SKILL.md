---
name: Flutter Design System
description: TimeWalker 앱의 디자인 시스템 가이드. 컬러 팔레트, 그라데이션, 그림자, 텍스트 스타일, 애니메이션 등 UI 컴포넌트 개발 시 일관된 디자인을 적용하기 위한 지침을 제공합니다.
---

# Flutter Design System Skill

TimeWalker 앱의 "시간의 문 (Portal of Time)" 디자인 컨셉을 기반으로 한 디자인 시스템 가이드입니다.

## 디자인 컨셉

- **고대 유물의 황금빛** + **시간 포탈의 신비로운 보라빛**
- 양피지와 현대적 UI의 조화
- 시대를 넘나드는 동적인 느낌

---

## 1. 테마 시스템 사용법

### Import 방법

```dart
import 'package:time_walker/core/themes/themes.dart';
```

이 단일 import로 모든 테마 컴포넌트에 접근할 수 있습니다:
- `AppColors` - 색상 팔레트
- `AppGradients` - 그라데이션
- `AppShadows` - 그림자 효과
- `AppDecorations` - 박스 데코레이션
- `AppTextStyles` - 텍스트 스타일
- `AppAnimations` - 애니메이션

---

## 2. 색상 시스템 (AppColors)

### Primary Colors - 시간의 황금빛

| 색상 | 변수명 | 용도 |
|------|--------|------|
| `#D4AF37` | `AppColors.primary` | CTA 버튼, 강조 요소 |
| `#8B6914` | `AppColors.primaryDark` | 호버/프레스 상태 |
| `#F2D272` | `AppColors.primaryLight` | 하이라이트, 글로우 효과 |
| `#FAE8B4` | `AppColors.primarySubtle` | 미묘한 악센트 |

### Secondary Colors - 시간 포탈

| 색상 | 변수명 | 용도 |
|------|--------|------|
| `#7B68EE` | `AppColors.secondary` | 보조 악센트, 시간 이펙트 |
| `#4B0082` | `AppColors.secondaryDark` | 그라데이션 엔드 |
| `#B8A9F8` | `AppColors.secondaryLight` | 발광 효과 |
| `#E0D8F8` | `AppColors.secondarySubtle` | 배경 악센트 |

### Background Colors - 고대의 밤

| 색상 | 변수명 | 용도 |
|------|--------|------|
| `#0D0D1A` | `AppColors.background` | 메인 배경 |
| `#1A1520` | `AppColors.surface` | 카드/패널 배경 |
| `#2D2535` | `AppColors.surfaceLight` | 상위 레이어 |
| `#3D3548` | `AppColors.surfaceElevated` | 강조된 카드 |
| `#CC0D0D1A` | `AppColors.overlay` | 모달/다이얼로그 배경 |

### 시대별 테마 색상 (Era Colors)

```dart
// 한국사 시대별
AppColors.eraAncient        // 고대/선사시대 - 테라코타
AppColors.eraThreeKingdoms  // 삼국시대 - 로얄 블루
AppColors.eraGoryeo         // 고려시대 - 제이드 그린
AppColors.eraJoseon         // 조선시대 - 에메랄드 그린
AppColors.eraModern         // 근현대 - 스틸 그레이

// 세계사
AppColors.eraEurope         // 유럽 - 로얄 퍼플
AppColors.eraMiddleEast     // 중동 - 사막 샌드
AppColors.eraChina          // 중국 - 황제 레드
AppColors.eraJapan          // 일본 - 벚꽃 핑크
```

### 삼국시대 왕국별 색상

```dart
// 고구려 (붉은색 계열)
AppColors.kingdomGoguryeo       // #8B2323
AppColors.kingdomGoguryeoLight  // #CD5C5C
AppColors.kingdomGoguryeoGlow   // #FF4500

// 백제 (황토/금색 계열)
AppColors.kingdomBaekje         // #8B7355
AppColors.kingdomBaekjeLight    // #DAA520
AppColors.kingdomBaekjeGlow     // #F5DEB3

// 신라 (녹색/금색 계열)
AppColors.kingdomSilla          // #1E4D2B
AppColors.kingdomSillaLight     // #228B22
AppColors.kingdomSillaGlow      // #FFD700

// 가야 (철색/은색 계열)
AppColors.kingdomGaya           // #4A4A4A
AppColors.kingdomGayaLight      // #708090
AppColors.kingdomGayaGlow       // #A9A9A9
```

### Semantic Colors - 의미론적 색상

```dart
// 성공/발견/해금
AppColors.success      // #50C878
AppColors.successDark  // #228B22
AppColors.successLight // #90EE90

// 경고/주의/잠금
AppColors.warning      // #FFB347
AppColors.warningDark  // #FF8C00
AppColors.warningLight // #FFDAB9

// 오류/실패
AppColors.error        // #FF6B6B
AppColors.errorDark    // #DC143C
AppColors.errorLight   // #FFB4B4

// 정보/힌트
AppColors.info         // #87CEEB
AppColors.infoDark     // #4682B4
AppColors.infoLight    // #B0E0E6
```

### 텍스트 색상

```dart
AppColors.textPrimary    // 주요 텍스트 - 밝은 크림색
AppColors.textSecondary  // 보조 텍스트
AppColors.textDisabled   // 비활성 텍스트
AppColors.textHint       // 힌트 텍스트
AppColors.textAccent     // 강조 텍스트 (골드)
AppColors.textLink       // 링크 텍스트 (퍼플)
```

---

## 3. UI 컴포넌트 개발 가이드라인

### 카드 컴포넌트

```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: AppShadows.cardShadow,
  ),
  child: // 카드 내용
)
```

### CTA 버튼

```dart
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.goldenButton,
    borderRadius: BorderRadius.circular(8),
    boxShadow: AppShadows.goldenGlowMd,
  ),
  child: Text(
    'Action',
    style: AppTextStyles.button.copyWith(
      color: AppColors.ink, // 어두운 배경에서 골드 버튼일 때
    ),
  ),
)
```

### 골드 글로우 효과

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.goldenGlow.withOpacity(0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ],
  ),
)
```

### 포탈 글로우 효과

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.portalGlow.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 4,
      ),
    ],
  ),
)
```

---

## 4. 특수 화면 색상

### 대화(Dialogue) 화면

```dart
// 배경
AppColors.dialogueBackground  // 가장 어두운 배경
AppColors.dialogueSurface     // 대화 박스 배경
AppColors.dialogueBorder      // 대화 박스 테두리

// 선택지
AppColors.dialogueChoiceActive    // 활성 선택지
AppColors.dialogueChoiceInactive  // 비활성/잠금 선택지
AppColors.dialogueChoiceBorder    // 선택지 테두리 (골드)

// 텍스트
AppColors.dialogueSpeakerName     // 화자 이름 (골드)
AppColors.dialogueText            // 대화 텍스트
AppColors.dialogueReward          // 보상 강조
```

### 퀴즈 화면

```dart
AppColors.quizBackground     // 퀴즈 배경
AppColors.quizCardDefault    // 기본 퀴즈 카드
AppColors.quizCardCompleted  // 완료된 퀴즈 카드
AppColors.quizCorrect        // 정답 (success)
AppColors.quizIncorrect      // 오답 (error)
```

### 상점 화면

```dart
AppColors.shopBackground      // 상점 배경
AppColors.shopCardBackground  // 상점 카드 배경
AppColors.premiumGold         // 프리미엄 골드
AppColors.silver              // 실버
AppColors.bronze              // 브론즈
```

---

## 5. 베스트 프랙티스

### ✅ DO (권장)

```dart
// 1. 항상 AppColors 상수 사용
Container(color: AppColors.primary)

// 2. 의미론적 색상 사용
Icon(Icons.check, color: AppColors.success)

// 3. 그라데이션으로 깊이감 표현
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.surfaceGradient,
  ),
)

// 4. 적절한 투명도 사용
Container(
  color: AppColors.primary.withOpacity(0.1),
)
```

### ❌ DON'T (피해야 할 것)

```dart
// 1. 하드코딩된 색상 사용 금지
Container(color: Color(0xFFD4AF37)) // ❌

// 2. 기본 Material 색상 사용 금지
Container(color: Colors.amber) // ❌

// 3. 불명확한 색상 조합
Container(
  color: Color(0xFF123456), // ❌ 무슨 색상인지 불명확
)
```

---

## 6. 다크 모드 고려사항

TimeWalker는 기본적으로 다크 테마를 사용합니다. 추가 테마 모드를 지원할 때:

```dart
// ThemeProvider 사용
final isDarkMode = ref.watch(themeProvider).isDarkMode;

// 조건부 색상 적용
Container(
  color: isDarkMode ? AppColors.surface : AppColors.surfaceLight,
)
```

---

## 7. 접근성(Accessibility) 가이드

### 대비율 확인

- 텍스트 대비율: 최소 4.5:1 (일반 텍스트), 3:1 (큰 텍스트)
- `AppColors.textPrimary`와 `AppColors.background` 조합은 WCAG AA 준수

### 색맹 고려

- 색상만으로 정보를 전달하지 않기
- 아이콘, 텍스트 레이블 병행 사용

```dart
// 좋은 예: 색상 + 아이콘
Row(
  children: [
    Icon(Icons.check_circle, color: AppColors.success),
    Text('완료됨', style: TextStyle(color: AppColors.success)),
  ],
)
```

---

## 8. 애니메이션 가이드

### 기본 Duration

```dart
AppAnimations.durationFast    // 150ms - 빠른 피드백
AppAnimations.durationNormal  // 300ms - 일반 전환
AppAnimations.durationSlow    // 500ms - 강조 효과
```

### 추천 Curve

```dart
AppAnimations.curveDefault    // easeInOut - 기본
AppAnimations.curveEmphasize  // easeOutBack - 강조
AppAnimations.curveSmooth     // easeInOutCubic - 부드러운 전환
```

---

## 9. 관련 파일

| 파일 경로 | 내용 |
|-----------|------|
| `lib/core/themes/app_colors.dart` | 모든 색상 정의 |
| `lib/core/themes/app_gradients.dart` | 그라데이션 정의 |
| `lib/core/themes/app_shadows.dart` | 그림자 효과 |
| `lib/core/themes/app_decorations.dart` | 박스 데코레이션 |
| `lib/core/themes/app_text_styles.dart` | 텍스트 스타일 |
| `lib/core/themes/app_animations.dart` | 애니메이션 상수 |
| `lib/core/themes/app_theme.dart` | ThemeData 설정 |
| `lib/core/themes/themes.dart` | 통합 export 파일 |

---

## 10. 새 컴포넌트 개발 체크리스트

새로운 UI 컴포넌트를 개발할 때 확인할 사항:

- [ ] `AppColors`의 색상만 사용했는가?
- [ ] 하드코딩된 색상 값이 없는가?
- [ ] 시대/왕국별 테마 색상을 적절히 적용했는가?
- [ ] 의미론적 색상(success, error, warning, info)을 올바르게 사용했는가?
- [ ] 텍스트 대비율이 충분한가?
- [ ] 호버/프레스 상태가 정의되어 있는가?
- [ ] 애니메이션에 표준 Duration/Curve를 사용했는가?
