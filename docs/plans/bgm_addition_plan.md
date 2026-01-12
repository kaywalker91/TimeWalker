# TimeWalker 배경음악(BGM) 추가 계획서

**작성일**: 2026년 1월 1일  
**버전**: v1.0  
**작성자**: 모바일 게임 사운드 전문가 (AI)  
**상태**: 📋 계획 수립 완료  
**점검 횟수**: 3회 완료 ✅

---

## 📌 Executive Summary

TimeWalker 프로젝트의 새로운 "타임 포탈" UI와 5개 문명 시스템에 맞는 배경음악 추가 계획입니다. 
현재 11개 BGM이 구현되어 있으며, 핵심 화면 및 문명별 BGM 7개를 추가하여 총 18개 BGM 시스템으로 확장합니다.

---

## 🎵 현황 분석

### 현재 구현된 BGM (11개)

| 파일명 | 용도 | 크기 | 상태 |
|--------|------|------|------|
| main_menu.mp3 | 메인 메뉴 화면 | 198KB | ✅ 완료 |
| world_map.mp3 | 월드맵 화면 | 206KB | ✅ 완료 |
| dialogue.mp3 | 대화 화면 | 184KB | ✅ 완료 |
| quiz.mp3 | 퀴즈 화면 | 142KB | ✅ 완료 |
| encyclopedia.mp3 | 백과사전 | 211KB | ✅ 완료 |
| victory.mp3 | 승리 팡파레 | 76KB | ✅ 완료 |
| era_joseon.mp3 | 조선 시대 | 204KB | ✅ 완료 |
| era_three_kingdoms.mp3 | 삼국 시대 | 208KB | ✅ 완료 |
| era_goryeo.mp3 | 고려 시대 | 195KB | ✅ 완료 |
| era_gaya.mp3 | 가야 시대 | 194KB | ✅ 완료 |
| era_renaissance.mp3 | 유럽 르네상스 | 214KB | ✅ 완료 |

### 현재 구현된 SFX (8개)

| 파일명 | 용도 | 크기 |
|--------|------|------|
| button_click.mp3 | 버튼 클릭 | 2.8KB |
| coin_collect.mp3 | 코인 획득 | 3.5KB |
| dialogue_advance.mp3 | 대화 진행 | 2.2KB |
| discovery.mp3 | 발견 | 6.5KB |
| level_up.mp3 | 레벨업 | 8.9KB |
| quiz_correct.mp3 | 퀴즈 정답 | 4.9KB |
| quiz_wrong.mp3 | 퀴즈 오답 | 4.0KB |
| unlock.mp3 | 잠금 해제 | 8.4KB |

### Gap 분석

| 화면/기능 | 현재 상태 | 필요성 |
|-----------|----------|--------|
| 타임 포탈 | ❌ 부재 | 🔴 필수 (새 핵심 UI) |
| 문명별 BGM (5개) | ❌ 부재 | 🔴 필수 (문명 시스템) |
| 위치 탐험 | ❌ 부재 | 🟠 권장 |
| 상점/인벤토리 | ❌ 부재 | 🟢 선택 |
| 포탈 효과음 | ❌ 부재 | 🟠 권장 |

---

## 🎯 추가 계획

### Phase 1: 필수 BGM (P0) - 즉시 실행

#### 1.1 타임 포탈 BGM
| 항목 | 내용 |
|------|------|
| **파일명** | `time_portal.mp3` |
| **용도** | 타임 포탈 화면 (문명 선택 허브) |
| **분위기** | 우주적, 신비로운, 시공간 왜곡 |
| **BPM** | 60-70 (느리고 장엄하게) |
| **키** | Am 또는 Dm (마이너) |
| **주요 악기** | 신스 패드, 스트링 앙상블, 피아노 아르페지오 |
| **참고 스타일** | Interstellar OST, Mass Effect Normandy |
| **길이** | 2-3분 (심리스 루프) |
| **예상 크기** | 200-250KB |

#### 1.2 문명별 BGM (5개)

| 문명 | 파일명 | BPM | 주요 악기 | 분위기 |
|------|--------|-----|----------|--------|
| **아시아** | `civ_asia.mp3` | 75-85 | 가야금, 대금, 피리, 타악 | 동양적 신비, 펜타토닉 스케일 |
| **유럽** | `civ_europe.mp3` | 80-100 | 하프시코드, 현악4중주, 플룻 | 바로크/고전, 우아함 |
| **아메리카** | `civ_americas.mp3` | 85-95 | 팬플룻, 차란고, 봉고, 오카리나 | 안데스 민속, 자연적 |
| **중동** | `civ_middle_east.mp3` | 90-110 | 우드, 카눈, 다라부카, 네이 | 아라비안, 이국적 |
| **아프리카** | `civ_africa.mp3` | 100-120 | 젬베, 칼림바, 코라, 발라폰 | 리듬미컬, 생동감 |

### Phase 2: 권장 BGM/SFX (P1) - 1주 내

