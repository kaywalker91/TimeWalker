# 신라시대 시나리오 추가 계획

## 📋 개요

**프로젝트**: Time Walker - 신라시대 콘텐츠 확장  
**목표**: 삼국시대 내 신라의 역사적 인물, 장소, 대화 시나리오를 추가하여 게임 콘텐츠를 풍부하게 확장  
**시대 ID**: `korea_three_kingdoms` (기존 삼국시대 Era에 통합)  

---

## 🎯 1단계: 핵심 인물 추가

### 1.1 주요 인물 목록

| 인물명 | ID | 시기 | 역할 | 우선순위 |
|--------|-----|------|------|----------|
| **김유신** | `kim_yushin` | 595-673 | 삼국통일의 명장, 화랑도 출신 장군 | ⭐⭐⭐ (최우선) |
| **선덕여왕** | `seondeok` | ?-647 | 신라 최초의 여왕, 첨성대 건립 | ⭐⭐⭐ (최우선) |
| **원효대사** | `wonhyo` | 617-686 | 불교 대중화의 선구자, 사상가 | ⭐⭐ |
| **박혁거세** | `hyeokgeose` | BC 69-AD 4 | 신라 건국 시조 | ⭐⭐ |
| **진흥왕** | `jinheung` | 534-576 | 영토 확장, 화랑도 창설 | ⭐⭐ |
| **문무왕** | `munmu` | 626-681 | 삼국통일 완성, 해중릉 | ⭐⭐ |
| **설총** | `seolchong` | 655-? | 이두 창안, 원효의 아들 | ⭐ |

### 1.2 캐릭터 데이터 스키마 (characters.json)

```json
{
  "id": "kim_yushin",
  "eraId": "korea_three_kingdoms",
  "name": "General Kim Yu-shin",
  "nameKorean": "김유신",
  "title": "삼국통일의 명장",
  "birth": "595",
  "death": "673",
  "biography": "화랑도 출신으로 삼국통일을 이끈 신라의 전설적인 장군",
  "fullBiography": "가야 왕족의 후손으로 태어나 화랑도에서 수련하였다. 백제와 고구려를 차례로 멸망시키고 당나라 세력을 한반도에서 몰아내어 삼국통일의 위업을 달성하였다. 태대각간(太大角干)의 지위에 올라 왕보다 높은 예우를 받았다.",
  "portraitAsset": "assets/images/characters/kim_yushin.png",
  "emotionAssets": [
    "assets/images/characters/kim_yushin_neutral.png",
    "assets/images/characters/kim_yushin_determined.png",
    "assets/images/characters/kim_yushin_thoughtful.png"
  ],
  "dialogueIds": [
    "kim_yushin_unification_01",
    "kim_yushin_hwarang_01"
  ],
  "relatedCharacterIds": ["seondeok", "munmu"],
  "relatedLocationIds": ["gyeongju_palace", "hwangnyongsa"],
  "achievements": [
    "삼국통일 달성",
    "대야성 전투 승리",
    "황산벌 전투 승리",
    "당군 축출"
  ],
  "status": "available"
}
```

---

## 🗺️ 2단계: 장소 추가

### 2.1 주요 장소 목록

| 장소명 | ID | 설명 | 관련 인물 |
|--------|-----|------|-----------|
| **경주 월성** | `gyeongju_palace` | 신라 왕궁, 천년 왕국의 중심 | 선덕여왕, 김유신, 문무왕 |
| **황룡사** | `hwangnyongsa` | 신라 최대의 사찰, 9층 목탑 | 선덕여왕 |
| **첨성대** | `cheomseongdae` | 동양 최고(最古)의 천문대 | 선덕여왕 |
| **불국사** | `bulguksa` | 신라 불교 예술의 정수 | 원효 |
| **황산벌** | `hwangsanbeol` | 계백과의 결전지 | 김유신 |
| **대왕암** | `daewangam` | 문무왕 수중릉 | 문무왕 |

### 2.2 장소 데이터 스키마 (locations.json)

```json
{
  "id": "gyeongju_palace",
  "eraId": "korea_three_kingdoms",
  "name": "Wolseong Palace",
  "nameKorean": "월성(경주궁)",
  "description": "천년 신라의 심장부, 반월성이라고도 불리는 신라 왕궁",
  "thumbnailAsset": "assets/images/locations/gyeongju_palace_thumb.png",
  "backgroundAsset": "assets/images/locations/gyeongju_palace_bg.png",
  "position": {
    "x": 0.65,
    "y": 0.72
  },
  "characterIds": ["seondeok", "kim_yushin", "munmu"],
  "eventIds": ["seondeok_coronation", "unification_celebration"],
  "status": "available",
  "isHistorical": true
}
```

---

## 💬 3단계: 대화 시나리오 설계

### 3.1 김유신 시나리오: "삼국통일의 길"

**대화 ID**: `kim_yushin_unification_01`  
**예상 소요 시간**: 8분  
**보상**: 지식 포인트 150, 업적 해금

#### 스토리 흐름

