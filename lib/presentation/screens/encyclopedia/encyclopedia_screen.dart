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
/// "시간의 문" 테마 - 고대 도서관 느낌
class EncyclopediaScreen extends ConsumerStatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  ConsumerState<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends ConsumerState<EncyclopediaScreen>
    with SingleTickerProviderStateMixin {
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

    return Scaffold(
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
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            _buildGrid(context, entries, userProgress),
                            ..._tabs.map((type) {
                              final filtered = entries
                                  .where((e) => e.type == type)
                                  .toList();
                              return _buildGrid(context, filtered, userProgress);
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 뒤로가기 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          
          // 타이틀
          Expanded(
            child: Row(
              children: [
                Icon(Icons.menu_book, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.menu_encyclopedia,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // 검색 버튼 (향후 구현)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: AppColors.iconPrimary),
              onPressed: () {
                // TODO: 검색 기능
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.quiz_category_all),
          ..._tabs.map((type) => Tab(
                icon: Text(type.icon, style: const TextStyle(fontSize: 16)),
                text: type.displayName,
              )),
        ],
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const CommonLoadingState(
      message: '도감을 불러오는 중...',
    );
  }
  
  Widget _buildErrorState(String message) {
    return CommonErrorState(
      message: message,
      showRetryButton: false,
    );
  }

  Widget _buildGrid(BuildContext context, List<EncyclopediaEntry> entries, userProgress) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 64, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text(
              'No entries found.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final crossAxisCount = responsive.gridColumns(phoneColumns: 2, tabletColumns: 3, desktopColumns: 4);
        final padding = responsive.padding(16);
        final spacing = responsive.spacing(16);
        
        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.isSmallPhone ? 0.7 : 0.75,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final isUnlocked = userProgress.unlockedFactIds.contains(entry.id) || 
                               userProgress.unlockedCharacterIds.contains(entry.id);

            return EncyclopediaEntryCard(entry: entry, isUnlocked: isUnlocked, responsive: responsive);
          },
        );
      },
    );
  }
}
