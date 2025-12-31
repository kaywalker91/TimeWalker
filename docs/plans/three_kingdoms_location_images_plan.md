# 삼국시대 역사적 장소 이미지 생성 계획

> **작성일**: 2025-12-31  
> **목적**: 삼국시대 각 장소의 생동감 있는 배경 이미지 생성  
> **대상**: 삼국시대 11개 역사적 장소

---

## 📋 개요

### 목표
- 사용자가 각 역사적 장소에 "이동"했을 때 **몰입감을 극대화**할 수 있는 고품질 배경 이미지 생성
- 각 왕국(고구려/백제/신라/가야)의 **고유한 분위기와 건축 양식** 반영
- **역사적 고증**에 기반하되 **판타지적 생동감**을 가미한 아트 스타일

### 아트 스타일 가이드
- **스타일**: 동양 판타지 풍경화 (모바일 게임/역사 시뮬레이션 느낌)
- **색감**: 시대별 특성 반영 (고구려: 강인함, 백제: 우아함, 신라: 화려함, 가야: 신비함)
- **구도**: 와이드 랜드스케이프 (가로형, 16:9 비율 권장)
- **분위기**: 해당 장소의 역사적 의미를 담은 극적인 하늘/조명

---

## 🎨 장소별 이미지 프롬프트

### 🔴 고구려 (Goguryeo) - 3곳

#### 1. 국내성 (goguryeo_palace)
**현재 상태**: ⚠️ 생성 필요

**역사적 배경**:
- 고구려의 두 번째 수도 (서기 3년 ~ 427년, 약 425년간)
- 둘레 약 2.7km의 대규모 평지성, 석축 성벽
- 압록강과 통구하가 만나는 지안 분지에 위치
- 환도성과 함께 "평지성-산성" 이중 도읍 체제

**파일명**: `assets/images/locations/goguryeo_palace_bg.png`

**프롬프트**:
```
Wide landscape of Gungnae-seong (Goguryeo capital city, 4th century AD), massive stone fortress walls in a mountain valley. The fortress has grand palace buildings with distinctive Goguryeo architecture - steep roofs with ornate eaves, red and black color scheme. The Yalu River flows nearby with misty mountains in the background. Military banners with Goguryeo symbols flutter in the wind. Dramatic sunset lighting with warm golden and orange tones. Epic historical fantasy art style, like a mobile game background. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 국내성 - 산으로 둘러싸인 분지에 웅장한 석축 성벽, 고구려 특유의 가파른 지붕과 붉은색/검은색 건축물, 압록강과 안개 자욱한 산, 군기가 펄럭이는 장엄한 석양

---

#### 2. 살수 (salsu) - 청천강
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 살수대첩(612년) 현장 - 을지문덕 장군이 수나라 30만 대군 격파
- 현재의 청천강 (길이 약 199km)
- 강을 반쯤 건너던 적군을 공격한 전투 장소-

**파일명**: `assets/images/locations/salsu_bg.png`

**프롬프트**:
```
Epic wide landscape of Salsu River (Cheongcheon River, Goguryeo era 612 AD) during the famous Battle of Salsu. A wide river flows through a mountainous valley, with Goguryeo fortress walls visible on distant hills. Morning mist rises from the water, creating a dramatic atmosphere. Goguryeo military banners and watchtowers dot the landscape. The scene captures the tension before a great battle. Moody lighting with cool blue-grey tones mixed with warm dawn colors. Historical fantasy war game art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 살수(청천강) - 산악 계곡을 흐르는 넓은 강, 원거리에 고구려 성벽이 보이고, 아침 안개가 피어오르는 긴장감 있는 전투 직전의 풍경

---

#### 3. 평양성 (pyongyang_fortress)
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 427년 장수왕이 천도한 고구려 후기 수도
- 대동강 유역의 전략적 요충지
- 궁궐, 관청, 불교 사찰이 함께 있던 도성

**파일명**: `assets/images/locations/pyongyang_fortress_bg.png`

