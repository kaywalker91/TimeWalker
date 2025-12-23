# 가야 시나리오 추가 계획

## 📋 개요

**프로젝트**: Time Walker - 가야 콘텐츠 확장  
**목표**: 삼국시대 내 가야의 역사적 인물, 장소, 대화 시나리오를 추가하여 게임 콘텐츠를 풍부하게 확장  
**시대 ID**: `korea_three_kingdoms` (기존 삼국시대 Era에 통합)  
**기존 연관 콘텐츠**: 김유신 (가야 왕족 후손)

---

## 🎯 1단계: 핵심 인물 추가

### 1.1 주요 인물 목록

| 인물명 | ID | 시기 | 역할 | 우선순위 |
|--------|-----|------|------|----------|
| **김수로왕** | `suro` | 42-199 | 금관가야 건국 시조, 허황옥과의 사랑 | ⭐⭐⭐ (최우선) |
| **허황옥** | `hwangok` | 32-189 | 아유타국 공주, 수로왕의 왕비 | ⭐⭐⭐ (최우선) |
| **이진아시왕** | `ijinasi` | ?-? | 대가야 건국 시조, 정견모주 아들 | ⭐⭐ |
| **도설지왕** | `doseolji` | ?~532 | 금관가야 마지막 왕, 신라에 항복 | ⭐⭐ |
| **우륵** | `ureuk` | 6세기 | 가야금 창시자, 대가야 악사 | ⭐⭐⭐ (최우선) |
| **이뇌왕** | `ino` | ?~562 | 대가야 마지막 왕 | ⭐ |
| **거칠부** | `geochilbu` | 502-579 | 가야 토벌한 신라 장군 | ⭐ |

### 1.2 김유신과의 연계

- **김수로왕**: 김유신의 12대조 (가야 왕족 혈통)
- **가야-신라 관계**: 가야 멸망 후 김유신 가문이 신라에 귀화

### 1.3 캐릭터 데이터 스키마 (characters.json)

```json
{
  "id": "suro",
  "eraId": "korea_three_kingdoms",
  "name": "King Suro",
  "nameKorean": "김수로왕",
  "title": "금관가야 건국 시조",
  "birth": "42",
  "death": "199",
  "biography": "하늘에서 내려온 황금알에서 태어나 금관가야를 건국한 전설의 시조왕",
  "fullBiography": "서기 42년 구지봉에서 하늘로부터 내려온 황금알에서 태어났다고 전해진다. 6가야 연맹의 맹주 금관가야를 건국하고, 인도 아유타국에서 온 허황옥 공주와 혼인하여 10남 2녀를 두었다. 가락국기에 따르면 158년간 재위하다 199년에 승하하였다.",
  "portraitAsset": "assets/images/characters/suro.png",
  "emotionAssets": [
    "assets/images/characters/suro_neutral.png",
    "assets/images/characters/suro_pleased.png",
    "assets/images/characters/suro_thoughtful.png"
  ],
  "dialogueIds": [
    "suro_founding_01",
    "suro_hwangok_01"
  ],
  "relatedCharacterIds": ["hwangok", "kim_yushin"],
  "relatedLocationIds": ["gujibong", "gimhae_palace"],
  "achievements": [
    "금관가야 건국",
    "6가야 연맹 맹주",
    "가야 왕통 확립",
    "허황옥과의 국제 혼인"
  ],
  "status": "available"
}
```

```json
{
  "id": "hwangok",
  "eraId": "korea_three_kingdoms",
  "name": "Queen Heo Hwang-ok",
  "nameKorean": "허황옥",
  "title": "금관가야 초대 왕비",
  "birth": "32",
  "death": "189",
  "biography": "인도 아유타국에서 바다를 건너 수로왕의 왕비가 된 전설의 공주",
  "fullBiography": "인도 아유타국의 공주로, 꿈에서 부모가 가락국으로 가라는 계시를 받고 바다를 건너왔다. 파사석탑을 싣고 온 배로 김해에 도착해 수로왕의 왕비가 되었다. 허씨, 김해 김씨, 인천 이씨 등의 시조모로 추앙받는다.",
  "portraitAsset": "assets/images/characters/hwangok.png",
  "emotionAssets": [
    "assets/images/characters/hwangok_neutral.png",
    "assets/images/characters/hwangok_graceful.png"
  ],
  "dialogueIds": [
    "hwangok_arrival_01"
  ],
  "relatedCharacterIds": ["suro"],
  "relatedLocationIds": ["gimhae_palace", "mangsan_island"],
  "achievements": [
    "해상 실크로드 개척",
    "불교 전래 (추정)",
    "파사석탑 전래",
    "왕실 혈통 확립"
  ],
  "status": "available"
}
```