#### 2.1 위치 탐험 BGM
| 항목 | 내용 |
|------|------|
| **파일명** | `location_exploration.mp3` |
| **용도** | 특정 장소 탐험 화면 |
| **분위기** | 탐험, 발견, 호기심 |
| **BPM** | 85-100 |
| **길이** | 3-4분 루프 |

#### 2.2 추가 SFX (4개)

| 파일명 | 용도 | 예상 길이 |
|--------|------|----------|
| `portal_enter.mp3` | 포탈 진입 효과 (워프) | 2-3초 |
| `portal_ambient.mp3` | 포탈 배경 앰비언스 | 10초 루프 |
| `civilization_select.mp3` | 문명 선택 시 효과 | 1-2초 |
| `map_marker_tap.mp3` | 지도 마커 탭 | 0.5초 |

### Phase 3: 선택적 BGM (P2) - 2주 내

| 파일명 | 용도 | 우선순위 |
|--------|------|----------|
| `shop.mp3` | 상점 화면 | 🟢 낮음 |
| `inventory.mp3` | 인벤토리/프로필 | 🟢 낮음 |
| `event_dramatic.mp3` | 중요 이벤트 | 🟢 낮음 |
| `achievement_fanfare.mp3` | 업적 달성 (5-10초) | 🟢 낮음 |

---

## 🔧 기술 구현 계획

### 1. AudioConstants 업데이트

**파일**: `lib/core/constants/audio_constants.dart`

```dart
// ============== 신규 BGM ==============

// 타임 포탈 BGM
static const String bgmTimePortal = 'time_portal.mp3';

// 위치 탐험 BGM
static const String bgmLocationExploration = 'location_exploration.mp3';

// 문명별 BGM
static const String bgmCivAsia = 'civ_asia.mp3';
static const String bgmCivEurope = 'civ_europe.mp3';
static const String bgmCivAmericas = 'civ_americas.mp3';
static const String bgmCivMiddleEast = 'civ_middle_east.mp3';
static const String bgmCivAfrica = 'civ_africa.mp3';

// 문명 ID → BGM 매핑
static const Map<String, String> civilizationBGM = {
  'asia': bgmCivAsia,
  'europe': bgmCivEurope,
  'americas': bgmCivAmericas,
  'middle_east': bgmCivMiddleEast,
  'africa': bgmCivAfrica,
};

/// 문명 ID에 맞는 BGM 파일명 반환
static String getBGMForCivilization(String civId) {
  return civilizationBGM[civId] ?? bgmTimePortal;
}

// ============== 신규 SFX ==============
static const String sfxPortalEnter = 'portal_enter.mp3';
static const String sfxPortalAmbient = 'portal_ambient.mp3';
static const String sfxCivilizationSelect = 'civilization_select.mp3';
static const String sfxMapMarkerTap = 'map_marker_tap.mp3';
```

### 2. ScreenBgmConfig 업데이트

**파일**: `lib/core/utils/screen_bgm_config.dart`

```dart
// getBgmForRoute 메서드에 추가
case '/time-portal':
  return AudioConstants.bgmTimePortal;
case '/location-exploration':
  return AudioConstants.bgmLocationExploration;

// 동적 라우트 패턴 매칭 추가
if (routePath.contains('/civilization/')) {
  final civIdMatch = RegExp(r'/civilization/([^/]+)').firstMatch(routePath);
  if (civIdMatch != null) {
    final civId = civIdMatch.group(1)!;
    return AudioConstants.getBGMForCivilization(civId);
  }
}
```

### 3. BgmController 확장

**파일**: `lib/presentation/providers/audio_provider.dart`

```dart
/// 타임 포탈 BGM 재생
Future<void> playTimePortalBgm() async {
  await _playBgm(AudioConstants.bgmTimePortal);
}

/// 문명별 BGM 재생
Future<void> playCivilizationBgm(String civId) async {
  final trackName = AudioConstants.getBGMForCivilization(civId);
  await _playBgm(trackName);
}

/// 위치 탐험 BGM 재생
Future<void> playLocationExplorationBgm() async {
  await _playBgm(AudioConstants.bgmLocationExploration);
}
```

### 4. BgmMixin 업데이트

**파일**: `lib/core/utils/bgm_mixin.dart`

```dart
// _playBgm 메서드 switch 문에 추가
case AudioConstants.bgmTimePortal:
  controller.playTimePortalBgm();
  break;
case AudioConstants.bgmLocationExploration:
  controller.playLocationExplorationBgm();
  break;
// 문명별 BGM은 playCivilizationBgm(civId)로 별도 처리
```

---

## 📂 폴더 구조

