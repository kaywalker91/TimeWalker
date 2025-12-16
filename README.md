# TimeWalker: Echoes of the Past

**TimeWalker: Echoes of the Past**는 전 세계의 역사를 지도 탐험과 시대 여행을 통해 배우는 인터랙티브 교육 어드벤처 게임입니다.

## 🎮 프로젝트 개요
플레이어는 '타임 워커'가 되어 다양한 시대와 장소를 여행하며 역사적 사건을 체험하고, 인물들과 대화하며 숨겨진 이야기를 발견합니다.

## 🚀 주요 기능
- **인터랙티브 지도 탐험**: Flame 엔진을 활용한 몰입감 있는 지도 이동 및 탐험.
- **시대 여행 (Time Travel)**: 고대, 중세, 근대 등 다양한 역사적 시대로의 이동.
- **대화 시스템**: 역사적 인물들과의 상호작용 및 스토리 진행 (YAML 기반 스크립트).
- **교육적 콘텐츠**: 역사적 사실에 기반한 퀘스트와 정보 제공.

## 🛠 기술 스택
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Game Engine**: Flame (지도 및 인터랙션 구현)
- **Local Storage**: Hive
- **Routing**: GoRouter
- **Localization**: flutter_localizations, intl

## 📂 폴더 구조
```
lib/
├── content/       # 게임 데이터 (캐릭터, 대화, 시대 정보)
├── core/          # 공통 유틸리티, 상수, 테마, 라우팅
├── data/          # 데이터 레이어 (저장소, 모델)
├── domain/        # 비즈니스 로직 (엔티티, 유스케이스)
├── game/          # Flame 게임 엔진 관련 코드
├── interactive/   # 상호작용 요소 (대화, 탐험, 지도)
├── presentation/  # UI (화면, 위젯, 프로바이더)
└── main.dart      # 앱 진입점
```

## 📦 설치 및 실행
1. 저장소 클론:
   ```bash
   git clone https://github.com/kaywalker91/TimeWalker.git
   ```
2. 의존성 설치:
   ```bash
   flutter pub get
   ```
3. 앱 실행:
   ```bash
   flutter run
   ```