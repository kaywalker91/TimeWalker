# Week 2: Flame 지도 통합 - 상세 개발 계획

**기간**: 5일 (월~금)  
**목표**: 세계 지도를 Flame 엔진으로 구현하고 인터랙션 추가

---

## 📋 목차

1. [현재 상태 분석](#1-현재-상태-분석)
2. [작업 항목 및 일정](#2-작업-항목-및-일정)
3. [기술적 구현 상세](#3-기술적-구현-상세)
4. [완료 기준](#4-완료-기준)

---

## 1. 현재 상태 분석

### 1.1 완료된 항목 ✅

| 항목 | 상태 | 비고 |
|------|------|------|
| WorldMapScreen 기본 구조 | ✅ 완료 | InteractiveViewer 사용 중 |
| 지도 배경 이미지 | ✅ 완료 | world_map.png 로드 |
| 지역 마커 기본 UI | ✅ 완료 | _RegionMarker 위젯 |
| 지역 상태 표시 | ✅ 완료 | 잠금/해금 표시 |
| 기본 탭 인터랙션 | ✅ 완료 | GestureDetector 사용 |

### 1.2 미완성 항목 ❌

| 항목 | 우선순위 | 예상 시간 |
|------|----------|----------|
| Flame 엔진 통합 | 🔴 높음 | 2일 |
| 지도 컴포넌트 시스템 | 🔴 높음 | 1일 |
| 핀치 줌/드래그 제스처 | 🔴 높음 | 1일 |
| 마커 애니메이션 | 🟡 중간 | 1일 |
| 성능 최적화 | 🟡 중간 | 1일 |

---

## 2. 작업 항목 및 일정

### Day 1-2 (월~화): Flame 엔진 통합 및 기본 설정

**목표**: Flame Game 클래스 생성 및 기본 구조 설정

#### 작업 1.1: WorldMapGame 클래스 생성
- **파일**: `lib/game/world_map_game.dart`
- **기능**:
  - Flame Game 클래스 상속
  - 카메라 설정
  - 기본 업데이트 루프

**예상 시간**: 4시간

#### 작업 1.2: 지도 배경 컴포넌트
- **파일**: `lib/game/components/map_background.dart`
- **기능**:
  - 지도 이미지 로드
  - 스프라이트 렌더링
  - 크기 조정

**예상 시간**: 3시간

#### 작업 1.3: WorldMapScreen 통합
- **파일**: `lib/presentation/screens/world_map/world_map_screen.dart`
- **기능**:
  - Game 위젯으로 교체
  - Riverpod과 연동

**예상 시간**: 3시간

---

### Day 3 (수요일): 핀치 줌/드래그 제스처

**목표**: 지도 이동 및 확대/축소 기능 구현

#### 작업 3.1: 카메라 제어
- **파일**: `lib/game/world_map_game.dart`
- **기능**:
  - 카메라 이동 (드래그)
  - 카메라 줌 (핀치)
  - 경계 제한

**예상 시간**: 4시간

#### 작업 3.2: 제스처 처리
- **기능**:
  - HasTappableComponents 믹스인
  - HasDragCallbacks 믹스인
  - HasScrollableComponents 믹스인

**예상 시간**: 2시간

---

### Day 4 (목요일): 지역 마커 및 인터랙션

**목표**: 지역 마커를 Flame Component로 구현

#### 작업 4.1: RegionMarker 컴포넌트
- **파일**: `lib/game/components/region_marker.dart`
- **기능**:
  - SpriteComponent 기반
  - 탭 인터랙션
  - 상태 표시 (잠금/해금)

**예상 시간**: 4시간

#### 작업 4.2: 마커 배치 시스템
- **파일**: `lib/game/world_map_game.dart`
- **기능**:
  - 지역 데이터 기반 마커 생성
  - 위치 계산
  - 상태 동기화

**예상 시간**: 2시간

---

### Day 5 (금요일): 애니메이션 및 폴리싱

**목표**: 마커 애니메이션 및 시각적 피드백

#### 작업 5.1: 마커 애니메이션
- **파일**: `lib/game/components/region_marker.dart`
- **기능**:
  - 호버 효과
  - 펄스 애니메이션
  - 클릭 피드백

**예상 시간**: 3시간

#### 작업 5.2: 성능 최적화
- **기능**:
  - 컴포넌트 풀링
  - 렌더링 최적화
  - 메모리 관리

**예상 시간**: 3시간

---

## 3. 기술적 구현 상세

### 3.1 Flame Game 구조

```dart
class WorldMapGame extends FlameGame
    with HasTappableComponents, HasDragCallbacks, HasScrollableComponents {
  late CameraComponent camera;
  late MapBackgroundComponent background;
  final List<RegionMarkerComponent> markers = [];
  
  @override
  Future<void> onLoad() async {
    // 카메라 설정
    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
    );
    camera.viewfinder.anchor = Anchor.center;
    add(camera);
    
    // 배경 추가
    background = MapBackgroundComponent();
    camera.add(background);
    
    // 마커 추가
    await _loadMarkers();
  }
}
```

### 3.2 마커 컴포넌트 구조

```dart
class RegionMarkerComponent extends SpriteComponent
    with HasGameRef<WorldMapGame>, Tappable {
  final Region region;
  final bool isLocked;
  
  @override
  Future<void> onLoad() async {
    // 스프라이트 로드
    sprite = await gameRef.loadSprite('...');
    size = Vector2(80, 80);
    anchor = Anchor.center;
    
    // 애니메이션 추가
    add(IdleAnimationComponent());
  }
  
  @override
  bool onTapDown(TapDownInfo info) {
    // 탭 처리
    return true;
  }
}
```

---

## 4. 완료 기준

### 4.1 기능 완성도

| 항목 | 완료 기준 |
|------|----------|
| Flame 통합 | ✅ Game 위젯으로 지도 표시 |
| 제스처 | ✅ 핀치 줌/드래그 동작 |
| 마커 | ✅ 지역 마커 클릭 가능 |
| 애니메이션 | ✅ 마커 호버/펄스 효과 |

### 4.2 품질 기준

| 지표 | 목표 |
|------|------|
| FPS | >55fps |
| 메모리 사용 | <150MB |
| 로딩 시간 | <2초 |

---

**문서 버전**: 1.0  
**작성일**: 2025년

