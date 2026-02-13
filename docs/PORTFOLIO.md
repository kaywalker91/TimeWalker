# TimeWalker: Echoes of the Past

> 한국 역사 교육 어드벤처 게임 - Flutter 기반 인터랙티브 시간 여행 경험

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📱 프로젝트 개요

**TimeWalker**는 한국의 풍부한 역사를 인터랙티브하게 탐험할 수 있는 모바일 교육 어드벤처 게임입니다. 사용자는 시간 여행자가 되어 삼국시대부터 현대까지 다양한 역사적 인물들을 만나고, 역사적 장소를 탐험하며, 스토리 기반 선택을 통해 역사를 배웁니다.

### 핵심 가치

- 🎮 **게임화된 학습**: 재미있는 게임 메카닉을 통한 역사 교육
- 🗺️ **인터랙티브 탐험**: 실제 역사적 장소를 아름다운 비주얼로 재현
- 👥 **역사 인물 대화**: 40명 이상의 역사적 인물과 대화
- 📖 **스토리 분기**: 플레이어의 선택이 스토리에 영향
- 🏆 **진행도 추적**: 개인화된 학습 경험과 성취 시스템

---

## 🎨 주요 화면

### 1. 메인 메뉴
<img src="assets/screenshots/main_menu.jpg" width="300" alt="Main Menu">

**특징:**
- 다크 테마 기반 UI 디자인
- 골드 액센트 컬러를 활용한 프리미엄 느낌
- 애니메이션된 시계 아이콘 (시간 여행 테마)
- 직관적인 네비게이션 구조

**기능:**
- 시공의 회랑: 메인 역사 탐험 시작
- 역사 도감: 수집한 캐릭터/장소 확인
- 퀴즈 도전: 역사 지식 테스트
- 프로필/설정/상점/리더보드

---

### 2. 장소 탐험
<img src="assets/screenshots/location_exploration.jpg" width="300" alt="Location Exploration">

**특징:**
- 고퀄리티 배경 아트 (역사적 장소 재현)
- 캐릭터 아바타를 통한 인터랙션
- 장소별 스토리 및 퀘스트
- 만날 수 있는 인물 목록 표시

**기술:**
- Flame 엔진을 활용한 2D 렌더링
- 레이어드 배경 시스템 (깊이감)
- 터치 기반 캐릭터 선택
- 동적 로딩 및 캐싱

---

### 3. 캐릭터 카드
<img src="assets/screenshots/character_card.jpg" width="300" alt="Character Card">

**특징:**
- 원형 프레임의 캐릭터 초상화
- 역사적 정보 간결 표시
- 골드 테두리 프리미엄 디자인
- 모달 기반 인터랙션

**정보 구조:**
- 캐릭터 이름 (한글)
- 역사적 직책/시대
- 간단한 설명
- 액션 버튼 (대화하기/닫기)

---

### 4. 대화 시스템
<img src="assets/screenshots/dialogue_scene.jpg" width="300" alt="Dialogue Scene">
<img src="assets/screenshots/dialogue_choices.jpg" width="300" alt="Dialogue Choices">

**특징:**
- 풀스크린 캐릭터 초상화
- 역사적 맥락을 반영한 대화 내용
- 스토리 분기 선택지 (3지선다)
- 시네마틱한 연출

**시스템:**
- YAML 기반 대화 스크립트 관리
- 선택지에 따른 스토리 분기
- 캐릭터별 고유 대화 트리
- 진행도 기반 대화 언락

---

## 🛠️ 기술 스택

### Core Framework
```yaml
Flutter: ^3.10.1
Dart: ^3.10.1
```

### 주요 패키지

| 카테고리 | 패키지 | 버전 | 용도 |
|---------|--------|------|------|
| 상태 관리 | flutter_riverpod | ^2.6.1 | Clean Architecture 기반 상태 관리 |
| 게임 엔진 | flame | ^1.27.0 | 2D 렌더링, 애니메이션 |
| 백엔드 | supabase_flutter | ^2.6.0 | 클라우드 데이터베이스, 인증 |
| 로컬 저장소 | hive | ^2.2.3 | 오프라인 캐싱, 진행도 저장 |
| 라우팅 | go_router | ^15.1.2 | 선언적 라우팅, 딥링크 |
| 애니메이션 | simple_animations | latest | 커스텀 애니메이션 |
| | flutter_staggered_animations | latest | 리스트 애니메이션 |
| 다국어 | flutter_localizations | SDK | i18n 지원 (한/영) |

