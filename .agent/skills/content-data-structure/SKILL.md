---
name: Content Data Structure
description: TimeWalker 앱의 역사 콘텐츠 데이터 구조 가이드. Region, Country, Era, Character, Location 엔티티 구조 및 데이터 관리 방법을 제공합니다.
---

# Content Data Structure Skill

TimeWalker 앱의 역사 콘텐츠 데이터 구조 및 관리 가이드입니다.

## 핵심 컨셉

- **계층 구조**: Region → Country → Era → Character/Location
- **상태 관리**: `ContentStatus`로 잠금/해금/진행/완료 상태 관리
- **이중 언어**: 영문(`name`) + 한글(`nameKorean`) 병행 지원

---

## 1. 콘텐츠 계층 구조

```
Region (지역/대륙)
├── Country (국가/문명)
│   ├── Era (시대)
│   │   ├── Character (역사 인물)
│   │   │   └── Dialogue (대화)
│   │   └── Location (장소)
│   │       └── Event (이벤트)
```

### Import 방법

```dart
import 'package:time_walker/domain/entities/entities.dart';
```

---

## 2. Region (지역/대륙)

```dart
class Region {
  final String id;           // "asia", "europe"
  final String name;         // "Asia"
  final String nameKorean;   // "아시아"
  final String description;
  final String iconAsset;
  final String thumbnailAsset;
  final List<String> countryIds;
  final MapCoordinates center;
  final double defaultZoom;
  final ContentStatus status;
  final double progress;     // 0.0 ~ 1.0
  final int unlockLevel;     // 해금에 필요한 탐험가 레벨
}
```

### MVP 지역 목록

| ID | 이름 | 해금 조건 | 포함 국가 |
|----|------|----------|----------|
| `asia` | 아시아 | 기본 해금 | korea, china, japan |
| `europe` | 유럽 | 레벨 5 | greece, rome, britain |
| `middle_east` | 중동 | 레벨 10 | mesopotamia, persia |
| `africa` | 아프리카 | 레벨 15 | egypt, ethiopia |
| `americas` | 아메리카 | 레벨 20 | maya, aztec, inca |

---

## 3. Country (국가/문명)

```dart
class Country {
  final String id;           // "korea"
  final String regionId;     // "asia"
  final String name;         // "Korea"
  final String nameKorean;   // "한반도"
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final MapCoordinates position;
  final List<String> eraIds;
  final ContentStatus status;
  final double progress;
}
```

---

## 4. Era (시대)

```dart
class Era {
  final String id;             // "three_kingdoms"
  final String countryId;      // "korea"
  final String name;           // "Three Kingdoms Period"
  final String nameKorean;     // "삼국시대"
  final String period;         // "57 BC - 668 AD"
  final int startYear;         // -57
  final int endYear;           // 668
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final String bgmAsset;
  final String themeId;
  final List<String> chapterIds;
  final List<String> characterIds;
  final List<String> locationIds;
  final ContentStatus status;
  final double progress;
  final int estimatedMinutes;
  final UnlockCondition unlockCondition;
  final MapBounds? mapBounds;
}
```

### 해금 조건

```dart
class UnlockCondition {
  final String? previousEraId;     // 이전 시대 ID
  final double requiredProgress;   // 필요 진행률 (기본: 0.3)
  final int? requiredLevel;        // 필요 탐험가 레벨
  final bool isPremium;            // 프리미엄 구매 필요
}
```

---

## 5. Character (역사 인물)

```dart
class Character {
  final String id;               // "sejong"
  final String eraId;           // "joseon"
  final String name;            // "Sejong the Great"
  final String nameKorean;      // "세종대왕"
  final String title;           // "조선 제4대 국왕"
  final String birth;           // "1397"
  final String death;           // "1450"
  final String biography;       // 짧은 소개
  final String fullBiography;   // 상세 소개
  final String portraitAsset;
  final List<String> emotionAssets;
  final List<String> dialogueIds;
  final List<String> relatedCharacterIds;
  final List<String> relatedLocationIds;
  final List<String> achievements;
  final CharacterStatus status;
  final bool isHistorical;
}
```

### 인물 상태

```dart
enum CharacterStatus {
  locked,      // 미해금
  available,   // 만날 수 있음
  inProgress,  // 대화 진행 중
  completed,   // 모든 대화 완료
}
```