```json
{
  "id": "ureuk",
  "eraId": "korea_three_kingdoms",
  "name": "Ureuk",
  "nameKorean": "우륵",
  "title": "가야금의 창시자",
  "birth": "?",
  "death": "?",
  "biography": "가야금을 창시하고 12곡을 작곡한 대가야의 전설적인 악사",
  "fullBiography": "대가야의 악사로, 가실왕의 명을 받아 가야금을 만들고 12곡을 작곡하였다. 대가야가 멸망할 기미가 보이자 신라로 망명하여 진흥왕의 후원 아래 제자들에게 가야금을 전수하였다. 그의 음악은 신라의 음악으로 계승되어 오늘날까지 전해진다.",
  "portraitAsset": "assets/images/characters/ureuk.png",
  "emotionAssets": [
    "assets/images/characters/ureuk_neutral.png",
    "assets/images/characters/ureuk_playing.png"
  ],
  "dialogueIds": [
    "ureuk_gayageum_01",
    "ureuk_exile_01"
  ],
  "relatedCharacterIds": ["jinheung"],
  "relatedLocationIds": ["daegaya_palace", "goryeong"],
  "achievements": [
    "가야금 창시",
    "12곡 작곡",
    "신라 음악 발전",
    "제자 양성"
  ],
  "status": "available"
}
```

---

## 🗺️ 2단계: 장소 추가

### 2.1 주요 장소 목록

| 장소명 | ID | 설명 | 관련 인물 |
|--------|-----|------|-----------|
| **구지봉** | `gujibong` | 수로왕 탄강 전설의 땅 | 김수로왕 |
| **김해왕궁** | `gimhae_palace` | 금관가야 중심지 | 김수로왕, 허황옥 |
| **대가야왕궁(고령)** | `goryeong_palace` | 대가야의 수도 | 우륵, 이뇌왕 |
| **망산도** | `mangsan_island` | 허황옥이 도착한 곳 | 허황옥 |
| **수릉원(왕릉)** | `sureungwon` | 수로왕릉 | 김수로왕 |
| **칠산** | `chilsan` | 철광 산지, 가야 철기 문화 중심 | - |

### 2.2 장소 데이터 스키마 (locations.json)

```json
{
  "id": "gujibong",
  "eraId": "korea_three_kingdoms",
  "name": "Guji Peak",
  "nameKorean": "구지봉",
  "description": "하늘에서 황금알이 내려와 수로왕이 탄생했다는 전설의 성지",
  "thumbnailAsset": "assets/images/locations/gujibong_thumb.png",
  "backgroundAsset": "assets/images/locations/gujibong_bg.png",
  "position": {
    "x": 0.58,
    "y": 0.68
  },
  "characterIds": ["suro"],
  "eventIds": ["suro_birth"],
  "status": "available",
  "isHistorical": true
}
```

```json
{
  "id": "gimhae_palace",
  "eraId": "korea_three_kingdoms",
  "name": "Geumgwan Gaya Palace",
  "nameKorean": "금관가야 왕궁(김해)",
  "description": "낙동강 하류의 철기 강국 금관가야의 중심부",
  "thumbnailAsset": "assets/images/locations/gimhae_palace_thumb.png",
  "backgroundAsset": "assets/images/locations/gimhae_palace_bg.png",
  "position": {
    "x": 0.55,
    "y": 0.72
  },
  "characterIds": ["suro", "hwangok"],
  "eventIds": ["suro_hwangok_wedding", "gaya_iron_trade"],
  "status": "available",
  "isHistorical": true
}
```

