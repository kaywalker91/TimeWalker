# 삼국시대 고구려 컨텐츠 추가 계획

## 1. 개요
현재 'Time Walker' 프로젝트에는 광개토대왕, 장수왕, 을지문덕 등 고구려의 주요 인물과 도읍지들이 포함되어 있습니다. 이를 더욱 풍성하게 만들기 위해 고구려 후기의 대당 전쟁 영웅들과 고유한 문화를 보여주는 컨텐츠를 추가하고자 합니다.

## 2. 신규 추가 제안 내역

### 2.1. 신규 장소 (Location)
*   **안시성 (Ansi Fortress)**
    *   **설명**: 당나라 태종의 대군을 막아낸 고구려의 철옹성. 양만춘 장군이 지휘한 안시성 전투의 현장.
    *   **위치**: 요동 반도 인근 (현재의 하이청시 추정)
    *   **관련 인물**: 양만춘, 연개소문, 당 태종(NPC)
    *   **관련 사건**: 안시성 전투

### 2.2. 신규 인물 (Character)
*   **연개소문 (Yeon Gaesomun)**
    *   **칭호**: 대막리지
    *   **설명**: 고구려 말기의 강력한 집권자. 당나라에 강경하게 맞서 대당 전쟁을 승리로 이끌었으나, 독재로 인한 내부 분열의 씨앗이 되기도 함.
    *   **기질**: 카리스마, 강경파
*   **양만춘 (Yang Manchun)**
    *   **칭호**: 안시성주
    *   **설명**: 안시성 전투의 영웅. 당 태종의 눈을 화살로 맞췄다는 전설이 전해짐. 연개소문과 대립했으나 국난 앞에서는 협력함.
    *   **기질**: 용맹, 지략
*   **평강공주 & 온달 (Princess Pyeonggang & On Dal)** (선택 사항)
    *   **설명**: '바보 온달과 평강공주' 설화의 주인공. 신분 차이를 넘어선 사랑과 온달의 장군 성장기.
    *   **역할**: 스토리텔링 및 퀘스트 제공 (초보자 성장 가이드 역할 가능)

### 2.3. 신규 백과사전 (Encyclopedia)
*   **사건: 안시성 전투 (Battle of Ansi Fortress)**
    *   645년, 고구려 안시성에서 당나라 대군을 격퇴한 전투. 토산을 쌓아 공격하는 당군에 맞서 토산을 점령하는 등 기적적인 방어전을 펼침.
*   **유물/문화: 고구려 고분 벽화 (Goguryeo Tomb Murals)**
    *   무용총, 각저총 등 삶과 사후 세계관을 담은 생생한 벽화. 고구려인의 기상과 생활상을 보여줌.
*   **유물: 금동연가7년명여래입상 (Gold-bronze Standing Buddha)**
    *   고구려의 불교 문화를 보여주는 대표적인 불상.

### 2.4. 신규 퀴즈 (Quiz)
*   안시성 전투의 지휘관은 누구인가? (양만춘)
*   고구려의 최고 관직이자 연개소문이 올랐던 자리는? (대막리지)
*   고구려 고분 벽화에서 춤추는 모습이 그려진 무덤은? (무용총)

## 3. 데이터 구조 업데이트 예시

### locations.json 추가
```json
{
    "id": "ansi_fortress",
    "eraId": "korea_three_kingdoms",
    "name": "Ansi Fortress",
    "nameKorean": "안시성",
    "description": "당나라 태종의 대군을 막아낸 고구려의 철옹성",
    "kingdom": "goguryeo",
    "characterIds": ["yang_manchun", "yeon_gaesomun"],
    "eventIds": ["battle_of_ansi"]
    ...
}
```

### characters.json 추가
```json
{
    "id": "yeon_gaesomun",
    "nameKorean": "연개소문",
    "title": "대막리지",
    ...
}
```