---

## 6. Location (장소)

```dart
class Location {
  final String id;             // "gyeongbokgung"
  final String eraId;         // "joseon"
  final String name;          // "Gyeongbok Palace"
  final String nameKorean;    // "경복궁"
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final String? kingdom;      // 삼국시대 전용: "goguryeo"/"baekje"/"silla"/"gaya"
  final double? latitude;
  final double? longitude;
  final String? displayYear;
  final int? timelineOrder;
  final MapCoordinates position;
  final List<String> characterIds;
  final List<String> eventIds;
  final ContentStatus status;
  final bool isHistorical;
}
```

---

## 7. ContentStatus (콘텐츠 상태)

```dart
enum ContentStatus {
  locked,      // 미해금 (회색, 흐릿함)
  available,   // 탐험 가능 (빛나는 테두리)
  inProgress,  // 진행 중 (진행률 표시)
  completed,   // 완료 (황금 테두리)
}

extension ContentStatusExtension on ContentStatus {
  bool get isAccessible => this != ContentStatus.locked;
}
```

---

## 8. ID 네이밍 컨벤션

### 일반 규칙

- 소문자 + 언더스코어 (`snake_case`)
- 영문 기반, 간결하고 명확하게
- 중복 방지를 위한 prefix 사용 권장

### 엔티티별 패턴

| 엔티티 | 패턴 | 예시 |
|--------|------|------|
| Region | `{region}` | `asia`, `europe` |
| Country | `{country}` | `korea`, `china`, `japan` |
| Era | `{era_name}` | `three_kingdoms`, `joseon` |
| Character | `{name}` | `sejong`, `gwanggaeto` |
| Location | `{location_name}` | `gyeongbokgung`, `hanyang` |
| Dialogue | `{character}_{topic}_{num}` | `sejong_hangul_01` |

### 에셋 경로 패턴

```
assets/images/characters/{character_id}.png
assets/images/characters/{character_id}_{emotion}.png
assets/images/locations/{location_id}.png
assets/images/eras/{era_id}_bg.png
assets/audio/bgm/{era_id}.mp3
```

---

## 9. 관련 파일

| 경로 | 설명 |
|------|------|
| `lib/domain/entities/` | 엔티티 정의 |
| `lib/data/seeds/` | 시드 데이터 |
| `assets/data/` | JSON 데이터 파일 |
| `lib/domain/repositories/` | Repository 인터페이스 |
| `lib/data/repositories/` | Repository 구현 |

---

## 10. 새 콘텐츠 추가 체크리스트

### 시대 추가

- [ ] `eraIds` 배열에 ID 추가 (Country)
- [ ] Era 엔티티 생성
- [ ] `characterIds`, `locationIds` 정의
- [ ] `unlockCondition` 설정
- [ ] 에셋 추가 (썸네일, 배경, BGM)

### 인물 추가

- [ ] `characterIds`에 ID 추가 (Era)
- [ ] Character 엔티티 생성
- [ ] `dialogueIds` 연결
- [ ] 초상화 에셋 추가

### 장소 추가

- [ ] `locationIds`에 ID 추가 (Era)
- [ ] Location 엔티티 생성
- [ ] `characterIds` 연결 (장소에서 만날 인물)
- [ ] 배경 에셋 추가

---

## 11. 베스트 프랙티스

### ✅ DO

```dart
// 1. 이중 언어 필드 모두 채우기
Era(
  name: "Three Kingdoms Period",
  nameKorean: "삼국시대",
)

// 2. 명확한 해금 조건 설정
UnlockCondition(
  previousEraId: "three_kingdoms",
  requiredProgress: 0.5,
)

// 3. 연관 ID 일관성 유지
Character(
  eraId: "joseon",
  relatedLocationIds: ["gyeongbokgung", "changdeokgung"],
)
```

### ❌ DON'T

```dart
// 1. ID 불일치
Character(eraId: "joseon")  // 존재하지 않는 Era ❌

// 2. 빈 필수 필드
Character(nameKorean: "")  // 빈 문자열 ❌

// 3. 잘못된 에셋 경로
Character(portraitAsset: "sejong.png")  // 전체 경로 필요 ❌
// 올바른 예: "assets/images/characters/sejong.png"
```
