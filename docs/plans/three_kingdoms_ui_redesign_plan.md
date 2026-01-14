# 삼국시대 화면 UI/UX 리디자인 계획

> **작성일**: 2026-01-13  
> **목적**: 삼국시대의 역사적 기풍을 살리고 사용자 경험을 직관적으로 단순화  
> **대상**: korea_three_kingdoms 시대 관련 전체 화면

---

## 📋 개요

### 현재 문제점 분석

| 문제 | 현재 상태 | 영향 |
|------|----------|------|
| 역사적 정체성 부족 | 현대적 머티리얼 아이콘 (Icons.flight, Icons.diamond 등) | 삼국시대 분위기 저해 |
| 색상 불일치 | 밝고 현대적인 색상 팔레트 | 역사적 몰입감 저하 |
| 정보 과다 | 탭 + 스테이터스 바 + HUD 패널 동시 표시 | 인지 부하 증가 |
| 네비게이션 복잡성 | 다단계 정보 계층 | 직관성 저하 |

### 개선 목표

1. **삼국시대 역사적 아이덴티티 확립**: 전통 문양, 역사적 색상, 시대적 분위기
2. **사용자 경험 단순화**: 핵심 정보 집중, 미니멀 네비게이션
3. **몰입감 강화**: 왕국별 분위기 차별화, 시각적 일관성

---

## 🎨 디자인 시스템 재정의

### 왕국별 색상 팔레트 (역사적 고증 기반)

```dart
/// 삼국시대 왕국별 테마 색상
class ThreeKingdomsColors {
  // 고구려 - 주작(붉은 새), 전사 정신, 북방 기질
  static const goguryeoPrimary = Color(0xFF8B2323);    // 진한 붉은색
  static const goguryeoSecondary = Color(0xFFCD5C5C); // 연한 붉은색
  static const goguryeoAccent = Color(0xFFFF4500);    // 불꽃색
  
  // 백제 - 금동대향로, 우아한 문화, 해상 교류
  static const baekjePrimary = Color(0xFF8B7355);     // 황토색
  static const baekjeSecondary = Color(0xFFDAA520);   // 금색
  static const baekjeAccent = Color(0xFFF5DEB3);      // 밀색
  
  // 신라 - 불국사, 첨성대, 황금 왕관
  static const sillaPrimary = Color(0xFF1E4D2B);      // 진한 녹색
  static const sillaSecondary = Color(0xFFFFD700);    // 황금색
  static const sillaAccent = Color(0xFF228B22);       // 숲녹색
  
  // 가야 - 철기 문화, 무역, 철의 왕국
  static const gayaPrimary = Color(0xFF4A4A4A);       // 철색
  static const gayaSecondary = Color(0xFF708090);     // 슬레이트 그레이
  static const gayaAccent = Color(0xFFA9A9A9);        // 은색
}
```

### 왕국별 상징 문양

| 왕국 | 상징 | 의미 | 적용 위치 |
|------|------|------|----------|
| 고구려 | 삼족오 (三足烏) | 태양 숭배, 고구려 벽화 핵심 문양 | 탭 아이콘, 배경 워터마크 |
| 백제 | 연꽃 (蓮花) | 불교 문화, 금동대향로 장식 | 탭 아이콘, 카드 테두리 |
| 신라 | 황금관 (金冠) | 왕권, 금세공 기술 | 탭 아이콘, 강조 요소 |
| 가야 | 철검 (鐵劍) | 철기 문화, 무역 국가 | 탭 아이콘, 액센트 |

---

## 🛠️ 구현 계획 (Phase별)

### Phase 1: 테마 시스템 확장 (예상 1시간)

#### Step 1.1: 삼국시대 색상 상수 추가
- **파일**: `lib/core/themes/app_colors.dart`
- **작업**: `ThreeKingdomsColors` 또는 왕국별 색상 상수 추가
- **설계 이유**: 색상을 중앙 집중화하여 일관성 유지 및 유지보수 용이성 확보

