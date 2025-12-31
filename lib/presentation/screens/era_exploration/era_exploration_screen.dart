import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/map_projection.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/tutorial_overlay.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_widgets.dart';

class EraExplorationScreen extends ConsumerStatefulWidget {
  final String eraId;

  const EraExplorationScreen({super.key, required this.eraId});

  @override
  ConsumerState<EraExplorationScreen> createState() =>
      _EraExplorationScreenState();
}

class _EraExplorationScreenState extends ConsumerState<EraExplorationScreen> {
  /// 화면 초기화 완료 여부 (BGM 중복 재생 방지)
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[EraExplorationScreen] initState - eraId=${widget.eraId}');
    
    // BGM 초기화 (build가 아닌 initState에서 한 번만 실행)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      final eraBgm = AudioConstants.getBGMForEra(widget.eraId);
      if (currentTrack != eraBgm) {
        ref.read(bgmControllerProvider.notifier).playEraBgm(widget.eraId);
      }
    });
  }

  static const List<String> _kingdomOrder = [
    'goguryeo',
    'baekje',
    'silla',
    'gaya',
  ];
  static const Map<String, KingdomMeta> _kingdomMeta = {
    'goguryeo': KingdomMeta(label: '고구려', color: Color(0xFF5B6EFF)),
    'baekje': KingdomMeta(label: '백제', color: Color(0xFFD17B2C)),
    'silla': KingdomMeta(label: '신라', color: Color(0xFF2DBE7D)),
    'gaya': KingdomMeta(label: '가야', color: Color(0xFF8D5DE8)),
  };
  static const Map<String, TerritorySpec> _territories = {
    'goguryeo': TerritorySpec(Offset(0.48, 0.22), Size(0.42, 0.3)),
    'baekje': TerritorySpec(Offset(0.46, 0.58), Size(0.3, 0.25)),
    'silla': TerritorySpec(Offset(0.68, 0.72), Size(0.3, 0.28)),
    'gaya': TerritorySpec(Offset(0.56, 0.78), Size(0.22, 0.2)),
  };

  static const double _markerMinSpacingScale = 1.1;
  static const double _spiderfyRadiusScale = 1.7;
  static const double _anchorDotScale = 0.22;

  final Set<String> _activeKingdoms = {..._kingdomOrder};
  final TransformationController _transformationController =
      TransformationController();
  bool _showLegend = false;
  Location? _selectedLocation;
  Size? _mapCanvasSize;
  String? _imageSizeAsset;
  Future<Size>? _imageSizeFuture;

  @override
  void dispose() {
    debugPrint('[EraExplorationScreen] dispose - eraId=${widget.eraId}');
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eraAsync = ref.watch(eraByIdProvider(widget.eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(widget.eraId));
    final userProgressAsync = ref.watch(userProgressProvider);

    // BGM은 initState에서 처리됨 (build에서 중복 실행 방지)

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: eraAsync.when(
          data: (era) => Text(
            era?.nameKorean ?? AppLocalizations.of(context)!.exploration_title_default,
            style: const TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const Text('Error'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Fallback if deep linked or weird state
              context.go(AppRouter.worldMap);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map), // Map/Legend toggle
            onPressed: () {
              setState(() {
                _showLegend = !_showLegend;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline), // Tutorial/Help
            onPressed: () => _showExplorationHelp(context),
          ),
        ],
      ),
      body: eraAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (era) {
          if (era == null) return Center(child: Text(AppLocalizations.of(context)!.exploration_era_not_found));

          return locationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text(AppLocalizations.of(context)!.exploration_location_error(err.toString()))),
            data: (locations) {
              return userProgressAsync.when(
                data: (userProgress) {
                  final showTutorial = !userProgress.hasCompletedTutorial;
                  final content = _buildExplorationView(context, ref, era, locations);

                  if (showTutorial) {
                    return TutorialOverlay(
                      message: AppLocalizations.of(context)!.exploration_tutorial_msg,
                      onDismiss: () async {
                        final newProgress = userProgress.copyWith(hasCompletedTutorial: true);
                        await ref.read(userProgressRepositoryProvider).saveUserProgress(newProgress);
                        ref.invalidate(userProgressProvider);
                      },
                      child: content,
                    );
                  }
                  return content;
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Center(child: Text('Error loading progress')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildExplorationView(
    BuildContext context,
    WidgetRef ref,
    Era era,
    List<Location> locations,
  ) {
    final responsive = context.responsive;
    _ensureImageSizeFuture(era.backgroundAsset);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final screenH = constraints.maxHeight;

        return FutureBuilder<Size>(
          future: _imageSizeFuture,
          builder: (context, snapshot) {
            final imageSize = snapshot.data ?? const Size(1024, 1024);
            final aspectRatio = imageSize.width == 0
                ? 1.0
                : imageSize.width / imageSize.height;

            var mapWidth = screenW * 2.2;
            var mapHeight = mapWidth / aspectRatio;
            final minHeight = screenH * 1.2;
            if (mapHeight < minHeight) {
              mapHeight = minHeight;
              mapWidth = mapHeight * aspectRatio;
            }

            final mapSize = Size(mapWidth, mapHeight);
            _updateMapTransformIfNeeded(mapSize, screenW, screenH);

            // Responsive marker size
            final markerSize = responsive.markerSize(50);
            final hudPadding = responsive.padding(20);
            final hudBottom = responsive.spacing(40);
            final isThreeKingdoms = era.id == 'korea_three_kingdoms';

            return Stack(
              children: [
                // 1. Scrollable Map Layer
                InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: ExplorationConfig.mapMinZoom,
                  maxScale: ExplorationConfig.mapMaxZoom,
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(mapWidth * 0.2),
                  child: SizedBox(
                    width: mapWidth,
                    height: mapHeight,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Stack(
                        children: [
                          // Map Background
                          Positioned.fill(
                            child: Image.asset(
                              era.backgroundAsset,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.05),
                                    Colors.black.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (isThreeKingdoms && _showLegend)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: KingdomTerritoryPainter(
                                    territories: _territories,
                                    kingdomMeta: _kingdomMeta,
                                    activeKingdoms: _activeKingdoms,
                                  ),
                                ),
                              ),
                            ),

                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _transformationController,
                              builder: (context, _) {
                                final scale = _transformationController.value
                                    .getMaxScaleOnAxis();
                                final markerLayer = _buildMarkerLayer(
                                  context,
                                  ref,
                                  era,
                                  locations,
                                  mapSize,
                                  markerSize,
                                  scale,
                                );
                                return markerLayer;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_showLegend && isThreeKingdoms)
                  Positioned(
                    right: hudPadding,
                    top: hudPadding + 56,
                    child: _buildLegendPanel(context),
                  ),

                // 2. HUD Layer (Bottom - Fixed on Screen)
                Positioned(
                  left: hudPadding,
                  right: hudPadding,
                  bottom: hudBottom,
                  child: _buildHudPanel(context, era, locations, responsive),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMarkerLayer(
    BuildContext context,
    WidgetRef ref,
    Era era,
    List<Location> locations,
    Size mapSize,
    double markerSize,
    double scale,
  ) {
    final selectedId = _selectedLocation?.id;
    final entries = <MarkerEntry>[];

    for (final location in locations) {
      final resolved = _resolveLocationPosition(location, era);
      final left = resolved.x * mapSize.width;
      final top = resolved.y * mapSize.height;
      final kingdom = location.kingdom;
      final baseColor =
          _kingdomMeta[kingdom]?.color ?? era.theme.accentColor;
      final isDimmed =
          kingdom != null && !_activeKingdoms.contains(kingdom);

      entries.add(
        MarkerEntry(
          location: location,
          position: Offset(left, top),
          baseColor: baseColor,
          isDimmed: isDimmed,
          isSelected: selectedId == location.id,
        ),
      );
    }

    final spacing = (markerSize * _markerMinSpacingScale) / scale;
    final radius = (markerSize * _spiderfyRadiusScale) / scale;
    final groups = _groupMarkerEntries(entries, spacing);
    final lines = <MarkerLine>[];
    final widgets = <Widget>[];

    for (final group in groups) {
      final center = _averagePosition(group);
      final count = group.length;
      for (var index = 0; index < count; index++) {
        final entry = group[index];
        final calloutPosition = count == 1
            ? entry.position
            : _clampToMap(
                center +
                    Offset(
                      math.cos(_angleFor(index, count)) * radius,
                      math.sin(_angleFor(index, count)) * radius,
                    ),
                mapSize,
                markerSize * 0.6,
              );

        if (count > 1) {
          lines.add(
            MarkerLine(
              start: entry.position,
              end: calloutPosition,
              color: entry.baseColor
                  .withValues(alpha: entry.isDimmed ? 0.25 : 0.6),
            ),
          );
        }

        widgets.add(
          LocationAnchor(
            left: entry.position.dx,
            top: entry.position.dy,
            size: markerSize * _anchorDotScale,
            color: entry.baseColor,
            isDimmed: entry.isDimmed,
            isSelected: entry.isSelected,
          ),
        );

        widgets.add(
          LocationMarker(
            location: entry.location,
            baseColor: entry.baseColor,
            left: calloutPosition.dx,
            top: calloutPosition.dy,
            markerSize: markerSize,
            isDimmed: entry.isDimmed,
            isSelected: entry.isSelected,
            showLabel: entry.isSelected,
            onTap: entry.isDimmed
                ? null
                : () {
                    setState(() {
                      _selectedLocation = entry.location;
                    });
                    _showLocationDetails(
                      context,
                      ref,
                      entry.location,
                      era.theme,
                    );
                  },
          ),
        );
      }
    }

    return Stack(
      children: [
        if (lines.isNotEmpty)
          Positioned.fill(
            child: CustomPaint(
              painter: MarkerConnectionPainter(lines),
            ),
          ),
        ...widgets,
      ],
    );
  }

  MapCoordinates _resolveLocationPosition(Location location, Era era) {
    if (era.mapBounds != null &&
        location.latitude != null &&
        location.longitude != null) {
      return MapProjection.projectNormalized(
        latitude: location.latitude!,
        longitude: location.longitude!,
        bounds: era.mapBounds!,
      );
    }
    return location.position;
  }

  List<List<MarkerEntry>> _groupMarkerEntries(
    List<MarkerEntry> entries,
    double spacing,
  ) {
    final remaining = [...entries];
    final groups = <List<MarkerEntry>>[];

    while (remaining.isNotEmpty) {
      final seed = remaining.removeLast();
      final group = <MarkerEntry>[seed];
      var expanded = true;

      while (expanded) {
        expanded = false;
        for (var i = remaining.length - 1; i >= 0; i--) {
          final candidate = remaining[i];
          final isNear = group.any(
            (entry) => (entry.position - candidate.position).distance <= spacing,
          );
          if (isNear) {
            group.add(candidate);
            remaining.removeAt(i);
            expanded = true;
          }
        }
      }

      groups.add(group);
    }

    return groups;
  }

  Offset _averagePosition(List<MarkerEntry> entries) {
    if (entries.isEmpty) {
      return Offset.zero;
    }
    final total = entries.fold<Offset>(
      Offset.zero,
      (sum, entry) => sum + entry.position,
    );
    return Offset(
      total.dx / entries.length,
      total.dy / entries.length,
    );
  }

  double _angleFor(int index, int count) {
    if (count <= 1) {
      return -math.pi / 2;
    }
    return (-math.pi / 2) + (2 * math.pi * index / count);
  }

  Offset _clampToMap(Offset position, Size mapSize, double margin) {
    final clampedX = position.dx
        .clamp(margin, mapSize.width - margin);
    final clampedY = position.dy
        .clamp(margin, mapSize.height - margin);
    return Offset(clampedX, clampedY);
  }

  void _ensureImageSizeFuture(String asset) {
    if (_imageSizeFuture != null && _imageSizeAsset == asset) {
      return;
    }
    _imageSizeAsset = asset;
    _imageSizeFuture = _loadImageSize(asset);
  }

  Future<Size> _loadImageSize(String asset) {
    final completer = Completer<Size>();
    final image = AssetImage(asset);
    final stream = image.resolve(const ImageConfiguration());
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) {
          completer.complete(
            Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            ),
          );
        }
        stream.removeListener(listener);
      },
      onError: (error, stack) {
        if (!completer.isCompleted) {
          completer.complete(const Size(1024, 1024));
        }
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

  void _updateMapTransformIfNeeded(
    Size mapSize,
    double screenW,
    double screenH,
  ) {
    if (_mapCanvasSize == mapSize) {
      return;
    }
    _mapCanvasSize = mapSize;
    final translateX = (screenW - mapSize.width) / 2;
    final translateY = (screenH - mapSize.height) / 2;
    _transformationController.value = Matrix4.identity()
      ..setTranslationRaw(translateX, translateY, 0);
  }

  Widget _buildLegendPanel(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.exploration_legend_title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kingdomOrder.map((kingdom) {
                final meta = _kingdomMeta[kingdom];
                if (meta == null) return const SizedBox.shrink();
                final isActive = _activeKingdoms.contains(kingdom);
                return FilterChip(
                  label: Text(meta.label),
                  selected: isActive,
                  selectedColor: meta.color.withValues(alpha: 0.25),
                  checkmarkColor: meta.color,
                  labelStyle: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: meta.color.withValues(alpha: 0.7),
                  ),
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _activeKingdoms.add(kingdom);
                      } else {
                        _activeKingdoms.remove(kingdom);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.exploration_status_title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: const [
                StatusLegend(color: Colors.amber, label: '탐험 가능'),
                StatusLegend(color: Colors.blue, label: '진행 중'),
                StatusLegend(color: Colors.green, label: '완료'),
                StatusLegend(color: Colors.grey, label: '잠김'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showExplorationHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exploration_help_title),
        content: Text(AppLocalizations.of(context)!.exploration_tutorial_msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.common_close),
          ),
        ],
      ),
    );
  }

  void _showExplorationListSheet(
    BuildContext context,
    Era era,
    List<Location> locations, {
    int initialTabIndex = 0,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ExplorationListSheet(
        era: era,
        locations: locations,
        initialTabIndex: initialTabIndex,
        kingdomMeta: _kingdomMeta,
        onLocationSelected: (location) {
          setState(() {
            _selectedLocation = location;
          });
          Navigator.of(context).pop();
          _showLocationDetails(context, ref, location, era.theme);
        },
      ),
    );
  }

  Widget _buildHudPanel(
    BuildContext context,
    Era era,
    List<Location> locations,
    ResponsiveUtils responsive,
  ) {
    final horizontalPadding = responsive.padding(20);
    final verticalPadding = responsive.padding(16);
    final iconSize = responsive.iconSize(24);
    final fontSize = responsive.fontSize(12);
    final percentFontSize = responsive.fontSize(18);
    final buttonFontSize = responsive.fontSize(12);
    final selectedLocation = _selectedLocation;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: era.theme.accentColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.padding(8)),
                decoration: BoxDecoration(
                  color: era.theme.primaryColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_edu, color: Colors.white, size: iconSize),
              ),
              SizedBox(width: responsive.spacing(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final progressAsync = ref.watch(userProgressProvider);

                        return progressAsync.when(
                          data: (progress) {
                            final p = progress.getEraProgress(era.id);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.exploration_progress_label,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: fontSize,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: p,
                                    backgroundColor: Colors.white24,
                                    color: era.theme.accentColor,
                                    minHeight: responsive.isSmallPhone ? 4 : 6,
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const LinearProgressIndicator(),
                          error: (_, _) => const SizedBox(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.spacing(16)),
              Consumer(
                builder: (context, ref, child) {
                  final progressAsync = ref.watch(userProgressProvider);
                  return progressAsync.when(
                    data: (progress) {
                      final p = progress.getEraProgress(era.id);
                      return Text(
                        '${(p * 100).toInt()}%',
                        style: TextStyle(
                          color: era.theme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: percentFontSize,
                        ),
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (_, _) => const SizedBox(),
                  );
                },
              ),
            ],
          ),
          if (selectedLocation != null) ...[
            SizedBox(height: responsive.spacing(10)),
            Row(
              children: [
                Icon(Icons.place, color: era.theme.accentColor, size: iconSize * 0.8),
                SizedBox(width: responsive.spacing(8)),
                Expanded(
                  child: Text(
                    '${AppLocalizations.of(context)!.exploration_selected_label}: ${selectedLocation.nameKorean}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: responsive.spacing(12)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.location_on, size: iconSize * 0.8),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.padding(10),
                    ),
                  ),
                  onPressed: () => _showExplorationListSheet(
                    context,
                    era,
                    locations,
                    initialTabIndex: 0,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.exploration_list_locations,
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.person, size: iconSize * 0.8),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.padding(10),
                    ),
                  ),
                  onPressed: () => _showExplorationListSheet(
                    context,
                    era,
                    locations,
                    initialTabIndex: 1,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.exploration_list_characters,
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationDetails(
    BuildContext context,
    WidgetRef ref,
    Location location,
    EraTheme theme,
  ) {
    // 새로운 장소 탐험 화면으로 이동 (TimePortal 전환 효과 적용)
    context.push('/era/${widget.eraId}/location/${location.id}');
  }


}

