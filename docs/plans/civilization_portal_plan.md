# 🌌 문명 차원문 (Civilization Portal) UI 변경 계획서

> **작성일**: 2026-01-01  
> **작성자**: AI Assistant  
> **상태**: 📋 계획 수립 완료

---

## 📌 개요

### 현재 상태
- **기존 UI**: Flame 엔진 기반 **세계 지도** (2D 지도에 지역 마커)
- **데이터**: 6개 Region (아시아, 유럽, 아프리카, 북아메리카, 남아메리카, 중동)

### 변경 목표
- **새로운 UI**: **시공간을 떠다니는 5개 문명 차원문**
- **컨셉**: "시간 여행자가 시공간 속에서 문명의 차원문을 선택하여 이동"

---

## 🏛️ 5대 문명 정의

| # | 문명 ID | 문명 이름 | 포함 국가 | 포함 시대 | 포탈 색상 | 아이콘 | 상태 |
|:-:|---------|----------|----------|----------|:--------:|:------:|:----:|
| 1 | `asia` | **아시아 문명** | 한국, 중국, 일본 | 삼국시대, 통일신라, 고려, 조선, 근대 | 🔵 청금색 | 🐉 용 | ✅ |
| 2 | `europe` | **유럽 문명** | 그리스, 로마, 영국 | 르네상스, 산업혁명 | 🟢 청록색 | 🏛️ 신전 | 🔒 |
| 3 | `americas` | **아메리카 문명** | 마야, 아즈텍, 잉카 | (추후 추가) | 🔴 태양색 | ☀️ 태양 | 🔒 |
| 4 | `middle_east` | **중동 문명** | 메소포타미아, 페르시아, 오스만 | (추후 추가) | 🟣 자주색 | 🕌 모스크 | 🔒 |
| 5 | `africa` | **아프리카 문명** | 이집트, 에티오피아, 말리 | (추후 추가) | 🟡 황금색 | 🔺 피라미드 | 🔒 |

---

## 📊 문명 → 국가 → 시대 매핑 (기존 데이터 기반)

### 1. 아시아 문명 (기본 해금) 🐉
```yaml
id: asia
name: 아시아 문명
nameEnglish: Asian Civilization
description: "동양 문명의 발상지, 5000년 역사를 품은 대륙"
portalColor: 0xFF3B82F6  # 청색
glowColor: 0xFFFFD700    # 황금
icon: dragon
countries:
  - korea (한반도) ✅ 해금
    - korea_three_kingdoms (삼국시대) ✅
    - korea_unified_silla (통일신라)
    - korea_goryeo (고려시대)
    - korea_joseon (조선시대)
    - korea_modern (근대/일제강점기)
  - china (중국) 🔒
  - japan (일본) 🔒
unlockLevel: 0
position: Offset(0.25, 0.25)  # 좌상단
```

### 2. 유럽 문명 🏛️
```yaml
id: europe
name: 유럽 문명
nameEnglish: European Civilization
description: "서양 문명의 중심, 그리스와 로마의 유산"
portalColor: 0xFF22C55E  # 청록
glowColor: 0xFF60A5FA    # 하늘색
icon: temple
countries:
  - greece (고대 그리스) 🔒
  - rome (로마 제국) 🔒
  - uk (영국)
    - europe_renaissance (르네상스)
    - europe_industrial_revolution (산업혁명)
unlockLevel: 5
position: Offset(0.75, 0.25)  # 우상단
```

### 3. 아메리카 문명 ☀️
```yaml
id: americas
name: 아메리카 문명
nameEnglish: American Civilization  
description: "마야, 아즈텍, 잉카의 신비로운 고대 문명"
portalColor: 0xFFEF4444  # 적색
glowColor: 0xFFFBBF24    # 태양색
icon: sun
countries:
  - maya (마야) 🔒
  - aztec (아즈텍) 🔒
  - inca (잉카) 🔒
unlockLevel: 10
position: Offset(0.50, 0.55)  # 중앙
```

### 4. 중동 문명 🕌
```yaml
id: middle_east
name: 중동 문명
nameEnglish: Middle Eastern Civilization
description: "문명의 교차로, 메소포타미아와 페르시아"
portalColor: 0xFF8B5CF6  # 자주색
glowColor: 0xFFC084FC    # 연보라
icon: mosque
countries:
  - mesopotamia (메소포타미아) 🔒
  - persia (페르시아) 🔒
  - ottoman (오스만) 🔒
unlockLevel: 15
position: Offset(0.20, 0.75)  # 좌하단
```

### 5. 아프리카 문명 🔺
```yaml
id: africa
name: 아프리카 문명
nameEnglish: African Civilization
description: "인류의 요람, 고대 이집트 문명의 땅"
portalColor: 0xFFF59E0B  # 황금색
glowColor: 0xFFFCD34D    # 밝은 황금
icon: pyramid
countries:
  - egypt (고대 이집트) 🔒
  - ethiopia (에티오피아) 🔒
  - mali (말리) 🔒
unlockLevel: 15
position: Offset(0.80, 0.75)  # 우하단
```

---

## 🎨 UI 디자인

### 화면 레이아웃