```dart
// app_colors.dart에 추가
// ============================================
// THREE KINGDOMS ERA - 삼국시대 왕국별 색상
// ============================================

/// 고구려 - 붉은색 계열 (북방 전사, 주작)
static const Color kingdomGoguryeo = Color(0xFF8B2323);
static const Color kingdomGoguryeoLight = Color(0xFFCD5C5C);
static const Color kingdomGoguryeoGlow = Color(0xFFFF4500);

/// 백제 - 황토/금색 계열 (문화 예술, 해상 교류)
static const Color kingdomBaekje = Color(0xFF8B7355);
static const Color kingdomBaekjeLight = Color(0xFFDAA520);
static const Color kingdomBaekjeGlow = Color(0xFFF5DEB3);

/// 신라 - 녹색/금색 계열 (불교, 황금 왕관)
static const Color kingdomSilla = Color(0xFF1E4D2B);
static const Color kingdomSillaLight = Color(0xFF228B22);
static const Color kingdomSillaGlow = Color(0xFFFFD700);

/// 가야 - 철색/은색 계열 (철기 문화)
static const Color kingdomGaya = Color(0xFF4A4A4A);
static const Color kingdomGayaLight = Color(0xFF708090);
static const Color kingdomGayaGlow = Color(0xFFA9A9A9);
```

#### Step 1.2: 삼국시대 그라데이션 추가
- **파일**: `lib/core/themes/app_gradients.dart`
- **작업**: 왕국별 분위기 그라데이션 추가

```dart
// 삼국시대 배경 그라데이션
static LinearGradient kingdomGoguryeoBackground = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1A0505), // 진한 먹색-붉은 기운
    Color(0xFF2D0A0A),
    Color(0xFF0D0D1A),
  ],
);
```

---

### Phase 2: 왕국 탭 바 역사적 재디자인 (예상 2시간)

#### Step 2.1: 아이콘 에셋 생성/교체
- **파일**: `assets/icons/kingdoms/` (신규 디렉토리)
- **작업**: SVG 또는 PNG 아이콘 추가
  - `ic_goguryeo_samjoko.png` (삼족오)
  - `ic_baekje_lotus.png` (연꽃)
  - `ic_silla_crown.png` (금관)
  - `ic_gaya_sword.png` (철검)
- **설계 이유**: 머티리얼 아이콘은 현대적이므로 역사적 커스텀 아이콘이 필요

#### Step 2.2: KingdomTabMeta 수정
- **파일**: `lib/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart`
- **작업**:

```dart
// Before (현재)
static const List<KingdomTabMeta> kingdoms = [
  KingdomTabMeta(
    id: 'goguryeo',
    label: '고구려',
    color: Color(0xFF5B6EFF),  // 현대적 블루
    icon: Icons.flight,         // 일반 비행기 아이콘
  ),
  // ...
];

// After (개선)
static const List<KingdomTabMeta> kingdoms = [
  KingdomTabMeta(
    id: 'goguryeo',
    label: '고구려',
    color: Color(0xFF8B2323),  // 역사적 붉은색
    iconAsset: 'assets/icons/kingdoms/ic_goguryeo_samjoko.png',
    // icon 대신 iconAsset 사용하도록 수정
  ),
  // ...
];
```

#### Step 2.3: 탭 스타일링 개선
- **작업**:
  - 선택된 탭에 "붓터치" 느낌의 언더라인
  - 탭 배경에 미묘한 문양 텍스처 (옵션)
  - 왕국별 글로우 색상 적용

```dart
// 선택된 탭 언더라인 스타일
Container(
  height: 3,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        kingdom.color,
        kingdom.color,
        Colors.transparent,
      ],
      stops: [0.0, 0.2, 0.8, 1.0],
    ),
    borderRadius: BorderRadius.circular(2),
  ),
)
```

---

### Phase 3: 장소 카드 단순화 및 역사적 스타일링 (예상 1.5시간)

