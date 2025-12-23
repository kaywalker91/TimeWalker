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
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/tutorial_overlay.dart';

class EraExplorationScreen extends ConsumerStatefulWidget {
  final String eraId;

  const EraExplorationScreen({super.key, required this.eraId});

  @override
  ConsumerState<EraExplorationScreen> createState() =>
      _EraExplorationScreenState();
}

class _EraExplorationScreenState extends ConsumerState<EraExplorationScreen> {
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
  static const MapBounds _threeKingdomsBounds = MapBounds(
    minLatitude: 34.0,
    maxLatitude: 42.5,
    minLongitude: 124.0,
    maxLongitude: 130.8,
  );
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
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eraAsync = ref.watch(eraByIdProvider(widget.eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(widget.eraId));
    final userProgressAsync = ref.watch(userProgressProvider);

    // BGM 시작 (시대별 BGM)
    final currentTrack = ref.watch(currentBgmTrackProvider);
    final eraBgm = AudioConstants.getBGMForEra(widget.eraId);
    if (currentTrack != eraBgm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bgmControllerProvider.notifier).playEraBgm(widget.eraId);
      });
    }

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
          error: (_, __) => const Text('Error'),
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
                error: (_, __) => const Center(child: Text('Error loading progress')),
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
    final entries = <_MarkerEntry>[];

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
        _MarkerEntry(
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
    final lines = <_MarkerLine>[];
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
            _MarkerLine(
              start: entry.position,
              end: calloutPosition,
              color: entry.baseColor
                  .withValues(alpha: entry.isDimmed ? 0.25 : 0.6),
            ),
          );
        }

        widgets.add(
          _LocationAnchor(
            left: entry.position.dx,
            top: entry.position.dy,
            size: markerSize * _anchorDotScale,
            color: entry.baseColor,
            isDimmed: entry.isDimmed,
            isSelected: entry.isSelected,
          ),
        );

        widgets.add(
          _LocationMarker(
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
              painter: _MarkerConnectionPainter(lines),
            ),
          ),
        ...widgets,
      ],
    );
  }

  MapCoordinates _resolveLocationPosition(Location location, Era era) {
    if (era.id == 'korea_three_kingdoms' &&
        location.latitude != null &&
        location.longitude != null) {
      return MapProjection.projectNormalized(
        latitude: location.latitude!,
        longitude: location.longitude!,
        bounds: _threeKingdomsBounds,
      );
    }
    return location.position;
  }

  List<List<_MarkerEntry>> _groupMarkerEntries(
    List<_MarkerEntry> entries,
    double spacing,
  ) {
    final remaining = [...entries];
    final groups = <List<_MarkerEntry>>[];

    while (remaining.isNotEmpty) {
      final seed = remaining.removeLast();
      final group = <_MarkerEntry>[seed];
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

  Offset _averagePosition(List<_MarkerEntry> entries) {
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
        .clamp(margin, mapSize.width - margin) as double;
    final clampedY = position.dy
        .clamp(margin, mapSize.height - margin) as double;
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
                _StatusLegend(color: Colors.amber, label: '탐험 가능'),
                _StatusLegend(color: Colors.blue, label: '진행 중'),
                _StatusLegend(color: Colors.green, label: '완료'),
                _StatusLegend(color: Colors.grey, label: '잠김'),
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
      builder: (context) => _ExplorationListSheet(
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
                          error: (_, __) => const SizedBox(),
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
                    error: (_, __) => const SizedBox(),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _LocationDetailSheet(location: location, theme: theme),
    );
  }

  void _showClusterLocationsSheet(
    BuildContext context,
    WidgetRef ref,
    Era era,
    List<Location> locations,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    final sortedLocations = [...locations]
      ..sort((a, b) => a.nameKorean.compareTo(b.nameKorean));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = era.theme;
        final height = MediaQuery.of(sheetContext).size.height * 0.45;

        return SizedBox(
          height: height,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E2C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .exploration_list_locations,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${sortedLocations.length})',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: sortedLocations.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final location = sortedLocations[index];
                      final isLocked = !location.isAccessible;
                      final kingdom = location.kingdom;
                      final accentColor =
                          _kingdomMeta[kingdom]?.color ??
                              theme.accentColor;

                      return ListTile(
                        leading: Icon(
                          isLocked ? Icons.lock : Icons.place,
                          color: isLocked
                              ? Colors.grey
                              : accentColor,
                        ),
                        title: Text(
                          location.nameKorean,
                          style: TextStyle(
                            color: isLocked
                                ? Colors.grey
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          location.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isLocked
                                ? Colors.grey[700]
                                : Colors.white70,
                          ),
                        ),
                        onTap: () {
                          if (isLocked) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .exploration_location_locked,
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.of(sheetContext).pop();
                          Future.microtask(() {
                            if (!mounted) return;
                            setState(() {
                              _selectedLocation = location;
                            });
                            _showLocationDetails(
                              context,
                              ref,
                              location,
                              theme,
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KingdomMeta {
  final String label;
  final Color color;

  const KingdomMeta({required this.label, required this.color});
}

class TerritorySpec {
  final Offset center;
  final Size size;

  const TerritorySpec(this.center, this.size);
}

class KingdomTerritoryPainter extends CustomPainter {
  final Map<String, TerritorySpec> territories;
  final Map<String, KingdomMeta> kingdomMeta;
  final Set<String> activeKingdoms;

  const KingdomTerritoryPainter({
    required this.territories,
    required this.kingdomMeta,
    required this.activeKingdoms,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in territories.entries) {
      final meta = kingdomMeta[entry.key];
      if (meta == null) {
        continue;
      }
      final isActive = activeKingdoms.contains(entry.key);
      final rect = Rect.fromCenter(
        center: Offset(
          entry.value.center.dx * size.width,
          entry.value.center.dy * size.height,
        ),
        width: entry.value.size.width * size.width,
        height: entry.value.size.height * size.height,
      );
      final radius = Radius.circular(rect.shortestSide * 0.18);
      final fillPaint = Paint()
        ..color = meta.color.withValues(alpha: isActive ? 0.12 : 0.05)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = meta.color.withValues(alpha: isActive ? 0.35 : 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), fillPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant KingdomTerritoryPainter oldDelegate) {
    return oldDelegate.activeKingdoms != activeKingdoms ||
        oldDelegate.territories != territories ||
        oldDelegate.kingdomMeta != kingdomMeta;
  }
}

class _MarkerEntry {
  final Location location;
  final Offset position;
  final Color baseColor;
  final bool isDimmed;
  final bool isSelected;

  const _MarkerEntry({
    required this.location,
    required this.position,
    required this.baseColor,
    required this.isDimmed,
    required this.isSelected,
  });
}

class _MarkerLine {
  final Offset start;
  final Offset end;
  final Color color;

  const _MarkerLine({
    required this.start,
    required this.end,
    required this.color,
  });
}

class _MarkerConnectionPainter extends CustomPainter {
  final List<_MarkerLine> lines;

  const _MarkerConnectionPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MarkerConnectionPainter oldDelegate) {
    return oldDelegate.lines != lines;
  }
}

class _LocationAnchor extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final bool isDimmed;
  final bool isSelected;

  const _LocationAnchor({
    required this.left,
    required this.top,
    required this.size,
    required this.color,
    required this.isDimmed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isDimmed ? 0.35 : 1.0;
    final indicatorSize = isSelected ? size * 1.6 : size;

    return Positioned(
      left: left - indicatorSize * 0.5,
      top: top - indicatorSize * 0.5,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.9),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: indicatorSize * 0.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: indicatorSize * 1.2,
                spreadRadius: indicatorSize * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final Location location;
  final Color baseColor;
  final double left;
  final double top;
  final double markerSize;
  final bool isDimmed;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback? onTap;

  const _LocationMarker({
    required this.location,
    required this.baseColor,
    required this.left,
    required this.top,
    required this.markerSize,
    required this.isDimmed,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !location.isAccessible;
    final iconSize = markerSize * 0.56; // proportional
    final opacity = isDimmed ? 0.25 : 1.0;
    final markerColor = isLocked ? Colors.grey[800]! : baseColor;
    final borderColor = isLocked ? Colors.grey : baseColor;
    final icon = isLocked
        ? Icons.lock
        : location.isCompleted
            ? Icons.check
            : Icons.place;

    return Positioned(
      left: left - markerSize * 0.8,
      top: top - markerSize * 0.8,
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.exploration_location_locked),
                ),
              );
              return;
            }
            if (onTap != null) {
              onTap!();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Marker Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Container(
                      width: markerSize * 1.35,
                      height: markerSize * 1.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.6),
                          width: markerSize * 0.08,
                        ),
                      ),
                    ),
                  Container(
                    width: markerSize,
                    height: markerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: markerColor,
                      border: Border.all(
                        color: borderColor,
                        width: markerSize * 0.06,
                      ),
                      boxShadow: isLocked
                          ? []
                          : [
                              BoxShadow(
                                color: borderColor.withValues(alpha: 0.5),
                                blurRadius: markerSize * 0.3,
                                spreadRadius: markerSize * 0.04,
                              ),
                            ],
                    ),
                    child: Icon(icon, color: Colors.white, size: iconSize),
                  ),
                ],
              ),
              if (showLabel) ...[
                SizedBox(height: markerSize * 0.16),
                // Label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: markerSize * 0.16,
                    vertical: markerSize * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    location.nameKorean,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: markerSize * 0.24,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplorationListSheet extends ConsumerWidget {
  final Era era;
  final List<Location> locations;
  final int initialTabIndex;
  final Map<String, KingdomMeta> kingdomMeta;
  final ValueChanged<Location> onLocationSelected;

  const _ExplorationListSheet({
    required this.era,
    required this.locations,
    required this.initialTabIndex,
    required this.kingdomMeta,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(characterListByEraProvider(era.id));

    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              TabBar(
                labelColor: era.theme.accentColor,
                indicatorColor: era.theme.accentColor,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.exploration_list_locations),
                  Tab(text: AppLocalizations.of(context)!.exploration_list_characters),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        final isLocked = !location.isAccessible;
                        final statusColor = location.isCompleted
                            ? Colors.green
                            : isLocked
                                ? Colors.grey
                                : Colors.amber;
                        final kingdom = location.kingdom;
                        final meta = kingdom != null ? kingdomMeta[kingdom] : null;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withValues(alpha: 0.2),
                            child: Icon(
                              isLocked ? Icons.lock : Icons.place,
                              color: statusColor,
                            ),
                          ),
                          title: Text(
                            location.nameKorean,
                            style: TextStyle(
                              color: isLocked ? Colors.grey : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              if (meta != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: meta.color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: meta.color.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  child: Text(
                                    meta.label,
                                    style: TextStyle(
                                      color: meta.color,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  location.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            location.isCompleted
                                ? Icons.check_circle
                                : isLocked
                                    ? Icons.lock_outline
                                    : Icons.arrow_forward_ios,
                            color: statusColor,
                            size: 18,
                          ),
                          onTap: () {
                            if (isLocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .exploration_location_locked,
                                  ),
                                ),
                              );
                              return;
                            }
                            onLocationSelected(location);
                          },
                        );
                      },
                    ),
                    charactersAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      data: (characters) {
                        if (characters.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .exploration_no_characters,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            final char = characters[index];
                            return _CharacterCard(
                              character: char,
                              theme: era.theme,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationDetailSheet extends ConsumerWidget {
  final Location location;
  final EraTheme theme;

  const _LocationDetailSheet({required this.location, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, you might want to fetch additional details here,
    // but the location object usually has what we need or we fetch characters.
    final charactersAsync = ref.watch(
      characterListByLocationProvider(location.id),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.nameKorean,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Large visual for location?
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.white10, // Placeholder
                      child: Icon(
                        Icons.travel_explore,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10),

              // Characters Section
              Expanded(
                child: charactersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (characters) {
                    if (characters.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.exploration_no_characters,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final char = characters[index];
                        return _CharacterCard(character: char, theme: theme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CharacterCard extends ConsumerWidget {
  final Character character;
  final EraTheme theme;

  const _CharacterCard({required this.character, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = !character.isAccessible;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked
              ? Colors.transparent
              : theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isLocked ? Colors.grey[700] : theme.primaryColor,
          backgroundImage: 
              isLocked ? null : AssetImage(character.portraitAsset),
          child: isLocked
              ? const Icon(Icons.lock, color: Colors.white30)
              : null, // Don't show text if image is loaded
        ),
        title: Text(
          isLocked ? AppLocalizations.of(context)!.common_unknown_character : character.nameKorean,
          style: TextStyle(
            color: isLocked ? Colors.grey : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          isLocked ? AppLocalizations.of(context)!.common_locked_status : character.title,
          style: TextStyle(
            color: isLocked ? Colors.grey[700] : theme.accentColor,
            fontSize: 12,
          ),
        ),
        trailing: isLocked
            ? null
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  // Navigate to Dialogue Screen
                  _openDialogue(context, ref);
                },
                child: Text(AppLocalizations.of(context)!.common_talk),
              ),
      ),
    );
  }

  Future<void> _openDialogue(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final dialogues =
          await ref.read(dialogueListByCharacterProvider(character.id).future);
      if (!context.mounted) return;
      if (dialogues.isNotEmpty) {
        AppRouter.goToDialogue(context, character.eraId, dialogues.first.id);
        return;
      }
    } catch (_) {
      if (!context.mounted) return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.exploration_no_dialogue),
      ),
    );
  }
}
