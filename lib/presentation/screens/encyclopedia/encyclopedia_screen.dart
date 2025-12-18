import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class EncyclopediaScreen extends ConsumerStatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  ConsumerState<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends ConsumerState<EncyclopediaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<EntryType> _tabs = EntryType.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryListAsync = ref.watch(encyclopediaListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Encyclopedia'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: 'All'),
            ..._tabs.map((type) => Tab(
                  icon: Text(type.icon),
                  text: type.displayName,
                )),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2C),
          // TODO: Add background texture
        ),
        child: entryListAsync.when(
          data: (entries) {
            return userProgressAsync.when(
              data: (userProgress) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGrid(entries, userProgress),
                    ..._tabs.map((type) {
                      final filtered = entries
                          .where((e) => e.type == type)
                          .toList();
                      return _buildGrid(filtered, userProgress);
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildGrid(List<EncyclopediaEntry> entries, userProgress) {
    if (entries.isEmpty) {
      return const Center(child: Text('No entries found.', style: TextStyle(color: Colors.white54)));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final crossAxisCount = responsive.gridColumns(phoneColumns: 2, tabletColumns: 3, desktopColumns: 4);
        final padding = responsive.padding(16);
        final spacing = responsive.spacing(16);
        
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(padding, 120, padding, padding),
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

            return _EntryCard(entry: entry, isUnlocked: isUnlocked, responsive: responsive);
          },
        );
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  final EncyclopediaEntry entry;
  final bool isUnlocked;
  final ResponsiveUtils responsive;

  const _EntryCard({
    required this.entry,
    required this.isUnlocked,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final titleFontSize = responsive.fontSize(16);
    final badgeFontSize = responsive.fontSize(10);
    final summaryFontSize = responsive.fontSize(11);
    final iconSize = responsive.iconSize(40);
    final cardPadding = responsive.padding(12);
    
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          AppRouter.goToEncyclopediaEntry(context, entry.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This entry is not yet discovered! Explore more to unlock.')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? const Color(0xFF2C2C3E) : Colors.black45,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? Colors.amber.withValues(alpha: 0.3) : Colors.white10,
            width: 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image / Icon
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.black26,
                ),
                child: isUnlocked
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          entry.thumbnailAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.image_not_supported, color: Colors.white24, size: iconSize),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white12,
                          size: iconSize,
                        ),
                      ),
              ),
            ),
            // Text Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.padding(6),
                            vertical: responsive.padding(2),
                          ),
                          decoration: BoxDecoration(
                            color: isUnlocked ? Colors.amber.withValues(alpha: 0.2) : Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            entry.type.displayName,
                            style: TextStyle(
                              color: isUnlocked ? Colors.amber : Colors.grey,
                              fontSize: badgeFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(6)),
                        Text(
                          isUnlocked ? entry.titleKorean : '???',
                          style: TextStyle(
                            color: isUnlocked ? Colors.white : Colors.grey,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (isUnlocked)
                      Flexible( // Use Flexible to allow text to shrink
                        child: Text(
                          entry.summary,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: summaryFontSize,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