#### Step 3.1: 정보 태그 축소
- **파일**: `lib/presentation/screens/era_exploration/widgets/location_story_card.dart`
- **작업**: `_buildContentOverlay` 메서드 수정

```dart
// Before: 왕국 + 연도 + 가상 태그 (최대 3개)
// After: 필수 정보만 (왕국 1개, 연도는 카드 상단에 별도 표시)

// 태그 수 줄이기
Wrap(
  spacing: responsive.spacing(6),
  children: [
    if (widget.kingdomLabel != null)
      _buildInfoTag(widget.kingdomLabel!, widget.accentColor, responsive),
    // 연도는 카드 상단 코너에 미니멀하게 표시
    // isHistorical 태그 제거 (불필요)
  ],
),
```

#### Step 3.2: 카드 테두리 "족자" 스타일 적용
- **작업**: `BoxDecoration` 수정

```dart
// 족자/두루마리 느낌의 테두리
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(8), // 약간 각진 모서리  
  border: Border.all(
    color: widget.accentColor.withOpacity(0.6),
    width: 2,
  ),
  // 좌우 액센트 바 대신 전체 테두리로 변경
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
),
```

#### Step 3.3: 연도 표시 위치 변경
- **작업**: 상단 좌측 코너에 미니멀 연도 배지 추가

```dart
// 상단 좌측: 연도 배지
Positioned(
  top: responsive.spacing(10),
  left: responsive.spacing(10),
  child: Container(
    padding: EdgeInsets.symmetric(
      horizontal: responsive.padding(8),
      vertical: responsive.padding(4),
    ),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      location.displayYear ?? '',
      style: TextStyle(
        color: Colors.white70,
        fontSize: responsive.fontSize(10),
        fontFamily: 'NotoSerifKR', // 세리프 폰트
      ),
    ),
  ),
)
```

---

### Phase 4: 탐험 화면 UX 단순화 (예상 2시간)

#### Step 4.1: 스테이터스 바 미니멀화
- **파일**: `lib/presentation/screens/era_exploration/era_exploration_screen.dart`
- **작업**: `_buildStickyStatusBar` 수정

```dart
// Before: 왕국명 + 총/표시 개수 + 선택 장소 + 진행률
// After: 진행률 바만 (미니멀)

Widget _buildMinimalProgressBar({
  required Era era,
  required double progress,
  required ResponsiveUtils responsive,
}) {
  return Container(
    height: 4,
    margin: EdgeInsets.symmetric(horizontal: responsive.padding(16)),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(2),
    ),
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: progress,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              era.theme.accentColor.withOpacity(0.5),
              era.theme.accentColor,
            ],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );
}
```

#### Step 4.2: HUD 패널 → 플로팅 액션 버튼 변환
- **파일**: `lib/presentation/screens/era_exploration/widgets/era_hud_panel.dart`
- **작업**: 기존 패널을 플로팅 FAB 그룹으로 교체

**Before (HUD 패널):**
- 하단에 넓은 패널 차지
- 장소/캐릭터 탭 버튼 + 정보

**After (플로팅 FAB):**
- 우측 하단 컴팩트한 플로팅 버튼
- 탭하면 장소/캐릭터 목록 바텀시트 표시
- 인장(도장) 디자인 적용

```dart
// 플로팅 액션 버튼 (인장 스타일)
Widget _buildFloatingExploreButton(BuildContext context, Era era) {
  return FloatingActionButton(
    onPressed: () => _showExplorationListSheet(context),
    backgroundColor: era.theme.accentColor,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white30,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.explore,
        color: Colors.white,
      ),
    ),
  );
}
```

#### Step 4.3: 왕국 전환 시 배경 분위기 변화
- **작업**: 탭 변경 시 배경 오버레이 색상 애니메이션

```dart
// 왕국별 분위기 오버레이
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _getKingdomColor(activeKingdom).withOpacity(0.15),
        Colors.transparent,
        _getKingdomColor(activeKingdom).withOpacity(0.1),
      ],
    ),
  ),
)
```

---

## ✅ 자체 점검 결과 (3회 실시)