```
[시작] 김유신이 황산벌 전투 직전, 전략을 논의
    │
    ├─[선택1] "계백 장군을 어떻게 물리칠 계획입니까?"
    │   └─> 전술 분기 (포위 작전 설명)
    │
    ├─[선택2] "화랑도의 정신이란 무엇입니까?"
    │   └─> 화랑도 분기 (세속오계, 수련 이야기)
    │
    └─[선택3] "관창 화랑이 출전합니다..."
        └─> 희생 분기 (관창의 순국, 사기 고취)
            │
            └─> [결말] 황산벌 승리, 백제 멸망
```

#### 대화 노드 예시

```json
{
  "id": "start",
  "speakerId": "kim_yushin",
  "emotion": "determined",
  "text": "결전의 날이 밝았다. 저 언덕 너머에 계백의 결사대 5천이 버티고 있지.\n우리 5만 대군도 이미 네 번이나 물러났다. 하지만 다섯 번째는 다를 것이다.\n그대의 생각은 어떠한가?",
  "choices": [
    {
      "id": "c1_tactics",
      "text": "적의 수가 적으니 포위 작전은 어떻습니까?",
      "nextNodeId": "tactics_branch",
      "reward": { "knowledgePoints": 20 }
    },
    {
      "id": "c1_hwarang",
      "text": "화랑들의 사기가 하늘을 찌릅니다!",
      "nextNodeId": "hwarang_branch",
      "reward": { "knowledgePoints": 15 }
    },
    {
      "id": "c1_gwanchang",
      "text": "관창 화랑이 선봉에 서겠다 합니다...",
      "nextNodeId": "sacrifice_branch",
      "reward": { "knowledgePoints": 25 }
    }
  ]
}
```

### 3.2 선덕여왕 시나리오: "별을 읽는 여왕"

**대화 ID**: `seondeok_cheomseongdae_01`  
**예상 소요 시간**: 6분

#### 핵심 주제
- 첨성대 건립의 의미
- 여성 군주로서의 고뇌
- 김춘추, 김유신과의 관계
- 삼국통일의 서막

---

## 📚 4단계: 백과사전 항목 추가

### 4.1 인물 항목
- 김유신 (encyclo_kim_yushin)
- 선덕여왕 (encyclo_seondeok)
- 원효대사 (encyclo_wonhyo)

### 4.2 사건/개념 항목
- 화랑도 (encyclo_hwarangdo)
- 삼국통일 (encyclo_unification)
- 세속오계 (encyclo_sesokogye)

### 4.3 유물 항목
- 첨성대 (encyclo_cheomseongdae)
- 황룡사 9층 목탑 (encyclo_hwangnyongsa_pagoda)
- 천마총 (encyclo_cheonmachong)

---

## 🖼️ 5단계: 이미지 에셋 목록

### 5.1 캐릭터 초상화
- [ ] `kim_yushin.png` - 기본 초상화
- [ ] `kim_yushin_neutral.png` - 평온 표정
- [ ] `kim_yushin_determined.png` - 결연한 표정
- [ ] `seondeok.png` - 기본 초상화
- [ ] `seondeok_thoughtful.png` - 사색하는 표정
- [ ] `wonhyo.png` - 기본 초상화

### 5.2 장소 배경
- [ ] `gyeongju_palace_thumb.png` - 월성 썸네일
- [ ] `gyeongju_palace_bg.png` - 월성 배경
- [ ] `cheomseongdae_thumb.png` - 첨성대 썸네일
- [ ] `hwangnyongsa_thumb.png` - 황룡사 썸네일

---

## 📅 구현 일정 (예상)

| 단계 | 작업 내용 | 예상 소요 시간 |
|------|-----------|---------------|
| 1단계 | 김유신, 선덕여왕 캐릭터 데이터 추가 | 1시간 |
| 2단계 | 경주 월성, 첨성대 장소 데이터 추가 | 30분 |
| 3단계 | 김유신 대화 시나리오 작성 | 2시간 |
| 4단계 | 선덕여왕 대화 시나리오 작성 | 2시간 |
| 5단계 | 백과사전 항목 추가 | 1시간 |
| 6단계 | 이미지 에셋 생성 | 1시간 |
| 7단계 | 테스트 및 디버깅 | 1시간 |
| **총합** | | **약 8.5시간** |

---

## ✅ 체크리스트

### 데이터 파일
- [ ] `characters.json` - 김유신, 선덕여왕 추가
- [ ] `locations.json` - 경주월성, 첨성대 추가
- [ ] `dialogues.json` - 대화 시나리오 추가
- [ ] `encyclopedia.json` - 백과사전 항목 추가

### 코드 변경
- [ ] `UserProgress` 기본값에 신라 인물 ID 추가 (테스트용)
- [ ] 지도 UI에 신라 지역 마커 위치 조정

### 에셋
- [ ] 캐릭터 초상화 이미지 생성
- [ ] 장소 썸네일/배경 이미지 생성

---

## 📝 참고 자료

1. **한국민족문화대백과사전** - 김유신, 선덕여왕 항목
2. **삼국사기** - 신라본기
3. **화랑세기** - 화랑도 관련 기록

---

*작성일: 2024-12-18*  
*버전: 1.0*
