import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/tutorial_overlay.dart';
import 'package:time_walker/presentation/widgets/common/animations/particles.dart';
import 'package:time_walker/presentation/widgets/common/animations/fade_scale_animations.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_widgets.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_hud_panel.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_status_bar.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/story_node_tile.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

class EraExplorationScreen extends ConsumerStatefulWidget {
  final String eraId;

  const EraExplorationScreen({super.key, required this.eraId});

  @override
  ConsumerState<EraExplorationScreen> createState() =>
      _EraExplorationScreenState();
}

class _EraExplorationScreenState extends ConsumerState<EraExplorationScreen>
    with TickerProviderStateMixin {
  bool _isInitialized = false;
  final ScrollController _listController = ScrollController();

  TabController? _kingdomTabController;
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    debugPrint('[EraExplorationScreen] initState - eraId=${widget.eraId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;

      final currentTrack = ref.read(currentBgmTrackProvider);
      final eraBgm = AudioConstants.getBGMForEra(widget.eraId);
      if (currentTrack != eraBgm) {
        ref.read(bgmControllerProvider.notifier).playEraBgm(widget.eraId);
      }
    });

    if (widget.eraId == 'korea_three_kingdoms') {
      _kingdomTabController = TabController(
        length: KingdomConfig.tabs.length,
        vsync: this,
      )..addListener(_onKingdomTabChanged);
    }
  }

  void _onKingdomTabChanged() {
    setState(() {
      _listController.animateTo(
        0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _kingdomTabController?.removeListener(_onKingdomTabChanged);
    _kingdomTabController?.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eraAsync = ref.watch(eraByIdProvider(widget.eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(widget.eraId));
    final userProgressAsync = ref.watch(userProgressProvider);
    final layoutSpec = EraExplorationLayoutSpec.fromContext(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(context, eraAsync),
      body: eraAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (era) {
          if (era == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.exploration_era_not_found,
              ),
            );
          }

          return locationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.exploration_location_error(err.toString()),
              ),
            ),
            data: (locations) => _buildWithUserProgress(
              context,
              era,
              locations,
              userProgressAsync,
              layoutSpec,
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        context: context,
        eraAsync: eraAsync,
        locationsAsync: locationsAsync,
        layoutSpec: layoutSpec,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AsyncValue<Era?> eraAsync,
  ) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      title: eraAsync.when(
        data: (era) => Text(
          era?.nameKorean ??
              AppLocalizations.of(context)!.exploration_title_default,
          style: const TextStyle(
            shadows: [
              Shadow(
                blurRadius: 4,
                color: AppColors.black,
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
            context.go(AppRouter.worldMap);
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showExplorationHelp(context),
        ),
      ],
    );
  }

  Widget _buildWithUserProgress(
    BuildContext context,
    Era era,
    List<Location> locations,
    AsyncValue<UserProgress> userProgressAsync,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    return userProgressAsync.when(
      data: (userProgress) {
        final showTutorial = !userProgress.hasCompletedTutorial;
        final content = _buildExplorationView(
          context,
          era,
          locations,
          userProgress,
          layoutSpec,
        );

        if (showTutorial) {
          return TutorialOverlay(
            message: AppLocalizations.of(context)!.exploration_tutorial_msg,
            onDismiss: () async {
              final newProgress = userProgress.copyWith(
                hasCompletedTutorial: true,
              );
              await ref
                  .read(userProgressRepositoryProvider)
                  .saveUserProgress(newProgress);
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
  }

  Widget _buildExplorationView(
    BuildContext context,
    Era era,
    List<Location> locations,
    UserProgress userProgress,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    final responsive = context.responsive;
    final isThreeKingdoms = era.id == 'korea_three_kingdoms';
    final visibleLocations = _filteredLocations(
      locations,
      isThreeKingdoms: isThreeKingdoms,
    );
    final selectedLocation = _resolveSelectedLocation(visibleLocations);

    final listPadding = EdgeInsets.fromLTRB(
      responsive.padding(20),
      responsive.padding(12),
      responsive.padding(20),
      layoutSpec.listBottomSafePadding + MediaQuery.of(context).padding.bottom,
    );

    final particleColor = _getParticleColor(era, isThreeKingdoms);
    final kingdomOverlayColor = isThreeKingdoms && _kingdomTabController != null
        ? KingdomConfig
                  .meta[KingdomConfig.tabs[_kingdomTabController!.index].id]
                  ?.color ??
              era.theme.accentColor
        : era.theme.accentColor;

    return Stack(
      children: [
        _buildBackgroundLayer(),
        if (isThreeKingdoms) _buildKingdomAtmosphere(kingdomOverlayColor),
        _buildParticleLayer(particleColor),
        _buildContentLayer(
          context,
          era,
          locations,
          visibleLocations,
          selectedLocation,
          userProgress,
          isThreeKingdoms,
          listPadding,
          responsive,
          layoutSpec,
        ),
      ],
    );
  }

  Widget _buildBackgroundLayer() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(gradient: AppGradients.timePortal),
      ),
    );
  }

  Widget _buildKingdomAtmosphere(Color kingdomOverlayColor) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kingdomOverlayColor.withValues(alpha: 0.12),
              AppColors.transparent,
              kingdomOverlayColor.withValues(alpha: 0.06),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildParticleLayer(Color particleColor) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: FloatingParticles(
          particleCount: 25,
          particleColor: particleColor,
          maxSize: 3.5,
        ),
      ),
    );
  }

  Widget _buildContentLayer(
    BuildContext context,
    Era era,
    List<Location> allLocations,
    List<Location> visibleLocations,
    Location? selectedLocation,
    UserProgress userProgress,
    bool isThreeKingdoms,
    EdgeInsets listPadding,
    ResponsiveUtils responsive,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    return Column(
      children: [
        if (isThreeKingdoms)
          _buildKingdomTabs(context, era, allLocations, layoutSpec),
        EraStatusBar(
          era: era,
          totalCount: allLocations.length,
          visibleCount: visibleLocations.length,
          selectedLocation: selectedLocation,
          userProgress: userProgress,
          currentKingdomIndex: _kingdomTabController?.index,
          layoutSpec: layoutSpec,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: ListView.separated(
              key: ValueKey(
                isThreeKingdoms ? _kingdomTabController?.index ?? 0 : era.id,
              ),
              controller: _listController,
              padding: listPadding,
              cacheExtent: 200,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemCount: visibleLocations.length,
              itemBuilder: (context, index) {
                final location = visibleLocations[index];
                final isFirst = index == 0;
                final isLast = index == visibleLocations.length - 1;
                final isSelected = selectedLocation?.id == location.id;

                return StaggeredListItem(
                  index: index,
                  baseDelay: const Duration(milliseconds: 100),
                  itemDelay: const Duration(milliseconds: 60),
                  child: StoryNodeTile(
                    era: era,
                    location: location,
                    isFirst: isFirst,
                    isLast: isLast,
                    isSelected: isSelected,
                    layoutSpec: layoutSpec,
                    onTap: () {
                      setState(() {
                        _selectedLocation = location;
                      });
                      _showLocationDetails(context, location, era.theme);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: responsive.spacing(14)),
            ),
          ),
        ),
      ],
    );
  }

  Color _getParticleColor(Era era, bool isThreeKingdoms) {
    if (isThreeKingdoms && _kingdomTabController != null) {
      final activeKingdom = KingdomConfig.tabs[_kingdomTabController!.index].id;
      return KingdomConfig.meta[activeKingdom]?.color.withValues(alpha: 0.6) ??
          AppColors.primaryLight;
    }
    return era.theme.accentColor.withValues(alpha: 0.5);
  }

  Widget _buildKingdomTabs(
    BuildContext context,
    Era era,
    List<Location> allLocations,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    final controller = _kingdomTabController;
    if (controller == null) return const SizedBox.shrink();

    final locationCounts = <String, int>{};
    for (final kingdom in ThreeKingdomsTabs.kingdoms) {
      locationCounts[kingdom.id] = allLocations
          .where((l) => l.kingdom == kingdom.id)
          .length;
    }

    return EnhancedKingdomTabs(
      controller: controller,
      eraAccentColor: era.theme.accentColor,
      locationCounts: locationCounts,
      layoutSpec: layoutSpec,
      onTabChanged: (index) {
        setState(() {
          _listController.animateTo(
            0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        });
      },
    );
  }

  Widget? _buildBottomNavigationBar({
    required BuildContext context,
    required AsyncValue<Era?> eraAsync,
    required AsyncValue<List<Location>> locationsAsync,
    required EraExplorationLayoutSpec layoutSpec,
  }) {
    return eraAsync.when(
      loading: () => null,
      error: (_, _) => null,
      data: (era) {
        if (era == null) return null;
        return locationsAsync.when(
          loading: () => null,
          error: (_, _) => null,
          data: (allLocations) {
            final responsive = context.responsive;
            final isThreeKingdoms = era.id == 'korea_three_kingdoms';
            final visibleLocations = _filteredLocations(
              allLocations,
              isThreeKingdoms: isThreeKingdoms,
            );
            final selectedLocation = _resolveSelectedLocation(visibleLocations);

            return SafeArea(
              top: false,
              minimum: EdgeInsets.fromLTRB(
                responsive.padding(16),
                responsive.padding(8),
                responsive.padding(16),
                responsive.padding(10),
              ),
              child: FadeInWidget(
                delay: const Duration(milliseconds: 300),
                slideOffset: const Offset(0, 0.2),
                child: EraHudPanel(
                  era: era,
                  locations: visibleLocations,
                  selectedLocation: selectedLocation,
                  layoutSpec: layoutSpec,
                  onShowLocations: () => _showExplorationListSheet(
                    context,
                    era,
                    allLocations,
                    initialTabIndex: 0,
                  ),
                  onShowCharacters: () => _showExplorationListSheet(
                    context,
                    era,
                    allLocations,
                    initialTabIndex: 1,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Location> _filteredLocations(
    List<Location> locations, {
    required bool isThreeKingdoms,
  }) {
    List<Location> filtered;

    if (isThreeKingdoms) {
      final controller = _kingdomTabController;
      final tabIndex = controller?.index ?? 0;
      final activeKingdomId = KingdomConfig.tabs[tabIndex].id;
      filtered = locations.where((l) => l.kingdom == activeKingdomId).toList();
      final fallbackOrder = KingdomConfig.timelineOrder[activeKingdomId];
      filtered.sort((a, b) {
        final aOrder =
            a.timelineOrder ?? (fallbackOrder?.indexOf(a.id) ?? 9999);
        final bOrder =
            b.timelineOrder ?? (fallbackOrder?.indexOf(b.id) ?? 9999);
        final cmp = aOrder.compareTo(bOrder);
        if (cmp != 0) return cmp;
        return (a.displayYear ?? '').compareTo(b.displayYear ?? '');
      });
      return filtered;
    }

    filtered = List<Location>.from(locations);
    filtered.sort((a, b) {
      final aOrder = a.timelineOrder ?? 9999;
      final bOrder = b.timelineOrder ?? 9999;
      final cmp = aOrder.compareTo(bOrder);
      if (cmp != 0) return cmp;
      return a.nameKorean.compareTo(b.nameKorean);
    });
    return filtered;
  }

  Location? _resolveSelectedLocation(List<Location> visibleLocations) {
    if (_selectedLocation != null &&
        visibleLocations.any((l) => l.id == _selectedLocation!.id)) {
      return _selectedLocation;
    }
    if (visibleLocations.isNotEmpty) {
      return visibleLocations.first;
    }
    return null;
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
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => ExplorationListSheet(
        era: era,
        locations: locations,
        initialTabIndex: initialTabIndex,
        kingdomMeta: KingdomConfig.meta,
        onLocationSelected: (location) {
          setState(() {
            _selectedLocation = location;
          });
          Navigator.of(context).pop();
          _showLocationDetails(context, location, era.theme);
        },
      ),
    );
  }

  void _showLocationDetails(
    BuildContext context,
    Location location,
    EraTheme theme,
  ) {
    context.push('/era/${widget.eraId}/location/${location.id}');
  }
}