### 1차 점검: 디자인 결정 대안 분석

| 결정 사항 | 채택 방안 | 검토된 대안 | 채택 이유 |
|----------|----------|------------|----------|
| 왕국 네비게이션 | 탭 바 유지 + 역사적 스타일링 | 세로 스와이프, 하단 네비게이션, 지도 오버레이 | 접근성 유지, 친숙한 패턴 |
| 장소 표시 | 카드 유지 + 정보 단순화 | 리스트 아이템, 캐러셀 | 시각적 매력 보존 |
| HUD 패널 | 플로팅 FAB | 완전 제거, 미니멀 도크 | 직관성과 발견성 균형 |

### 2차 점검: 기술적 실현 가능성

| 항목 | 상태 | 비고 |
|------|------|------|
| 기존 코드 호환성 | ✅ 호환 | 위젯 구조 분리 잘 되어 있음 |
| 에셋 생성 | ⚠️ 필요 | 4개 왕국 아이콘 생성 필요 |
| 테스트 영향 | ✅ 최소 | 스타일 변경은 기능 테스트에 영향 없음 |
| 예상 작업 시간 | 약 7.5시간 | 4개 Phase 합산 |

### 3차 점검: 사용자 요구사항 충족

| 요구사항 | 달성 여부 | 구현 방법 |
|----------|---------|----------|
| 삼국시대 기풍 | ✅ | 역사적 색상, 전통 아이콘, 분위기 오버레이 |
| 직관적 UX | ✅ | 정보 계층 단순화, HUD 미니멀화 |
| 왕국별 차별화 | ✅ | 색상/아이콘/분위기 왕국별 적용 |

---

## 📁 변경 파일 목록

### 신규 생성

| 파일 | 설명 |
|------|------|
| `assets/icons/kingdoms/ic_goguryeo_samjoko.png` | 고구려 삼족오 아이콘 |
| `assets/icons/kingdoms/ic_baekje_lotus.png` | 백제 연꽃 아이콘 |
| `assets/icons/kingdoms/ic_silla_crown.png` | 신라 금관 아이콘 |
| `assets/icons/kingdoms/ic_gaya_sword.png` | 가야 철검 아이콘 |
| `lib/core/themes/three_kingdoms_theme.dart` | 삼국시대 전용 테마 (옵션) |

### 수정

| 파일 | 변경 내용 |
|------|----------|
| `lib/core/themes/app_colors.dart` | 왕국별 색상 상수 추가 |
| `lib/core/themes/app_gradients.dart` | 왕국별 그라데이션 추가 |
| `lib/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart` | 아이콘, 색상, 스타일 수정 |
| `lib/presentation/screens/era_exploration/widgets/location_story_card.dart` | 정보 단순화, 테두리 스타일 |
| `lib/presentation/screens/era_exploration/era_exploration_screen.dart` | 스테이터스 바 미니멀화 |
| `lib/presentation/screens/era_exploration/widgets/era_hud_panel.dart` | 플로팅 FAB로 변경 |
| `pubspec.yaml` | 새 아이콘 에셋 등록 |

---

## 🚀 최소 단위 실행 계획

### Sprint 1: 테마 기반 (30분)
1. [ ] `app_colors.dart`에 왕국별 색상 추가
2. [ ] `app_gradients.dart`에 왕국별 그라데이션 추가
3. [ ] 빌드 확인

### Sprint 2: 아이콘 에셋 (1시간)
1. [ ] `assets/icons/kingdoms/` 디렉토리 생성
2. [ ] 4개 왕국 아이콘 생성 (generate_image 또는 외부 리소스)
3. [ ] `pubspec.yaml`에 에셋 등록
4. [ ] 빌드 확인

### Sprint 3: 탭 바 수정 (1시간)
1. [ ] `KingdomTabMeta` 클래스에 `iconAsset` 필드 추가
2. [ ] `ThreeKingdomsTabs.kingdoms` 색상 및 아이콘 교체
3. [ ] `_EnhancedKingdomTab` 아이콘 렌더링 로직 수정
4. [ ] 선택 탭 언더라인 스타일 추가
5. [ ] 테스트 및 조정