```json
{
  "id": "goryeong_palace",
  "eraId": "korea_three_kingdoms",
  "name": "Daegaya Palace",
  "nameKorean": "대가야 왕궁(고령)",
  "description": "가야 연맹 후기의 맹주 대가야의 수도",
  "thumbnailAsset": "assets/images/locations/goryeong_palace_thumb.png",
  "backgroundAsset": "assets/images/locations/goryeong_palace_bg.png",
  "position": {
    "x": 0.50,
    "y": 0.62
  },
  "characterIds": ["ureuk", "ino"],
  "eventIds": ["gayageum_creation", "daegaya_fall"],
  "status": "available",
  "isHistorical": true
}
```

---

## 💬 3단계: 대화 시나리오 설계

### 3.1 김수로왕 시나리오: "하늘이 내린 왕"

**대화 ID**: `suro_founding_01`  
**예상 소요 시간**: 8분  
**보상**: 지식 포인트 180, 업적 해금

#### 역사적 배경
- 서기 42년, 구지봉에서 9간(九干)들이 노래를 부름
- 하늘에서 황금알 6개가 내려옴 (6가야 왕)
- 가장 먼저 알에서 나온 수로가 금관가야 왕이 됨
- "구지가(龜旨歌)"의 탄생

#### 스토리 흐름

```
[시작] 구지봉에서 하늘의 계시를 기다리는 9간
    │
    ├─[선택1] "구지가는 무슨 의미입니까?"
    │   └─> 신화 분기 (거북이 머리 내놓으라는 주술적 의미)
    │
    ├─[선택2] "왜 하늘에서 왕이 내려왔습니까?"
    │   └─> 건국 분기 (천손사상, 가야 연맹의 시작)
    │
    └─[선택3] "다른 알에서 나온 왕들은 누구입니까?"
        └─> 연맹 분기 (6가야 연맹 소개)
            │
            └─> [결말] 금관가야 건국
```

#### 핵심 대사 예시

```
"거북아 거북아, 머리를 내어라.
내놓지 않으면, 구워서 먹으리.

이 노래를 부르니, 하늘에서 자줏빛 줄이 내려왔다.
그 끝에는 붉은 보자기에 싸인 금합이 있었지.
열어보니... 황금빛 알 여섯 개가 햇빛처럼 빛났다.

나는 그 중 가장 먼저 알을 깨고 나왔다.
그래서 '수로(首露)'라 이름 지었지.
으뜸으로 나왔다는 뜻이다."
```

### 3.2 허황옥 시나리오: "바다를 건너온 공주"

**대화 ID**: `hwangok_arrival_01`  
**예상 소요 시간**: 7분  
**보상**: 지식 포인트 150

#### 역사적 배경
- 서기 48년, 인도 아유타국에서 배를 타고 옴
- 파사석탑을 싣고 험한 바다를 건넘
- 수로왕과 혼인하여 가야 왕비가 됨
- 한국 최초의 국제결혼 기록

#### 스토리 흐름

```
[시작] 김해 해안에 도착한 허황옥
    │
    ├─[선택1] "왜 그렇게 먼 곳에서 오셨습니까?"
    │   └─> 천명 분기 (꿈의 계시, 운명적 만남)
    │
    ├─[선택2] "파사석탑은 무엇입니까?"
    │   └─> 문화 분기 (불교적 상징, 해상 실크로드)
    │
    └─[선택3] "항해 중 어려움은 없었습니까?"
        └─> 모험 분기 (풍랑과 위험, 용왕의 노여움)
            │
            └─> [결말] 수로왕과의 만남
```

#### 핵심 대사 예시

```
"부모님께서 말씀하셨습니다.
'꿈에 상제(上帝)께서 나타나 말하시기를,
가락국의 왕은 하늘이 내린 이니
배필 또한 하늘이 정한다' 하셨습니다.

저는 붉은 돛을 단 배에 올랐습니다.
먼 바다를 건너는 동안 용왕은 노하여 파도를 일으켰지요.
그래서 이 파사석탑을 싣고 왔습니다.
탑의 힘으로 파도가 잠잠해졌습니다.

그리고... 이 땅에서 그대를 만났습니다."
```

### 3.3 우륵 시나리오: "가야금에 담긴 혼"

**대화 ID**: `ureuk_gayageum_01`  
**예상 소요 시간**: 8분  
**보상**: 지식 포인트 170, 특별 아이템(가야금 음악)

