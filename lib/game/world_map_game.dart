import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/game/components/map_background.dart';
import 'package:time_walker/game/components/region_marker.dart';

/// 세계 지도 게임 (Flame 엔진)
class WorldMapGame extends FlameGame
    with PanDetector, ScaleDetector, LongPressDetector {
  final List<Region> regions;
  final UserProgress userProgress;
  final Function(Region) onRegionTapped;
  final void Function(Region)? onRegionPreview;

  late CameraComponent cameraComponent;
  MapBackgroundComponent? background;
  final List<RegionMarkerComponent> markers = [];
  double _lastScale = 1.0;
  bool _isScaling = false;
  double _minZoom = ExplorationConfig.mapMinZoom;

  WorldMapGame({
    required this.regions,
    required this.userProgress,
    required this.onRegionTapped,
    this.onRegionPreview,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Use the built-in camera/world so the scene is actually rendered.
    cameraComponent = camera;
    cameraComponent.viewfinder.anchor = Anchor.center;

    // 배경 생성 및 카메라의 world에 추가
    background = MapBackgroundComponent();
    await world.add(background!);
    
    // 지역 마커 추가
    await _loadMarkers();

    _configureCameraForMap();
  }

  /// 지역 마커 로드
  Future<void> _loadMarkers() async {
    final mapBackground = background;
    if (mapBackground == null) {
      return;
    }

    for (final region in regions) {
      final isUnlocked = userProgress.isRegionUnlocked(region.id) ||
          region.status == ContentStatus.available;
      final progress = userProgress.getRegionProgress(region.id);
      final status = _resolveRegionStatus(region, isUnlocked, progress);

      final marker = RegionMarkerComponent(
        region: region,
        status: status,
        label: region.nameKorean,
        progress: progress,
        onTapped: () => onRegionTapped(region),
      );

      // 지도 좌표를 화면 좌표로 변환
      final mapSize = mapBackground.imageSize;
      final position = Vector2(
        region.center.x * mapSize.x,
        region.center.y * mapSize.y,
      );

      marker.position = position;
      marker.anchor = Anchor.center;

      markers.add(marker);
      await world.add(marker);
    }
  }

  void _configureCameraForMap() {
    final mapBackground = background;
    if (mapBackground == null) {
      return;
    }

    final mapSize = mapBackground.imageSize;
    if (mapSize.x == 0 || mapSize.y == 0) {
      return;
    }

    final viewportSize = cameraComponent.viewport.virtualSize;
    if (viewportSize.x == 0 || viewportSize.y == 0) {
      return;
    }

    final fitZoom = math.min(
      viewportSize.x / mapSize.x,
      viewportSize.y / mapSize.y,
    );
    _minZoom = math.max(fitZoom, ExplorationConfig.mapMinZoom);
    cameraComponent.viewfinder.zoom = _minZoom.clamp(
      _minZoom,
      ExplorationConfig.mapMaxZoom,
    );
    cameraComponent.viewfinder.position = mapSize / 2;
    cameraComponent.setBounds(
      Rectangle.fromLTWH(0, 0, mapSize.x, mapSize.y),
      considerViewport: true,
    );
  }

  /// 특정 지역으로 카메라 이동
  void focusOnRegion(String regionId) {
    final region = regions.firstWhere(
      (r) => r.id == regionId,
      orElse: () => regions.first,
    );

    final mapBackground = background;
    if (mapBackground == null) {
      return;
    }

    final mapSize = mapBackground.imageSize;
    final targetPosition = Vector2(
      region.center.x * mapSize.x,
      region.center.y * mapSize.y,
    );

    // 부드러운 이동 애니메이션 (선택적)
    cameraComponent.viewfinder.position = targetPosition;
  }

  ContentStatus _resolveRegionStatus(
    Region region,
    bool isUnlocked,
    double progress,
  ) {
    if (!isUnlocked) {
      return ContentStatus.locked;
    }
    if (progress >= 1.0) {
      return ContentStatus.completed;
    }
    if (progress > 0.0) {
      return ContentStatus.inProgress;
    }
    return region.status == ContentStatus.locked
        ? ContentStatus.available
        : region.status;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_isScaling) {
      return;
    }
    final delta = info.delta.global;
    if (delta.x == 0 && delta.y == 0) {
      return;
    }
    final zoom = cameraComponent.viewfinder.zoom;
    final move = delta / zoom * ExplorationConfig.mapPanSpeed;
    cameraComponent.viewfinder.position -= move;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    _isScaling = true;
    _lastScale = 1.0;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final scaleX = info.scale.global.x;
    final scaleY = info.scale.global.y;
    final scale = (scaleX + scaleY) / 2;
    if (scale <= 0) {
      return;
    }
    final scaleDelta = scale / _lastScale;
    _lastScale = scale;

    final currentZoom = cameraComponent.viewfinder.zoom;
    final nextZoom = (currentZoom * scaleDelta).clamp(
      _minZoom,
      ExplorationConfig.mapMaxZoom,
    );
    if (nextZoom == currentZoom) {
      return;
    }

    final focalPoint = info.eventPosition.widget;
    final before = cameraComponent.globalToLocal(focalPoint);
    cameraComponent.viewfinder.zoom = nextZoom;
    final after = cameraComponent.globalToLocal(focalPoint);
    cameraComponent.viewfinder.position += before - after;
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    _isScaling = false;
    _lastScale = 1.0;
  }

  @override
  void onLongPressStart(LongPressStartInfo info) {
    final region = _regionAt(info.eventPosition.widget);
    if (region != null) {
      onRegionPreview?.call(region);
    }
  }

  Region? _regionAt(Vector2 widgetPosition) {
    if (markers.isEmpty) {
      return null;
    }
    final worldPosition = cameraComponent.globalToLocal(widgetPosition);
    for (final marker in markers) {
      final radius = marker.size.x / 2;
      if (marker.position.distanceTo(worldPosition) <= radius) {
        return marker.region;
      }
    }
    return null;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (background?.isMounted ?? false) {
      _configureCameraForMap();
    }
  }
}