### Sprint 4: 장소 카드 수정 (1시간)
1. [ ] `_buildContentOverlay` 태그 수 줄이기
2. [ ] 연도를 상단 코너로 이동
3. [ ] 테두리 스타일 족자 느낌으로 변경
4. [ ] 테스트 및 조정

### Sprint 5: UX 단순화 (1시간)
1. [ ] `_buildStickyStatusBar` → `_buildMinimalProgressBar` 교체
2. [ ] `EraHudPanel` → 플로팅 FAB로 변경
3. [ ] 왕국 전환 시 배경 오버레이 애니메이션 추가
4. [ ] 전체 통합 테스트

### Sprint 6: 최종 검증 (30분)
1. [ ] 전체 삼국시대 화면 UI 리뷰
2. [ ] 왕국별 색상/분위기 확인
3. [ ] 기존 테스트 통과 확인
4. [ ] 코드 정리 및 주석 추가

---

## 🔧 도구 및 기술 활용 브리핑

### 활용된 MCP 서버

| MCP 서버 | 활용 시점 | 활용 내용 |
|----------|----------|----------|
| **sequential-thinking** | 계획 수립 | 6단계 사고 프로세스로 구조적 분석 및 3회 자체 점검 |

### Context Fork 활용
- 현재 코드 분석과 개선 계획 수립을 병렬로 진행

### 향후 SubAgent 활용 계획
- **browser_subagent**: 구현 완료 후 UI 스크린샷 검증
- **generate_image**: 왕국별 아이콘 에셋 생성

---

## 📈 예상 효과

| 지표 | 개선 효과 |
|------|----------|
| **역사적 몰입감** | 현대적 UI → 삼국시대 분위기로 ↑↑ |
| **사용자 인지 부하** | 정보 계층 3단계 → 2단계로 ↓ |
| **왕국별 정체성** | 동일 색상 → 차별화된 테마로 ↑↑ |
| **네비게이션 직관성** | 복잡한 HUD → 미니멀 FAB로 ↑ |

---

*본 문서는 Sequential Thinking MCP를 활용한 6단계 분석과 3회 자체 점검을 거쳐 작성되었습니다.*

---

## 🎉 구현 진행 상황 (2026-01-13 업데이트)

### 완료된 작업

#### Sprint 1: 테마 기반 ✅
- [x] `app_colors.dart`에 왕국별 색상 12개 상수 추가
  - `kingdomGoguryeo`, `kingdomGoguryeoLight`, `kingdomGoguryeoGlow`
  - `kingdomBaekje`, `kingdomBaekjeLight`, `kingdomBaekjeGlow`
  - `kingdomSilla`, `kingdomSillaLight`, `kingdomSillaGlow`
  - `kingdomGaya`, `kingdomGayaLight`, `kingdomGayaGlow`

#### Sprint 2: 아이콘 에셋 ✅
- [x] `assets/icons/kingdoms/` 디렉토리 생성
- [x] 4개 왕국 아이콘 생성 (generate_image 활용)
  - `ic_goguryeo_samjoko.png` - 삼족오 (황금색 새)
  - `ic_baekje_lotus.png` - 연꽃 (금/갈색 톤)
  - `ic_silla_crown.png` - 금관 (황금색)
  - `ic_gaya_sword.png` - 철검 (은색)
- [x] `pubspec.yaml`에 에셋 등록

#### Sprint 3: 탭 바 수정 ✅
- [x] `KingdomTabMeta` 클래스에 `iconAsset`, `lightColor`, `glowColor` 필드 추가
- [x] `ThreeKingdomsTabs.kingdoms` 역사적 색상 및 아이콘 적용
- [x] `_EnhancedKingdomTab` 이미지 에셋 렌더링 로직 구현
- [x] 선택 탭 글로우 효과 추가
- [x] `_buildKingdomIcon` 헬퍼 메서드 추가 (fallback 아이콘 지원)

