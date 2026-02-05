import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/character_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_models.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_character_card.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_stat_circle.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_search_bar.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/compact_location_tile.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// 탐험 목록 바텀시트
///
/// 장소 진행 현황 탭과 인물 목록 탭을 제공합니다.
class ExplorationListSheet extends ConsumerStatefulWidget {
  final Era era;
  final List<Location> locations;
  final int initialTabIndex;
  final Map<String, KingdomMeta> kingdomMeta;
  final ValueChanged<Location> onLocationSelected;

  const ExplorationListSheet({
    super.key,
    required this.era,
    required this.locations,
    this.initialTabIndex = 0,
    required this.kingdomMeta,
    required this.onLocationSelected,
  });

  @override
  ConsumerState<ExplorationListSheet> createState() => _ExplorationListSheetState();
}

class _ExplorationListSheetState extends ConsumerState<ExplorationListSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  LocationFilter _currentFilter = LocationFilter.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(characterListByEraProvider(widget.era.id));
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkSheet,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildTabBar(l10n),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProgressTab(scrollController, context),
                    charactersAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      data: (characters) => _buildCharacterList(scrollController, characters, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey600,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations? l10n) {
    return TabBar(
      controller: _tabController,
      indicatorColor: widget.era.theme.primaryColor,
      labelColor: AppColors.white,
      unselectedLabelColor: AppColors.grey,
      tabs: [
        Tab(
          icon: const Icon(Icons.analytics_outlined, size: 18),
          text: l10n?.exploration_tab_progress ?? '진행 현황',
        ),
        Tab(
          icon: const Icon(Icons.people_outline, size: 18),
          text: l10n?.exploration_tab_characters ?? '인물',
        ),
      ],
    );
  }

  Widget _buildProgressTab(ScrollController scrollController, BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final completedCount = widget.locations.where((l) => l.status == ContentStatus.completed).length;
    final inProgressCount = widget.locations.where((l) => l.status == ContentStatus.inProgress).length;
    final availableCount = widget.locations.where((l) => l.status == ContentStatus.available).length;
    final lockedCount = widget.locations.where((l) => l.status == ContentStatus.locked).length;
    final totalCount = widget.locations.length;

    final filteredLocations = _getFilteredLocations();

    return Column(
      children: [
        _buildStatsHeader(
          context: context,
          completedCount: completedCount,
          inProgressCount: inProgressCount + availableCount,
          lockedCount: lockedCount,
          totalCount: totalCount,
        ),
        const SizedBox(height: 12),
        _buildFilterChips(context),
        const SizedBox(height: 8),
        ExplorationSearchBar(
          controller: _searchController,
          searchQuery: _searchQuery,
          onChanged: (value) => setState(() => _searchQuery = value),
          onClear: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filteredLocations.isEmpty
              ? Center(
                  child: Text(
                    l10n?.exploration_no_search_results ?? '검색 결과가 없습니다',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredLocations.length,
                  itemBuilder: (context, index) {
                    final location = filteredLocations[index];
                    return CompactLocationTile(
                      location: location,
                      theme: widget.era.theme,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onLocationSelected(location);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader({
    required BuildContext context,
    required int completedCount,
    required int inProgressCount,
    required int lockedCount,
    required int totalCount,
  }) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ExplorationStatCircle(
            label: l10n?.exploration_stats_completed ?? '완료',
            count: completedCount,
            total: totalCount,
            color: AppColors.success,
          ),
          ExplorationStatCircle(
            label: l10n?.exploration_stats_in_progress ?? '진행중',
            count: inProgressCount,
            total: totalCount,
            color: AppColors.warning,
          ),
          ExplorationStatCircle(
            label: l10n?.exploration_stats_locked ?? '잠김',
            count: lockedCount,
            total: totalCount,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: l10n?.exploration_filter_all ?? '전체',
            filter: LocationFilter.all,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: l10n?.exploration_filter_completed ?? '완료',
            filter: LocationFilter.completed,
            iconData: Icons.check_circle,
            iconColor: AppColors.success,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: l10n?.exploration_filter_in_progress ?? '진행중',
            filter: LocationFilter.inProgress,
            iconData: Icons.play_circle,
            iconColor: AppColors.warning,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: l10n?.exploration_filter_locked ?? '미탐험',
            filter: LocationFilter.locked,
            iconData: Icons.lock,
            iconColor: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required LocationFilter filter,
    IconData? iconData,
    Color? iconColor,
  }) {
    final isSelected = _currentFilter == filter;
    final accentColor = widget.era.theme.primaryColor;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(iconData, size: 14, color: isSelected ? AppColors.white : iconColor),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _currentFilter = filter);
      },
      selectedColor: accentColor.withValues(alpha: 0.3),
      checkmarkColor: AppColors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.grey400,
        fontSize: 12,
      ),
      backgroundColor: AppColors.white.withValues(alpha: 0.05),
      side: BorderSide(
        color: isSelected ? accentColor : AppColors.transparent,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  List<Location> _getFilteredLocations() {
    var locations = widget.locations;

    switch (_currentFilter) {
      case LocationFilter.completed:
        locations = locations.where((l) => l.status == ContentStatus.completed).toList();
        break;
      case LocationFilter.inProgress:
        locations = locations.where((l) =>
          l.status == ContentStatus.inProgress || l.status == ContentStatus.available
        ).toList();
        break;
      case LocationFilter.locked:
        locations = locations.where((l) => l.status == ContentStatus.locked).toList();
        break;
      case LocationFilter.all:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      locations = locations.where((l) =>
        l.nameKorean.toLowerCase().contains(query) ||
        l.name.toLowerCase().contains(query)
      ).toList();
    }

    return locations;
  }

  Widget _buildCharacterList(ScrollController scrollController, List<Character> characters, BuildContext context) {
    if (characters.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)?.exploration_no_characters ?? '인물이 없습니다.',
          style: const TextStyle(color: AppColors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final char = characters[index];
        return ExplorationCharacterCard(
          character: char,
          theme: widget.era.theme,
        );
      },
    );
  }
}

/// Location filter enum
enum LocationFilter {
  all,
  completed,
  inProgress,
  locked,
}