```
┌─────────────────────────────────────────────────────┐
│  ←        시공의 회랑 (Time Corridor)        ⚙️    │
├─────────────────────────────────────────────────────┤
│  ★  ✦        시공간 배경 (파티클)        ✦  ★     │
│                                                    │
│       [ 🐉 ]                      [ 🏛️ ]           │
│     아시아 문명                  유럽 문명         │
│       ✅ 25%                       🔒              │
│                                                    │
│                   [ ☀️ ]                           │
│                아메리카 문명                       │
│                    🔒                              │
│                                                    │
│       [ 🕌 ]                      [ 🔺 ]           │
│     중동 문명                   아프리카 문명       │
│       🔒                          🔒              │
│                                                    │
│  ┌───────────────────────────────────────────────┐ │
│  │ 🎯 현재: 아시아 > 한반도 > 삼국시대 (진행중)   │ │
│  └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### 포탈 위치 (정규화 좌표)

```dart
const civilizationPositions = {
  'asia': Offset(0.25, 0.22),        // 좌상단 - 아시아
  'europe': Offset(0.75, 0.22),      // 우상단 - 유럽  
  'americas': Offset(0.50, 0.52),    // 중앙 - 아메리카
  'middle_east': Offset(0.20, 0.78), // 좌하단 - 중동
  'africa': Offset(0.80, 0.78),      // 우하단 - 아프리카
};
```

### 포탈 상태별 디자인

| 상태 | 시각적 효과 | 상호작용 |
|------|------------|----------|
| **해금 + 탐험 중** | 밝은 글로우 + 진행률 표시 + 회전 | 탭 → 국가 선택 |
| **해금됨** | 글로우 애니메이션 + 회전 | 탭 → 국가 선택 |
| **해금 가능** | 반투명 + 물결 효과 | 탭 → 해금 확인 다이얼로그 |
| **잠금됨** | 어두운 실루엣 + 자물쇠 | 탭 → 필요 레벨 표시 |

---

## 📁 파일 구조

### 신규 생성 파일

```
lib/
├── domain/entities/
│   └── civilization.dart                    # 문명 엔티티 (Region 래퍼)
│
├── data/datasources/static/
│   └── civilization_data.dart               # 5대 문명 데이터
│
└── presentation/screens/time_portal/
    ├── time_portal_screen.dart              # 메인 화면
    └── widgets/
        ├── space_time_background.dart       # 시공간 배경 (별, 파티클)
        ├── civilization_portal.dart         # 포탈 위젯
        └── exploration_panel.dart           # 하단 상태 패널
```

### 수정 파일

| 파일 | 변경 내용 |
|------|----------|
| `app_router.dart` | `/time-portal` 라우트 추가 |
| `main_menu_screen.dart` | "세계 지도" → "시공의 회랑" |
| `region_data.dart` | 북/남 아메리카 → americas 통합 (선택) |

---

## 🔄 네비게이션 흐름

```
메인 메뉴
    │
    ▼
시공의 회랑 (TimePortalScreen)
    │ 포탈 클릭
    ▼
문명 상세 (RegionDetailScreen 재사용)
    │ 국가 선택
    ▼
시대 타임라인 (EraTimelineScreen)
    │ 시대 선택
    ▼
시대 탐험 (EraExplorationScreen)
```

---

## 📋 구현 단계

### Phase 1: 데이터 레이어 ✅ (완료)
- [x] `Civilization` 엔티티 (기존 Region 래핑)
- [x] `CivilizationData` 정적 데이터 (5개 문명)
- [x] `civilizationProvider` 추가

### Phase 2: UI 기본 구조 ✅ (완료)
- [x] `TimePortalScreen` 스캐폴드
- [x] `SpaceTimeBackground` (별, 성운, 시간파동 애니메이션)
- [x] `CivilizationPortal` 기본 디자인

### Phase 3: 포탈 위젯 완성 ✅ (완료)
- [x] 5개 포탈 배치
- [x] 해금/잠금 상태 분기
- [x] 탭 → RegionDetailScreen 연결

### Phase 4: 애니메이션 ✅ (완료)
- [x] 포탈 천천히 회전 (AnimationController)
- [x] PulseGlow 효과
- [x] 탭 스케일 애니메이션

### Phase 5: 라우터 및 메뉴 ✅ (완료)
- [x] `app_router.dart` 업데이트 (`/time-portal` 추가)
- [x] 메인 메뉴 버튼 아이콘 변경
- [x] 기존 `/world-map` → `/time-portal` 리다이렉트

### Phase 6: 테스트 ✅ (완료)
- [x] 정적 분석 통과
- [x] 모든 오류/경고 해결

**✅ 전체 구현 완료! (2026-01-01)**

---

## ✅ 체크리스트

### 데이터
- [x] 아시아: 한국(5시대), 중국, 일본
- [x] 유럽: 그리스, 로마, 영국(2시대)
- [x] 아메리카: 마야, 아즈텍, 잉카 (시대 미구현)
- [x] 중동: 메소포타미아, 페르시아, 오스만 (시대 미구현)
- [x] 아프리카: 이집트, 에티오피아, 말리 (시대 미구현)

### 기술
- [x] 엔진: Flutter 위젯 (Flame 불필요)
- [x] 기존 Region 데이터: 유지 (Civilization이 래핑)
- [x] UserProgress: 그대로 활용

---

## 🎯 핵심 변경 요약

| 항목 | 현재 | 변경 후 |
|------|------|---------|
| **화면 이름** | 세계 지도 | 시공의 회랑 |
| **배경** | 2D 세계 지도 | 시공간 (별, 파티클) |
| **선택 요소** | 지역 마커 6개 | 문명 포탈 5개 |
| **분류** | 지리 중심 (Region) | 문명 중심 (Asia, Europe...) |
| **컨셉** | 지도 탐험 | 시간 여행 |

---

## ⚠️ 주의사항

1. **북/남 아메리카 통합**: 기존 `north_america` + `south_america` → `americas`로 통합
2. **Region 데이터 유지**: 기존 Region ID는 그대로 사용하여 하위 호환성 유지
3. **UserProgress**: 지역별 진행도 데이터 구조 변경 없음

---

**다음 단계**: 사용자 승인 후 Phase 1부터 구현 시작