---

## 🏗️ 아키텍처

### Clean Architecture 기반 레이어 구조

```
lib/
├── core/               # 공통 유틸리티, 설정, 테마
│   ├── config/         # 앱 설정
│   ├── constants/      # 상수 정의
│   ├── routes/         # go_router 설정
│   ├── themes/         # Material 3 테마, 컬러 시스템
│   └── utils/          # 헬퍼 함수
│
├── domain/             # 비즈니스 로직 레이어 (순수 Dart)
│   ├── entities/       # 핵심 비즈니스 엔티티
│   ├── repositories/   # Repository 인터페이스
│   ├── services/       # 도메인 서비스
│   └── usecases/       # 유스케이스 (비즈니스 규칙)
│
├── data/               # 데이터 레이어
│   ├── datasources/    # 데이터 소스 (remote/local/static)
│   ├── models/         # DTO, 직렬화 모델
│   ├── repositories/   # Repository 구현체
│   └── seeds/          # 초기 데이터, 팩토리
│
├── presentation/       # UI 레이어
│   ├── providers/      # Riverpod 프로바이더
│   ├── screens/        # 화면 단위 위젯
│   ├── widgets/        # 재사용 가능한 위젯
│   └── themes/         # UI 테마 컴포넌트
│
├── game/               # Flame 게임 컴포넌트
├── content/            # 콘텐츠 관리 시스템
├── interactive/        # 인터랙티브 기능
└── shared/             # 공유 유틸리티
```

### 의존성 규칙

```
Presentation → Domain ← Data
     ↓             ↓
  Providers    Repositories
     ↓             ↓
  UseCases    Entities
```

- **Presentation**: Domain의 UseCases를 호출
- **Data**: Domain의 Repository 인터페이스를 구현
- **Domain**: 외부 의존성 없음 (순수 비즈니스 로직)

---

## 📊 데이터 모델

### 콘텐츠 계층 구조

```
Region (동아시아)
  └── Country (한국, 일본, 중국)
      └── Era (삼국시대, 고려시대, 조선시대, 근대, 현대)
          ├── Character (광개토대왕, 세종대왕, ...)
          │   ├── id: String
          │   ├── nameKo: String
          │   ├── nameEn: String
          │   ├── title: String
          │   ├── era: String
          │   ├── portraitPath: String
          │   ├── dialogueIds: List<String>
          │   └── unlockedByDefault: bool
          │
          └── Location (경복궁, 첨성대, ...)
              ├── id: String
              ├── nameKo: String
              ├── nameEn: String
              ├── era: String
              ├── backgroundPath: String
              ├── thumbnailPath: String
              ├── characters: List<String>
              ├── storyNodes: List<StoryNode>
              └── unlockedByDefault: bool
```

### 대화 시스템

```dart
DialogueEntity
  ├── id: String
  ├── characterId: String
  ├── title: String
  ├── nodes: List<DialogueNode>
  └── metadata: Map<String, dynamic>

DialogueNode
  ├── id: String
  ├── speaker: String
  ├── text: LocalizedString
  ├── choices: List<DialogueChoice>
  └── nextNodeId: String?

DialogueChoice
  ├── text: LocalizedString
  ├── nextNodeId: String
  ├── condition: String?
  └── effects: List<String>
```

---

## 🎮 핵심 기능

### 1. 역사 탐험 시스템
- **인터랙티브 맵**: 시대별/지역별 역사적 장소 탐험
- **캐릭터 인터랙션**: 40+ 역사 인물과 대화
- **스토리 퀘스트**: 역사적 사건 기반 미션
- **진행도 시스템**: 장소/캐릭터 언락 메카닉

### 2. 대화 시스템
- **분기형 스토리**: 플레이어 선택에 따른 결과 변화
- **조건부 대화**: 진행도에 따른 대화 변화
- **다국어 지원**: 한국어/영어 동시 지원
- **YAML 기반 관리**: 비개발자도 수정 가능한 대화 스크립트

### 3. 교육 콘텐츠
- **퀴즈 시스템**: 역사 지식 확인 및 복습
- **도감 시스템**: 수집한 캐릭터/장소 정보 열람
- **타임라인**: 시대별 주요 사건 연표
- **역사 상식**: 인터랙티브 역사 정보 제공

