import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
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
import 'package:time_walker/presentation/screens/era_exploration/widgets/enhanced_timeline_gutter.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/location_story_card.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_hud_panel.dart';
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
  /// 화면 초기화 완료 여부 (BGM 중복 재생 방지)
  bool _isInitialized = false;
  final ScrollController _listController = ScrollController();

  // 삼국시대 왕국별 메타데이터 (역사적 색상 적용)
  static const Map<String, KingdomMeta> _kingdomMeta = {
    'goguryeo': KingdomMeta(
      label: '고구려',
      color: AppColors.kingdomGoguryeo,
      lightColor: AppColors.kingdomGoguryeoLight,
      glowColor: AppColors.kingdomGoguryeoGlow,
    ),
    'baekje': KingdomMeta(
      label: '백제',
      color: AppColors.kingdomBaekje,
      lightColor: AppColors.kingdomBaekjeLight,
      glowColor: AppColors.kingdomBaekjeGlow,
    ),
    'silla': KingdomMeta(
      label: '신라',
      color: AppColors.kingdomSilla,
      lightColor: AppColors.kingdomSillaLight,
      glowColor: AppColors.kingdomSillaGlow,
    ),
    'gaya': KingdomMeta(
      label: '가야',
      color: AppColors.kingdomGaya,
      lightColor: AppColors.kingdomGayaLight,
      glowColor: AppColors.kingdomGayaGlow,
    ),
  };

  static const List<_KingdomTab> _kingdomTabs = [
    _KingdomTab(id: 'goguryeo', label: '고구려'),
    _KingdomTab(id: 'baekje', label: '백제'),
    _KingdomTab(id: 'silla', label: '신라'),
    _KingdomTab(id: 'gaya', label: '가야'),
  ];

  /// 역사 서순에 맞춘 수동 정렬 (간략 버전)
  static const Map<String, List<String>> _kingdomTimelineOrder = {
    'goguryeo': [
      'goguryeo_palace', // 초기/중기
      'salsu', // 612
      'pyongyang_fortress', // 천도 이후
    ],
    'baekje': [
      'wiryeseong', // 초기
      'sabi', // 후기 천도
      'hwangsanbeol', // 멸망 직전
    ],
    'silla': [
      'gyeongju_palace', // 초기
      'cheomseongdae', // 선덕여왕 시기
    ],
    'gaya': [
      'gujibong', // 건국 신화
      'gimhae_palace', // 금관
      'goryeong_palace', // 대가야 후기
    ],
  };

  TabController? _kingdomTabController;
  Location? _selectedLocation;

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

    if (widget.eraId == 'korea_three_kingdoms') {
      _kingdomTabController = TabController(
        length: _kingdomTabs.length,
        vsync: this,
      )..addListener(() {
          setState(() {
            // 탭 변경 시 목록 상단으로 스크롤
            _listController.animateTo(
              0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
            );
          });
        });
    }
  }

  @override
  void dispose() {
    _kingdomTabController?.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eraAsync = ref.watch(eraByIdProvider(widget.eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(widget.eraId));
    final userProgressAsync = ref.watch(userProgressProvider);

    // BGM은 initState에서 처리됨 (build에서 중복 실행 방지)

    return Scaffold(
      extendBodyBehindAppBar: false,
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
                  final content = _buildExplorationView(context, ref, era, locations, userProgress);

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
    UserProgress userProgress,
  ) {
    final responsive = context.responsive;
    final isThreeKingdoms = era.id == 'korea_three_kingdoms';
    final visibleLocations =
        _filteredLocations(locations, isThreeKingdoms: isThreeKingdoms);
    final selectedLocation = _resolveSelectedLocation(visibleLocations);

    // HudPanel 높이 + 여백을 고려한 리스트 하단 패딩 (패널 축소로 90으로 조정)
    final hudPanelHeight = responsive.spacing(90);
    final listPadding = EdgeInsets.fromLTRB(
      responsive.padding(20),
      responsive.padding(12),
      responsive.padding(20),
      hudPanelHeight + MediaQuery.of(context).padding.bottom,
    );

    // 왕국별 파티클 색상 결정
    final particleColor = _getParticleColor(era, isThreeKingdoms);
    
    // 왕국별 분위기 오버레이 색상
    final kingdomOverlayColor = isThreeKingdoms && _kingdomTabController != null
        ? _kingdomMeta[_kingdomTabs[_kingdomTabController!.index].id]?.color
            ?? era.theme.accentColor
        : era.theme.accentColor;

    return Stack(
      children: [
        // === Background Layer: 그라데이션 + 파티클 ===
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.timePortal,
            ),
          ),
        ),
        
        // === Kingdom Atmosphere Overlay (Sprint 5) ===
        // 왕국 전환 시 분위기 색상이 부드럽게 변화
        if (isThreeKingdoms)
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kingdomOverlayColor.withValues(alpha: 0.12),
                    Colors.transparent,
                    kingdomOverlayColor.withValues(alpha: 0.06),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

        // === Floating Particles Layer ===
        Positioned.fill(
          child: RepaintBoundary(
            child: FloatingParticles(
              particleCount: 25,
              particleColor: particleColor,
              maxSize: 3.5,
            ),
          ),
        ),

        // === Content Layer: 탭 + 상태바 + 리스트 ===
        Column(
          children: [
            if (isThreeKingdoms)
              _buildKingdomTabs(context, era, locations),
            _buildStickyStatusBar(
              context: context,
              era: era,
              totalCount: locations.length,
              visibleCount: visibleLocations.length,
              selectedLocation: selectedLocation,
              responsive: responsive,
              userProgress: userProgress,
            ),
            Expanded(
              // 탭 전환 시 페이드 + 슬라이드 애니메이션
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
                  key: ValueKey(isThreeKingdoms
                      ? _kingdomTabController?.index ?? 0
                      : era.id),
                  controller: _listController,
                  padding: listPadding,
                  // 성능 최적화
                  cacheExtent: 200,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemCount: visibleLocations.length,
                  itemBuilder: (context, index) {
                    final location = visibleLocations[index];
                    final isFirst = index == 0;
                    final isLast = index == visibleLocations.length - 1;
                    final isSelected = selectedLocation?.id == location.id;

                    // 스태거드 진입 애니메이션 적용
                    return StaggeredListItem(
                      index: index,
                      baseDelay: const Duration(milliseconds: 100),
                      itemDelay: const Duration(milliseconds: 60),
                      child: _buildStoryNodeTile(
                        context: context,
                        era: era,
                        location: location,
                        isFirst: isFirst,
                        isLast: isLast,
                        isSelected: isSelected,
                        responsive: responsive,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: responsive.spacing(14)),
                ),
              ),
            ),
          ],
        ),

        // === Floating HudPanel Layer: 하단 고정 ===
        Positioned(
          left: responsive.padding(16),
          right: responsive.padding(16),
          bottom: MediaQuery.of(context).padding.bottom + responsive.padding(16),
          child: FadeInWidget(
            delay: const Duration(milliseconds: 300),
            slideOffset: const Offset(0, 0.5),
            child: EraHudPanel(
              era: era,
              locations: visibleLocations,
              selectedLocation: selectedLocation,
              onShowLocations: () => _showExplorationListSheet(
                context,
                era,
                locations,
                initialTabIndex: 0,
              ),
              onShowCharacters: () => _showExplorationListSheet(
                context,
                era,
                locations,
                initialTabIndex: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 시대/왕국에 맞는 파티클 색상 반환
  Color _getParticleColor(Era era, bool isThreeKingdoms) {
    if (isThreeKingdoms && _kingdomTabController != null) {
      final activeKingdom = _kingdomTabs[_kingdomTabController!.index].id;
      return _kingdomMeta[activeKingdom]?.color.withValues(alpha: 0.6) ??
             AppColors.primaryLight;
    }
    return era.theme.accentColor.withValues(alpha: 0.5);
  }

  Color _colorForLocation(Location location, Era era) {
    final kingdom = location.kingdom;
    final meta = kingdom != null ? _kingdomMeta[kingdom] : null;
    return meta?.color ?? era.theme.accentColor;
  }

  Widget _buildStoryNodeTile({
    required BuildContext context,
    required Era era,
    required Location location,
    required bool isFirst,
    required bool isLast,
    required bool isSelected,
    required ResponsiveUtils responsive,
  }) {
    final accent = _colorForLocation(location, era);
    final status = location.status;
    final isLocked = !status.isAccessible;
    final displayYear = location.displayYear;
    final kingdomLabel = location.kingdom != null
        ? (_kingdomMeta[location.kingdom!]?.label ?? location.kingdom!)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 강화된 타임라인 거터 (글로우 노드 + 연도 라벨)
        EnhancedTimelineGutter(
          accentColor: accent,
          status: status,
          isFirst: isFirst,
          isLast: isLast,
          isSelected: isSelected,
          displayYear: displayYear,
        ),
        SizedBox(width: responsive.spacing(8)),
        // 장소 스토리 카드 (배경 이미지 + 상태 배지)
        Expanded(
          child: LocationStoryCard(
            location: location,
            accentColor: accent,
            isSelected: isSelected,
            isLocked: isLocked,
            kingdomLabel: kingdomLabel,
            onTap: () {
              setState(() {
                _selectedLocation = location;
              });
              _showLocationDetails(context, ref, location, era.theme);
            },
          ),
        ),
      ],
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

  Widget _buildKingdomTabs(
    BuildContext context,
    Era era,
    List<Location> allLocations,
  ) {
    final controller = _kingdomTabController;
    if (controller == null) return const SizedBox.shrink();

    // 각 왕국별 장소 개수 계산
    final locationCounts = <String, int>{};
    for (final kingdom in ThreeKingdomsTabs.kingdoms) {
      locationCounts[kingdom.id] =
          allLocations.where((l) => l.kingdom == kingdom.id).length;
    }

    return EnhancedKingdomTabs(
      controller: controller,
      eraAccentColor: era.theme.accentColor,
      locationCounts: locationCounts,
      onTabChanged: (index) {
        setState(() {
          // 탭 변경 시 목록 상단으로 스크롤
          _listController.animateTo(
            0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        });
      },
    );
  }

  /// 미니멀 스티키 스테이터스 바 (진행률 바 중심)
  ///
  /// Sprint 5: 더 단순한 UI로 인지 부하 감소
  Widget _buildStickyStatusBar({
    required BuildContext context,
    required Era era,
    required int totalCount,
    required int visibleCount,
    required Location? selectedLocation,
    required ResponsiveUtils responsive,
    required UserProgress userProgress,
  }) {
    // 왕국별 악센트 색상
    final accentColor = _kingdomTabController != null
        ? _kingdomMeta[_kingdomTabs[_kingdomTabController!.index].id]?.color
            ?? era.theme.accentColor
        : era.theme.accentColor;
    
    final progress = userProgress.getEraProgress(era.id);
    final percent = (progress * 100).toInt();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        responsive.padding(16),
        responsive.padding(8),
        responsive.padding(16),
        responsive.padding(8),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        // 왕국 전환 시 미묘한 상단 테두리 색상 변화
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 미니멀 정보 행 (진행률만)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 표시 장소 수 (심플 텍스트)
              Text(
                '$visibleCount개 장소',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: responsive.fontSize(11),
                ),
              ),
              // 진행률 퍼센티지
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(10),
                  vertical: responsive.padding(3),
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  '진행률 $percent%',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: responsive.fontSize(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(8)),
          
          // 미니멀 진행률 바 (그라데이션 적용)
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.5),
                        accentColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
      final activeKingdomId = _kingdomTabs[tabIndex].id;
      filtered = locations.where((l) => l.kingdom == activeKingdomId).toList();
      final fallbackOrder = _kingdomTimelineOrder[activeKingdomId];
      filtered.sort((a, b) {
        final aOrder = a.timelineOrder ?? (fallbackOrder?.indexOf(a.id) ?? 9999);
        final bOrder = b.timelineOrder ?? (fallbackOrder?.indexOf(b.id) ?? 9999);
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

class _KingdomTab {
  final String id;
  final String label;

  const _KingdomTab({required this.id, required this.label});
}