#### 역사적 배경
- 가실왕의 명으로 가야금 제작
- 중국 악기를 참고해 가야 고유의 12현금 창작
- 성열현, 하림현, 상가라도 등 12곡 작곡
- 대가야 멸망 직전 신라로 망명

#### 스토리 흐름

```
[시작] 우륵이 가야금을 연주하고 있다
    │
    ├─[선택1] "가야금은 어떻게 만들었습니까?"
    │   └─> 창작 분기 (악기 구조, 오동나무와 12현)
    │
    ├─[선택2] "12곡에는 어떤 의미가 있습니까?"
    │   └─> 음악 분기 (각 지역을 담은 곡, 가야의 영혼)
    │
    └─[선택3] "왜 신라로 가셨습니까?"
        └─> 망명 분기 (대가야 멸망 예감, 음악의 보존)
            │
            └─> [결말] 가야금의 영원한 전승
```

#### 핵심 대사 예시

```
"가실왕께서 말씀하셨습니다.
'중국의 악기는 좋으나, 그 음악은 우리 말과 맞지 않는다.
가야의 말과 마음을 담을 새 악기를 만들라.'

나는 오동나무로 몸통을 깎고,
열두 개의 현을 얹었습니다.
이 열두 곡은 가야의 열두 고을입니다.

상가라도... 하가라도... 보기...
이 곡들 속에 가야의 산과 들이 살아 숨 쉽니다.

(눈물을 닦으며)
대가야가 쓰러져도... 이 가야금만은 영원하리라."
```

### 3.4 멸망 시나리오: "사라진 연맹"

**대화 ID**: `gaya_fall_01`  
**예상 소요 시간**: 6분

#### 핵심 주제
- 법흥왕(532년 금관가야)과 진흥왕(562년 대가야)의 정복
- 가야 왕족의 신라 귀화 (김유신 가문)
- 철기 기술과 문화의 신라 흡수
- 잊혀진 역사가 된 가야

---

## 📚 4단계: 백과사전 항목 추가

### 4.1 인물 항목
- 김수로왕 (encyclo_suro)
- 허황옥 (encyclo_hwangok)
- 우륵 (encyclo_ureuk)
- 도설지왕 (encyclo_doseolji)

### 4.2 사건 항목
- 가야 건국 신화 (encyclo_gaya_founding)
- 금관가야 멸망 (encyclo_geumgwan_fall)
- 대가야 멸망 (encyclo_daegaya_fall)
- 가야-신라 통합 (encyclo_gaya_silla)

### 4.3 유물/유적 항목
- 가야금 (encyclo_gayageum)
- 수로왕릉 (encyclo_suro_tomb)
- 파사석탑 (encyclo_pasa_pagoda)
- 가야 철기 (encyclo_gaya_iron)
- 지산동 고분군 (encyclo_jisandong)

### 4.4 개념/문화 항목
- 6가야 연맹 (encyclo_6gaya)
- 구지가 (encyclo_gujiga)
- 가야 철기 문화 (encyclo_gaya_iron_culture)
- 김해 허씨/김씨 성씨의 기원 (encyclo_gaya_clans)

---

## 🖼️ 5단계: 이미지 에셋 목록

### 5.1 캐릭터 초상화
- [ ] `suro.png` - 위엄 있는 건국왕, 황금빛 왕관
- [ ] `suro_neutral.png` - 평온한 표정
- [ ] `suro_pleased.png` - 흐뭇한 표정
- [ ] `hwangok.png` - 이국적인 아름다움, 인도풍 장신구
- [ ] `hwangok_graceful.png` - 우아한 미소
- [ ] `ureuk.png` - 가야금을 안은 악사
- [ ] `ureuk_playing.png` - 연주 중인 모습

### 5.2 장소 배경
- [ ] `gujibong_thumb.png` - 신비로운 구지봉 썸네일
- [ ] `gujibong_bg.png` - 하늘에서 빛이 내리는 구지봉
- [ ] `gimhae_palace_thumb.png` - 금관가야 왕궁 썸네일
- [ ] `gimhae_palace_bg.png` - 왕궁 배경
- [ ] `goryeong_palace_thumb.png` - 대가야 왕궁 썸네일

---

## 📅 구현 일정 (예상)