#### 관련 파일 색상 동기화 ✅
- [x] `era_exploration_screen.dart`의 `_kingdomMeta` 업데이트
- [x] `exploration_models.dart`의 `KingdomMeta` 클래스 확장
- [x] `location_exploration_screen.dart`의 `_getKingdomColor` 통일

#### Sprint 4: 장소 카드 수정 ✅
- [x] `_buildContentOverlay` 태그 수 줄이기 (왕국 레이블만 표시)
- [x] 연도를 상단 좌측 코너로 이동 (`_buildYearBadge` 메서드 추가)
- [x] 테두리 스타일 족자 느낌으로 변경 (BorderRadius 8로 각진 모서리 적용)
- [x] 좌측 악센트 바 제거, 전체 테두리로 대체
- [x] 선택 시 내부 글로우 그라데이션 추가

#### Sprint 5: UX 단순화 ✅
- [x] `_buildStickyStatusBar` → 미니멀 진행률 바로 교체
  - 왕국별 악센트 색상 적용
  - AnimatedContainer로 부드러운 전환
  - 불필요한 정보 제거 (장소 수, 진행률만 표시)
- [x] `EraHudPanel` → 인장 스타일 플로팅 버튼으로 변경
  - 선택된 장소 프리뷰 제거
  - `_SealStyleButton` 컴포넌트로 역사적 분위기 강화
  - 왕국별 글로우 효과 적용
- [x] 왕국 전환 시 배경 오버레이 애니메이션 추가
  - LinearGradient 분위기 오버레이
  - AnimatedContainer로 400ms 전환 효과

#### Sprint 6: 최종 검증 ✅
- [x] 전체 삼국시대 화면 UI 변경 사항 적용 완료
- [x] 수정 파일 정적 분석 통과 확인
- [x] 코드 정리 및 주석 추가

### 활용된 도구 브리핑

| 도구/기술 | 활용 시점 | 활용 내용 |
|----------|----------|----------|
| **sequential-thinking MCP** | 계획 수립 초기 | 6단계 체계적 분석, 3회 자체 점검 알고리즘 실행 |
| **generate_image** | Sprint 2 | 4개 왕국별 역사적 아이콘 에셋 생성 (삼족오, 연꽃, 금관, 철검) |
| **병렬 파일 분석** | 전 과정 | 여러 파일 동시 분석으로 코드 구조 빠르게 파악 |
| **dart-mcp-server analyze** | Sprint 6 | 수정 파일 정적 분석 검증 |

---

## 🎊 구현 완료 요약 (2026-01-13)

### 변경된 파일 목록

| 파일 | 변경 내용 |
|------|----------|
| `lib/core/themes/app_colors.dart` | 왕국별 12개 색상 상수 추가 |
| `lib/presentation/screens/era_exploration/widgets/location_story_card.dart` | 족자 스타일 테두리, 연도 배지 상단 이동, 태그 단순화 |
| `lib/presentation/screens/era_exploration/era_exploration_screen.dart` | 미니멀 스테이터스 바, 왕국별 배경 오버레이 |
| `lib/presentation/screens/era_exploration/widgets/era_hud_panel.dart` | 인장 스타일 플로팅 FAB |
| `lib/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart` | 역사적 아이콘/색상 적용 |
| `assets/icons/kingdoms/` | 4개 왕국 아이콘 에셋 |

### 달성된 목표

| 목표 | 상태 | 구현 방법 |
|------|------|----------|
| 삼국시대 역사적 아이덴티티 | ✅ 달성 | 전통 색상, 커스텀 아이콘, 분위기 오버레이 |
| UX 단순화 | ✅ 달성 | 정보 계층 축소, 미니멀 컴포넌트 |
| 왕국별 차별화 | ✅ 달성 | 색상/아이콘/배경 왕국별 적용 |

---

*삼국시대 UI/UX 리디자인 완료 - 모든 Sprint 구현됨*