## 4. 실행 계획
1.  **JSON 데이터 작성**: `assets/data` 내의 `locations.json`, `characters.json`, `encyclopedia.json`, `quizzes.json` 파일에 위 내용을 바탕으로 데이터 추가.
2.  **이미지 에셋 준비**: 각 항목에 필요한 썸네일 및 배경 이미지 확보 (또는 placeholder 설정).
3.  **검증**: 앱 실행 후 도감 및 지도에서 정상적으로 표시되는지 확인.

이 계획을 바탕으로 작업을 진행하시겠습니까?

## 5. 이미지 생성 계획 (AI Generation Plan)

각 인물과 장소의 역사적 고증과 게임의 아트 스타일(2D 일러스트, 반실사/카툰풍)에 맞춘 생성 프롬프트 및 가이드입니다.

### 5.1. 인물 이미지 (Characters)

#### 연개소문 (Yeon Gaesomun)
*   **파일명**: `yeon_gaesomun.png`, `yeon_gaesomun_neutral.png`
*   **외형 특징**:
    *   강인하고 위압적인 50대 남성 장군.
    *   짙은 눈썹, 날카로운 눈매, 풍성한 수염(관우와 유사한 느낌의 긴 수염).
    *   **복장**: 화려하고 위엄 있는 고구려 장군 갑옷 (철갑, 붉은색 망토).
    *   **아이템**: 다섯 자루의 검(비도)을 차고 있는 모습 (설화적 특징 반영).
*   **프롬프트 키워드**: `Goguryeo general`, `powerful leader`, `long beard`, `five swords on back`, `heavy iron armor`, `red cape`, `charismatic gaze`, `historical korean warrior`, `illustration style`.

#### 양만춘 (Yang Manchun)
*   **파일명**: `yang_manchun.png`, `yang_manchun_determined.png`
*   **외형 특징**:
    *   침착하고 지략이 뛰어난 40대 남성 지휘관.
    *   신중한 눈빛, 단단한 체격.
    *   **복장**: 실전적인 고구려 갑옷, 투구 착용.
    *   **아이템**: 강력한 활 (안시성 전투의 상징).
*   **프롬프트 키워드**: `Goguryeo commander`, `holding a bow`, `defending fortress`, `determined face`, `battle worn armor`, `historical korean general`, `archery master`, `illustration style`.

### 5.2. 장소 이미지 (Locations)

#### 안시성 (Ansi Fortress)
*   **파일명**: `ansi_fortress_bg.png`, `ansi_fortress_thumb.png`
*   **특징**:
    *   험준한 산세를 이용한 견고한 산성.
    *   높고 두꺼운 석축 성벽.
    *   전투 준비가 된 긴장감 있는 분위기 (깃발, 병사들의 실루엣).
*   **프롬프트 키워드**: `ancient korean fortress`, `mountain fortress`, `high stone walls`, `defensive structure`, `Goguryeo flag`, `impregnable fortress`, `dramatic sky`, `historical landscape painting`.

### 5.3. 백과사전/이벤트 이미지 (Encyclopedia)

#### 안시성 전투 (Battle of Ansi)
*   **파일명**: `battle_of_ansi.png`
*   **특징**:
    *   성벽을 기어오르는 당나라 군대와 위에서 방어하는 고구려군의 치열한 공방전.
    *   멀리서 무너지는 토산이나, 활을 쏘는 양만춘의 모습이 작게 포함될 수 있음.
*   **프롬프트 키워드**: `siege warfare`, `ancient battle scene`, `defending castle walls`, `chaos of war`, `arrows flying`, `historical battle illustration`.

#### 고구려 고분 벽화 (Tomb Murals - Muyongchong)
*   **파일명**: `goguryeo_mural_dance.png`
*   **특징**:
    *   실제 무용총 벽화인 '무용도'를 재해석한 일러스트.
    *   점무늬 의상을 입고 춤추는 고구려인들.
    *   낡은 벽화의 질감(Texture)을 살린 느낌.
*   **프롬프트 키워드**: `ancient mural painting`, `korean traditional dance`, `spotted clothes`, `fresco style`, `aged texture`, `historical artifact`.

**참고**: 모든 이미지는 기존 `assets/images`의 화풍과 통일감을 유지해야 합니다.
