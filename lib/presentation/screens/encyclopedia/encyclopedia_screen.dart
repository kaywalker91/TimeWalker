import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 도감 화면
/// 
/// "시간의 문" 테마 - 영겁의 기록소 (Archives of Eternity)
/// - 신비로운 분위기의 BGM과 배경
/// - 순차적으로 등장하는 카드 애니메이션
class EncyclopediaScreen extends ConsumerStatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  ConsumerState<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends ConsumerState<EncyclopediaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<EntryType> _tabs = EntryType.values;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[EncyclopediaScreen] initState');
    _tabController = TabController(length: _tabs.length + 1, vsync: this);
    
    // BGM 시작 (도감 BGM) - 한 번만 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmEncyclopedia) {
        ref.read(bgmControllerProvider.notifier).playEncyclopediaBgm();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('[EncyclopediaScreen] dispose');
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryListAsync = ref.watch(encyclopediaListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);
    final allCharactersAsync = ref.watch(allCharactersProvider);

    return Scaffold(
      extendBodyBehindAppBar: true, // 그래디언트 배경이 앱바까지 올라오도록
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 커스텀 앱바
              _buildAppBar(context),
              
              // 탭바
              _buildTabBar(context),
              
              // 콘텐츠
              Expanded(
                child: entryListAsync.when(
                  data: (entries) {
                    return userProgressAsync.when(
                      data: (userProgress) {
                        // 캐릭터 이미지 맵
                        final characterPortraits = allCharactersAsync.maybeWhen(
                          data: (characters) => {
                            for (final c in characters) c.id: c.portraitAsset
                          },
                          orElse: () => <String, String>{},
                        );
                        
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            _buildGrid(context, entries, userProgress, characterPortraits),
                            ..._tabs.map((type) {
                              final filtered = entries
                                  .where((e) => e.type == type)
                                  .toList();
                              return _buildGrid(context, filtered, userProgress, characterPortraits);
                            }),
                          ],
                        );
                      },
                      loading: () => _buildLoadingState(),
                      error: (e, s) => _buildErrorState('Error: $e'),
                    );
                  },
                  loading: () => _buildLoadingState(),
                  error: (e, s) => _buildErrorState('Error: $e'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // 뒤로가기 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          
          // 타이틀 (Glow Effect)
          Expanded(
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppGradients.goldenText.createShader(bounds),
                  child: const Icon(Icons.auto_stories, color: AppColors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.menu_encyclopedia,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    shadows: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkOverlay.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        dividerColor: AppColors.transparent,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        tabs: [
          Tab(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(AppLocalizations.of(context)!.quiz_category_all),
            ),
          ),
          ..._tabs.map((type) => Tab(
                height: 36,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(type.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(type.displayName),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const Center(child: CommonLoadingState(message: '고대의 기록을 불러오는 중...'));
  }
  
  Widget _buildErrorState(String message) {
    return Center(child: CommonErrorState(message: message, showRetryButton: false));
  }

  Widget _buildGrid(BuildContext context, List<EncyclopediaEntry> entries, userProgress, Map<String, String> characterPortraits) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textDisabled.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              '기록이 존재하지 않습니다.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final sortedEntries = _sortEntriesByDiscovery(entries, userProgress);

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final crossAxisCount = responsive.gridColumns(phoneColumns: 2, tabletColumns: 3, desktopColumns: 4);
        final padding = responsive.padding(16);
        final spacing = responsive.spacing(16);
        
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(padding, padding / 2, padding, padding * 2),
          cacheExtent: 300.0, // 화면 밖 300px까지 사전 렌더링
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.isSmallPhone ? 0.62 : 0.68,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: sortedEntries.length,
          itemBuilder: (context, index) {
            final entry = sortedEntries[index];
            final isUnlocked = _isEntryUnlocked(entry, userProgress);
            final discoveryDate = _getEntryDiscoveryDate(entry, userProgress);
            
            String? characterPortrait;
            for (final relatedId in entry.relatedEntryIds) {
              if (characterPortraits.containsKey(relatedId)) {
                characterPortrait = characterPortraits[relatedId];
                break;
              }
            }

            // Staggered Animation Wrapper
            return _StaggeredEntryItem(
              index: index,
              columnCount: crossAxisCount,
              child: EncyclopediaEntryCard(
                entry: entry, 
                isUnlocked: isUnlocked, 
                responsive: responsive,
                discoveredAt: discoveryDate,
                characterPortraitAsset: characterPortrait,
              ),
            );
          },
        );
      },
    );
  }

  bool _isEntryUnlocked(EncyclopediaEntry entry, userProgress) {
    if (userProgress.unlockedFactIds.contains(entry.id) ||
        userProgress.unlockedCharacterIds.contains(entry.id) ||
        userProgress.isEncyclopediaDiscovered(entry.id)) {
      return true;
    }
    for (final relatedId in entry.relatedEntryIds) {
      if (userProgress.unlockedCharacterIds.contains(relatedId) ||
          userProgress.isEncyclopediaDiscovered(relatedId)) {
        return true;
      }
    }
    return false;
  }

  DateTime? _getEntryDiscoveryDate(EncyclopediaEntry entry, userProgress) {
    DateTime? discoveryDate = userProgress.getEncyclopediaDiscoveryDate(entry.id);
    if (discoveryDate != null) return discoveryDate;
    
    for (final relatedId in entry.relatedEntryIds) {
      discoveryDate = userProgress.getEncyclopediaDiscoveryDate(relatedId);
      if (discoveryDate != null) return discoveryDate;
    }
    return null;
  }

  List<EncyclopediaEntry> _sortEntriesByDiscovery(List<EncyclopediaEntry> entries, userProgress) {
    final unlockedEntries = <EncyclopediaEntry>[];
    final lockedEntries = <EncyclopediaEntry>[];
    
    for (final entry in entries) {
      if (_isEntryUnlocked(entry, userProgress)) {
        unlockedEntries.add(entry);
      } else {
        lockedEntries.add(entry);
      }
    }
    
    unlockedEntries.sort((a, b) {
      final dateA = _getEntryDiscoveryDate(a, userProgress);
      final dateB = _getEntryDiscoveryDate(b, userProgress);
      
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      
      return dateB.compareTo(dateA);
    });
    
    return [...unlockedEntries, ...lockedEntries];
  }
}

/// 순차적 등장 애니메이션을 위한 위젯
class _StaggeredEntryItem extends StatefulWidget {
  final int index;
  final int columnCount;
  final Widget child;

  const _StaggeredEntryItem({
    required this.index,
    required this.columnCount,
    required this.child,
  });

  @override
  State<_StaggeredEntryItem> createState() => _StaggeredEntryItemState();
}

class _StaggeredEntryItemState extends State<_StaggeredEntryItem> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // 아래에서 위로
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Stagger Delay
    // 화면에 보이는 아이템(예: 8~12개) 이후는 딜레이를 많이 주지 않도록 상한선 설정
    // index가 커질수록 딜레이가 무한히 늘어나는 것을 방지하기 위해 modulo 연산 또는 캡핑 사용
    final delayIndex = widget.index < 20 ? widget.index : 20; 
    final delay = delayIndex * 50; 
    
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