| 단계 | 작업 내용 | 예상 소요 시간 |
|------|-----------|---------------|
| 1단계 | 수로왕, 허황옥, 우륵 캐릭터 데이터 추가 | 1.5시간 |
| 2단계 | 구지봉, 김해왕궁, 대가야왕궁 장소 데이터 추가 | 45분 |
| 3단계 | 수로왕 대화 시나리오 작성 | 2시간 |
| 4단계 | 허황옥 대화 시나리오 작성 | 1.5시간 |
| 5단계 | 우륵 대화 시나리오 작성 | 2시간 |
| 6단계 | 백과사전 항목 추가 | 1.5시간 |
| 7단계 | 이미지 에셋 생성 | 1.5시간 |
| 8단계 | 테스트 및 디버깅 | 1시간 |
| **총합** | | **약 11.75시간** |

---

## 🔗 기존 콘텐츠와의 연계

### 김수로왕 ↔ 김유신
- 김수로왕: 금관가야 건국 (1세기)
- 김유신: 수로왕의 12대손 (7세기)
- 가야 왕족의 신라 귀화와 삼국통일

### 가야 ↔ 신라
- 법흥왕: 금관가야 병합 (532년)
- 진흥왕: 대가야 병합 (562년)
- 가야 철기 기술 → 신라 군사력 강화

### 가야 ↔ 백제/고구려
- 고구려 광개토대왕: 가야 지역 침공 (400년경)
- 백제: 가야와 왜의 중계 무역 경쟁
- 가야, 백제, 왜 vs 신라, 고구려 갈등 구도

### 허황옥 ↔ 해상 실크로드
- 인도-가야 해상 교류 증거
- 불교 전래설 (가락국기)
- 동서양 문화 교류의 접점

---

## 🎭 감정적 톤

가야 시나리오는 **신비로움과 아쉬움**을 강조해야 합니다:

1. **김수로왕**: 신화적 경이로움, 황금빛 기원
2. **허황옥**: 낭만과 운명, 국제적 사랑 이야기
3. **우륵**: 예술혼과 비애, 잊히지 않는 음악
4. **멸망**: 아쉬움과 동화, 신라에 녹아든 유산

특히 가야는 삼국(고구려, 백제, 신라)에 비해 덜 알려진 역사이므로,
**"잊혀진 왕국의 재발견"**이라는 테마로 플레이어의 호기심을 자극해야 합니다.

---

## ✅ 체크리스트

### 데이터 파일
- [x] `characters.json` - 김수로왕, 허황옥, 우륵 추가 ✅
- [x] `locations.json` - 구지봉, 김해왕궁, 대가야왕궁 추가 ✅
- [x] `dialogues.json` - 대화 시나리오 추가 ✅
- [x] `encyclopedia.json` - 백과사전 항목 추가 ✅

### 코드 변경
- [ ] `UserProgress` 기본값에 가야 인물 ID 추가 (테스트용)
- [ ] 지도 UI에 가야 지역 마커 위치 조정 (낙동강 하류 지역)
- [ ] 김유신 캐릭터에 가야 왕족 연계 정보 추가

### 에셋
- [x] 캐릭터 초상화 이미지 생성 ✅
- [x] 장소 썸네일/배경 이미지 생성 ✅

---

## 📝 참고 자료

1. **삼국유사** - 가락국기 (김수로왕, 허황옥 기록)
2. **삼국사기** - 가야 관련 기록 (신라본기, 열전)
3. **가락국지** - 가야 왕계 및 역사
4. **김해 수로왕릉** - 현장 유물 정보
5. **국립김해박물관** - 가야 문화재 자료

---

## 🌟 가야의 특별한 콘텐츠 요소

### 이스터에그
- 김유신 대화에서 "나는 원래 가야의 왕족..." 언급
- 가야금 BGM을 우륵 시나리오에서 재생

### 특별 보상
- 가야금 악기 아이템 (우륵 시나리오 완료 시)
- "철의 왕국" 칭호 (가야 시나리오 전체 완료 시)

### 연결 콘텐츠
- 신라 시나리오와의 교차점 (김유신 가문)
- 일본 고대사와의 연결 (가야-왜 교류)

---

*작성일: 2024-12-19*  
*버전: 1.0*