### 4. 사용자 경험
- **진행도 저장**: Hive 기반 로컬 저장
- **클라우드 동기화**: Supabase를 통한 크로스 디바이스 동기화
- **오프라인 모드**: 네트워크 없이도 플레이 가능
- **성취 시스템**: 업적, 리더보드, 보상

---

## 🎯 개발 프로세스

### 1. 요구사항 분석
- PRD 기반 기능 명세서 작성
- 사용자 시나리오 매핑
- 콘텐츠 계층 구조 설계

### 2. 아키텍처 설계
- Clean Architecture 적용
- Riverpod 상태 관리 패턴
- Repository 패턴 (Remote/Local/Static fallback)

### 3. UI/UX 디자인
- Material 3 디자인 시스템
- 다크 테마 우선 디자인
- 반응형 레이아웃 (다양한 화면 크기)
- 애니메이션 및 트랜지션 설계

### 4. 백엔드 통합
- Supabase 데이터베이스 스키마 설계
- 인증 시스템 (이메일, 소셜 로그인)
- Real-time 동기화
- 오프라인 우선 전략

### 5. 테스트 전략
```
테스트 피라미드:
  - Unit Tests: Domain/Data 레이어 (80%+ 커버리지)
  - Widget Tests: 재사용 위젯 (70%+ 커버리지)
  - Integration Tests: 핵심 사용자 플로우
```

---

## 📈 성능 최적화

### 이미지 최적화
- 캐릭터 초상화: WebP 포맷, 512x512px
- 배경 이미지: WebP 포맷, 1920x1080px
- 썸네일: WebP 포맷, 256x256px
- 레이지 로딩 및 캐싱 적용

### 메모리 관리
- `ListView.builder` 사용 (무한 스크롤)
- 이미지 메모리 캐시 최적화
- 사용하지 않는 리소스 자동 해제

### 네트워크 최적화
- Fallback 체인: Supabase → Hive → Static JSON
- 백그라운드 동기화
- 요청 디바운싱 및 캐싱

---

## 🚀 배포 전략

### 환경 구분
- **Development**: 로컬 개발 및 테스트
- **Staging**: Supabase staging 환경
- **Production**: App Store/Play Store 배포

### CI/CD 파이프라인
```yaml
GitHub Actions:
  - 자동 테스트 실행
  - 코드 품질 검사 (flutter analyze)
  - 자동 빌드 (Android/iOS)
  - 버전 관리 및 태깅
```

---

## 📝 향후 계획

### Phase 1: 콘텐츠 확장 (Q2 2025)
- [ ] 추가 시대 콘텐츠 (통일신라, 발해)
- [ ] 캐릭터 추가 (60명 → 100명)
- [ ] 새로운 장소 (20개 → 50개)

### Phase 2: 게임 메카닉 강화 (Q3 2025)
- [ ] 미니게임 추가 (역사 퍼즐, 미션)
- [ ] 아이템 시스템 (수집 요소)
- [ ] 소셜 기능 (친구, 경쟁, 협동)

### Phase 3: 글로벌화 (Q4 2025)
- [ ] 다국어 지원 확대 (중국어, 일본어)
- [ ] 동아시아 역사 확장 (중국, 일본)
- [ ] 글로벌 서버 구축

---

## 🤝 기여 및 피드백

본 프로젝트는 교육용 게임으로, 역사 전문가, 교육자, 개발자의 피드백을 환영합니다.

### 연락처
- **개발자**: Kay Walker
- **GitHub**: [프로젝트 저장소]
- **이메일**: [이메일 주소]

---

## 📄 라이센스

MIT License - 자세한 내용은 `LICENSE` 파일 참조

---

## 🙏 감사의 말

- Flutter 커뮤니티의 오픈소스 기여자들
- 역사 자문을 제공해주신 전문가들
- 아트워크 제작에 참여해주신 아티스트들
- 테스트 및 피드백을 제공해주신 베타 테스터들

---

**TimeWalker** - *시간을 걷는 자가 되어 역사를 탐험하세요*

![Footer](https://img.shields.io/badge/Made%20with-Flutter-02569B?logo=flutter)
![Footer](https://img.shields.io/badge/Powered%20by-Supabase-3ECF8E?logo=supabase)