**프롬프트**:
```
Majestic wide landscape of Pyongyang Fortress (Goguryeo late capital, 5th-7th century AD). Grand palace complex with tall fortress walls overlooking the Taedong River. Multiple-tiered palace roofs in traditional Goguryeo style with black tiles and red pillars. Buddhist pagodas visible in the distance. Cherry blossoms or autumn foliage for seasonal beauty. The Taedong River curves elegantly around the fortress. Dramatic afternoon light with golden rays breaking through clouds. Historical fantasy art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 평양성 - 대동강이 굽이치는 언덕 위의 웅장한 궁궐 단지, 검은 기와와 붉은 기둥의 고구려 건축, 원경에 불탑, 계절의 아름다움을 담은 장면

---

### 🟡 백제 (Baekje) - 3곳

#### 4. 위례성 (wiryeseong) - 한성백제
**현재 상태**: ✅ 확인 필요

**역사적 배경**:
- 백제의 첫 수도 (기원전 18년 ~ 475년, 약 500년간)
- 현재 서울 송파구 풍납토성 일대로 추정
- 판축 기법으로 쌓은 대규모 토성 (둘레 약 3.5km)
- 한강변에 위치한 평지성

**파일명**: `assets/images/locations/wiryeseong_bg.png`

**프롬프트**:
```
Wide landscape of Wirye-seong (Baekje's first capital, 3rd-5th century AD), a massive earthen fortress city by the Han River. Tall earthen walls (pungnap-style toseong) surround elegant palace buildings with graceful curved roofs. Baekje architecture showing refined aesthetics - "simple but not shabby, ornate but not extravagant". The Han River flows peacefully in the foreground with boats. Willow trees line the riverbank. Soft spring morning light with pastel pink sky. Historical fantasy art style with elegant, graceful mood. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 위례성 - 한강변의 대규모 토성, 우아한 곡선 지붕의 백제 궁궐, "검이불루 화이불치"의 세련된 미학, 평화롭게 흐르는 한강과 버드나무

---

#### 5. 황산벌 (hwangsanbeol)
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 계백 장군과 5천 결사대가 신라 5만 군과 싸운 최후의 결전지 (660년)
- 백제 멸망 직전의 비극적인 전투
- 현재 충남 논산 연산면 일대

**파일명**: `assets/images/locations/hwangsanbeol_bg.png`

**프롬프트**:
```
Dramatic wide landscape of Hwangsanbeol Battlefield (Baekje, 660 AD), a vast open plain where the final great battle took place. Golden autumn grass fields stretch to distant mountains. Baekje military camps with white tents and banners bearing Baekje emblems. Ominous storm clouds gather on the horizon, symbolizing the tragic fate. A single ancient tree stands in the center, witness to history. Dramatic twilight lighting with deep purple and gold colors. Melancholic but heroic atmosphere. Historical war fantasy art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 황산벌 - 드넓은 평야, 가을 황금빛 억새밭, 백제 군막과 깃발, 지평선의 불길한 먹구름, 비극적이면서 영웅적인 분위기

---

#### 6. 사비성 (sabi) - 부여
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 백제의 마지막 수도 (538년 ~ 660년, 약 120년)
- 바둑판 모양의 계획도시, 대규모 상수도 시설
- 북쪽과 동쪽에 나성(외곽성), 남서쪽에 백마강
- 부소산 아래의 아름다운 궁궐 터

**파일명**: `assets/images/locations/sabi_bg.png`

**프롬프트**:
```
Elegant wide landscape of Sabi Capital (Baekje's last capital in Buyeo, 6th-7th century AD). A sophisticated planned city with grid-pattern streets visible from an elevated view. The royal palace (Sabi Palace) sits at the foot of Busosan Mountain with the Baekmagang River (White Horse River) flowing gracefully around the city. Multiple palace halls with elegant Baekje architecture - refined and graceful rooflines. Lotus ponds and ornamental gardens within the palace grounds. Peaceful late afternoon golden hour lighting. Sophisticated historical fantasy art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 사비성 - 부소산 아래의 계획도시, 격자형 도로, 백마강이 흐르는 우아한 풍경, 연꽃 연못과 정원이 있는 세련된 백제 궁궐

---

### 🔵 신라 (Silla) - 2곳

#### 7. 월성/경주궁 (gyeongju_palace)
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 천년 신라의 심장부, 반월성이라고도 불림
- 신라 왕궁이 있던 곳 (경주 반월성)
- 선덕여왕, 김유신 등 신라 인물들의 활동 무대

**파일명**: `assets/images/locations/gyeongju_palace_bg.png`

**프롬프트**:
```
Magnificent wide landscape of Wolseong Palace (Silla Kingdom capital in Gyeongju, 7th century AD). The crescent moon-shaped (Banwolseong) fortress walls surround an opulent palace complex. Silla architecture with gold-decorated roofs reflecting the kingdom known as "the country of gold". Ancient pine trees and stone lanterns line the palace grounds. Anapji (Donggung) royal pond visible with lotus flowers. Cheomseongdae observatory can be seen in the distance. Warm sunset lighting with purple and gold colors reflecting Silla's prosperity. Luxurious historical fantasy art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 월성(경주궁) - 반월 모양의 성벽, 금으로 장식된 화려한 신라 궁궐, 소나무와 석등, 안압지(동궁), 원경에 첨성대, 황금빛 번영의 분위기

---

#### 8. 첨성대 (cheomseongdae)
**현재 상태**: ⚠️ Placeholder (필수 생성)

**역사적 배경**:
- 동양 최고(最古)의 천문대 (선덕여왕 632~647년)
- 높이 약 9.4m, 27단의 돌로 쌓은 병 모양 구조물
- 1년의 날수를 상징하는 361~365개의 돌
- 천원지방(天圓地方) 우주관 반영

**파일명**: `assets/images/locations/cheomseongdae_bg.png`

**프롬프트**:
```
Mystical wide landscape of Cheomseongdae Observatory (Silla Kingdom, 7th century AD) at night. The bottle-shaped stone observatory stands alone under a magnificent starry sky with the Milky Way visible. The 27-tier stone structure glows softly with mysterious energy. Ancient astronomers in Silla robes observe the stars. The full moon rises behind the observatory. Nearby traditional Silla buildings and the silhouette of nearby tumuli (royal tombs). Deep blue night sky with countless stars and aurora-like glow. Mystical historical fantasy art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 첨성대 - 별이 쏟아지는 밤하늘 아래 신비롭게 빛나는 첨성대, 은하수와 보름달, 천문 관측하는 신라 학자들, 주변 능묘의 실루엣

---

### 🟢 가야 (Gaya) - 3곳

#### 9. 구지봉 (gujibong)
**현재 상태**: ✅ 있음 (품질 확인 필요)

**역사적 배경**:
- 수로왕 탄생 전설의 성지
- 하늘에서 황금알이 내려온 곳
- 가야 건국 신화의 중심지

**파일명**: `assets/images/locations/gujibong_bg.png`

**프롬프트**:
```
Mystical wide landscape of Guji Peak (Gaya Kingdom founding site, 1st century AD). A sacred hill where legend says golden eggs descended from heaven. Soft ethereal light beams down from dramatic clouds onto the hilltop. Ancient altar stones arranged ceremonially on the peak. Primitive but sacred atmosphere with shamanic elements. The Nakdong River visible in the distance. Spring dawn with mist rising from the valleys. Mythical, fairy-tale atmosphere with golden and purple hues. Historical fantasy art style with mystical elements. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 구지봉 - 하늘에서 신성한 빛이 내려오는 언덕, 제단 돌, 낙동강이 보이는 신화적 분위기, 황금빛과 보라빛의 신비로운 새벽

---

#### 10. 김해 금관가야 왕궁 (gimhae_palace)
**현재 상태**: ✅ 있음 (품질 확인 필요)

**역사적 배경**:
- 금관가야의 중심부 (김해)
- 낙동강 하류의 철기 강국
- 수로왕과 황옥 공주의 혼례 장소

**파일명**: `assets/images/locations/gimhae_palace_bg.png`

**프롬프트**:
```
Wide landscape of Geumgwan Gaya Palace (Gimhae, 1st-6th century AD), the iron kingdom's capital. A prosperous trading city with palace buildings showing unique Gaya architecture - blend of Korean and international influences. The Nakdong River delta visible with numerous trading ships. Iron forging workshops with smoke rising, symbolizing Gaya's iron culture. Marketplace scenes showing international trade. Bright afternoon light showing prosperity. Unique Gaya cultural elements - distinctive pottery and iron artifacts visible. Historical fantasy trade city art style. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 김해 왕궁 - 철기 왕국의 번영한 무역 도시, 낙동강 삼각주의 교역선들, 철 제련소의 연기, 국제 무역의 활기찬 분위기

---

#### 11. 고령 대가야 왕궁 (goryeong_palace)
**현재 상태**: ✅ 있음 (품질 확인 필요)

**역사적 배경**:
- 대가야의 수도 (고령)
- 가야 연맹 후기의 맹주
- 우륵과 가야금의 본거지

**파일명**: `assets/images/locations/goryeong_palace_bg.png`

**프롬프트**:
```
Serene wide landscape of Daegaya Palace (Goryeong, 5th-6th century AD), the cultural heart of the Gaya Confederacy. An elegant palace nestled among green mountains, known for music and art. A pavilion where the musician Ureuk plays the Gayageum (12-string zither). Traditional Gaya architecture with gentle curved roofs surrounded by bamboo groves. Misty mountains in the background with royal tombs (Jisan-dong tumuli) visible on hillsides. Peaceful afternoon with soft golden light. Cultural and artistic atmosphere. Historical fantasy art style with emphasis on elegance. Landscape orientation, 16:9 aspect ratio.
```

**한글 설명**: 고령 대가야 왕궁 - 음악과 예술의 중심지, 가야금 연주하는 우륵의 정자, 대나무 숲에 둘러싸인 우아한 궁궐, 산등성이의 왕릉, 평화로운 문화적 분위기

---

## 📊 생성 우선순위

### 🔴 최우선 (Placeholder 교체 필수) - 6개

| # | 장소 | 파일명 | 핵심 요소 |
|---|------|--------|----------|
| 1 | 살수(청천강) | `salsu_bg.png` | 전투 직전의 긴장감, 강과 산 |
| 2 | 평양성 | `pyongyang_fortress_bg.png` | 대동강, 웅장한 궁궐 |
| 3 | 황산벌 | `hwangsanbeol_bg.png` | 드넓은 평야, 비극적 분위기 |
| 4 | 사비성 | `sabi_bg.png` | 계획도시, 백마강, 우아함 |
| 5 | 월성 | `gyeongju_palace_bg.png` | 반월성, 황금빛 신라 궁궐 |
| 6 | 첨성대 | `cheomseongdae_bg.png` | 별밤, 신비로운 천문대 |

### 🟡 확인 후 필요시 생성 - 2개

| # | 장소 | 파일명 | 비고 |
|---|------|--------|------|
| 7 | 국내성 | `goguryeo_palace_bg.png` | 파일 존재 여부 확인 |
| 8 | 위례성 | `wiryeseong_bg.png` | 파일 존재 여부 확인 |

### 🟢 품질 확인 후 결정 - 3개

| # | 장소 | 파일명 | 비고 |
|---|------|--------|------|
| 9 | 구지봉 | `gujibong_bg.png` | 기존 파일 품질 확인 |
| 10 | 김해 왕궁 | `gimhae_palace_bg.png` | 기존 파일 품질 확인 |
| 11 | 고령 왕궁 | `goryeong_palace_bg.png` | 기존 파일 품질 확인 |

---

## 🎨 왕국별 색상 가이드

| 왕국 | 주요 색상 | 분위기 | 건축 특징 |
|------|----------|--------|----------|
| **고구려** | 붉은색, 검정, 금색 | 강인함, 웅장함 | 가파른 지붕, 석축 성벽 |
| **백제** | 흰색, 연녹색, 금색 | 우아함, 세련됨 | 곡선 지붕, 토성, 섬세함 |
| **신라** | 금색, 보라색, 청록색 | 화려함, 번영 | 금 장식, 불교 탑, 고분 |
| **가야** | 철빛, 녹색, 황금색 | 신비함, 교역 | 철기 문화, 국제적 영향 |

---

## ⏱️ 예상 소요 시간

| 작업 | 항목 수 | 시간(개당) | 총 시간 |
|------|---------|----------|---------|
| 최우선 생성 | 6개 | ~2분 | ~12분 |
| 확인 후 생성 | 2개 | ~2분 | ~4분 |
| 품질 확인 | 3개 | ~1분 | ~3분 |
| **총합** | **11개** | | **~20분** |

---

## ✅ 다음 단계

1. ✅ 이미지 생성 프롬프트 작성 완료
2. ⏳ 최우선 6개 이미지 생성 진행
3. ⏳ 기존 이미지 품질 확인
4. ⏳ 필요시 추가 이미지 생성
5. ⏳ 앱에 이미지 적용 및 테스트

---

*본 계획은 역사적 고증을 기반으로 하되, 게임/앱의 시각적 몰입감을 위해 판타지적 요소를 가미한 아트 스타일을 적용합니다.*
