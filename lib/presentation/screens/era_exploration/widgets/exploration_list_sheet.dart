import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/character_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_models.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_character_card.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// 탐험 목록 바텀시트
///
/// 장소 목록 탭과 인물 목록 탭을 제공하여 사용자가 쉽게 탐험 대상을 찾을 수 있게 합니다.
class ExplorationListSheet extends ConsumerStatefulWidget {
  final Era era;
  final List<Location> locations;
  final int initialTabIndex; // 0: 지역, 1: 인물
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(characterListByEraProvider(widget.era.id));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
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
              
              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: widget.era.theme.primaryColor,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: AppLocalizations.of(context)?.exploration_tab_locations ?? '장소'),
                  Tab(text: AppLocalizations.of(context)?.exploration_tab_characters ?? '인물'),
                ],
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Location List
                    _buildLocationList(scrollController, context),
                    
                    // Character List
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

  Widget _buildLocationList(ScrollController scrollController, BuildContext context) {
    if (widget.locations.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)?.exploration_no_locations ?? '장소가 없습니다.',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.locations.length,
      itemBuilder: (context, index) {
        final location = widget.locations[index];
        final isLocked = !location.isAccessible;
        
        return Card(
          color: Colors.white.withValues(alpha: 0.05),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isLocked 
                  ? Colors.transparent 
                  : widget.era.theme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey[800] : widget.era.theme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLocked ? Icons.lock : Icons.place,
                color: isLocked ? Colors.grey : widget.era.theme.primaryColor,
              ),
            ),
            title: Text(
              location.nameKorean,
              style: TextStyle(
                color: isLocked ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              isLocked ? (AppLocalizations.of(context)?.common_locked_status ?? '잠김') : location.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isLocked ? Colors.grey[700] : Colors.white70,
                fontSize: 12,
              ),
            ),
            trailing: isLocked 
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: isLocked ? null : () {
               Navigator.pop(context); // Close sheet
               widget.onLocationSelected(location);
            },
          ),
        );
      },
    );
  }

  Widget _buildCharacterList(ScrollController scrollController, List<Character> characters, BuildContext context) {
    if (characters.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)?.exploration_no_characters ?? '인물이 없습니다.',
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
        return ExplorationCharacterCard(
          character: char,
          theme: widget.era.theme,
        );
      },
    );
  }
}