```
assets/audio/
├── bgm/
│   ├── main_menu.mp3          # 기존
│   ├── world_map.mp3          # 기존
│   ├── dialogue.mp3           # 기존
│   ├── quiz.mp3               # 기존
│   ├── encyclopedia.mp3       # 기존
│   ├── victory.mp3            # 기존
│   ├── era_joseon.mp3         # 기존
│   ├── era_three_kingdoms.mp3 # 기존
│   ├── era_goryeo.mp3         # 기존
│   ├── era_gaya.mp3           # 기존
│   ├── era_renaissance.mp3    # 기존
│   ├── time_portal.mp3        # 🆕 신규
│   ├── location_exploration.mp3 # 🆕 신규
│   ├── civ_asia.mp3           # 🆕 신규
│   ├── civ_europe.mp3         # 🆕 신규
│   ├── civ_americas.mp3       # 🆕 신규
│   ├── civ_middle_east.mp3    # 🆕 신규
│   └── civ_africa.mp3         # 🆕 신규
│
└── sfx/
    ├── button_click.mp3       # 기존
    ├── coin_collect.mp3       # 기존
    ├── dialogue_advance.mp3   # 기존
    ├── discovery.mp3          # 기존
    ├── level_up.mp3           # 기존
    ├── quiz_correct.mp3       # 기존
    ├── quiz_wrong.mp3         # 기존
    ├── unlock.mp3             # 기존
    ├── portal_enter.mp3       # 🆕 신규
    ├── portal_ambient.mp3     # 🆕 신규
    ├── civilization_select.mp3 # 🆕 신규
    └── map_marker_tap.mp3     # 🆕 신규
```

---

## 🎼 음악 제작 가이드라인

### 전체 톤

- **스타일**: 영화 OST 스타일, 교육적이면서도 몰입감
- **품질**: 44.1kHz, 192kbps MP3 (모바일 최적화)
- **루프**: 심리스 루프, 시작/끝 3-5초 페이드

### 기술 사양

| 항목 | 권장 값 |
|------|---------|
| 샘플레이트 | 44.1kHz |
| 비트레이트 | 128-192kbps |
| 채널 | 스테레오 |
| 파일 크기 | 100-300KB/분 |
| 루프 지점 | 명확한 심리스 루프 |These are comments 

### 제작 옵션

1. **AI 음악 생성** (권장 ⭐)
   - Suno AI, AIVA, Soundraw
   - 빠른 생성, 커스터마이징 가능
   - 상용 라이선스 확인 필요

2. **로열티 프리 라이브러리**
   - Epidemic Sound, Artlist, AudioJungle
   - 즉시 사용 가능, 고품질
   - 월정액 또는 건당 비용

3. **커스텀 작곡**
   - 완벽한 맞춤형
   - 높은 비용과 시간 소요

---

## 📅 실행 일정

| 단계 | 내용 | 기간 | 산출물 |
|------|------|------|--------|
| **Week 1** | P0 BGM 6개 확보 + 코드 구현 | 5일 | time_portal + 문명별 BGM |
| **Week 2** | P1 BGM/SFX 확보 + 테스트 | 3일 | location_exploration + SFX |
| **Week 3** | P2 선택적 BGM + 최종 테스트 | 2일 | shop, inventory 등 |

---

## ✅ 테스트 체크리스트

### 기능 테스트
- [ ] 타임 포탈 화면 진입 시 time_portal.mp3 재생
- [ ] 각 문명 선택 시 해당 문명 BGM으로 전환
- [ ] 화면 전환 시 크로스페이드 정상 작동
- [ ] 음량 설정(Settings) 반영 확인
- [ ] BGM 뮤트/언뮤트 정상 작동

### 성능 테스트
- [ ] 앱 시작 시 오디오 로딩 지연 < 1초
- [ ] BGM 전환 시 끊김 없음
- [ ] 메모리 사용량 안정적
- [ ] 백그라운드 전환 시 BGM 일시정지
- [ ] 포그라운드 복귀 시 BGM 재개

### UX 테스트
- [ ] 음악 분위기가 화면과 일치
- [ ] 루프 지점 자연스러움
- [ ] 볼륨 밸런스 적절 (BGM과 SFX)
- [ ] 문명별 BGM이 해당 문화 느낌 전달

---

## 📊 예상 효과

| 지표 | 현재 | 목표 |
|------|------|------|
| BGM 파일 수 | 11개 | 18개 (+7) |
| SFX 파일 수 | 8개 | 12개 (+4) |
| 화면 BGM 커버리지 | 70% | 95% |
| 문명별 차별화 | 없음 | 5개 문명 고유 BGM |

---

## 🔗 관련 문서

- [기존 리팩토링 계획서](/docs/refactoring_plan.md)
- [UI/UX 리팩토링 계획서](/docs/ui_ux_refactoring_plan.md)
- [개발 계획서](/docs/development_plan.md)
- [코드 리팩토링 계획서](/docs/plans/code_refactoring_plan.md)

---

## ⚠️ 주의사항

1. **저작권**: AI 생성 음악 또는 로열티 프리 라이브러리 사용 시 상용 라이선스 확인
2. **파일 크기**: 모바일 앱이므로 각 BGM 300KB 이하 권장
3. **루프 품질**: 심리스 루프 편집으로 청취 피로 방지
4. **볼륨 노멀라이징**: 모든 BGM의 볼륨 레벨 일관성 유지 (-14 LUFS 권장)

---

*마지막 업데이트: 2026년 1월 1일*
