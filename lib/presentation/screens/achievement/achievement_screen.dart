import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/data/datasources/static/achievement_data.dart';
import 'package:time_walker/presentation/screens/achievement/widgets/achievement_widgets.dart';


class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<AchievementCategory> _categories = [
    AchievementCategory.knowledge,
    AchievementCategory.dialogue,
    AchievementCategory.exploration,
    AchievementCategory.collection,
    AchievementCategory.special,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(userProgressProvider).valueOrNull;
    final unlockedIds = userProgress?.achievementIds ?? [];
    final allAchievements = AchievementData.all;
    
    // 전체 진행률 계산
    final totalCount = allAchievements.length;
    final unlockedCount = unlockedIds.length;
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: CustomScrollView(
        slivers: [
          // AppBar with progress
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E1E2C),
            flexibleSpace: FlexibleSpaceBar(
              background: AchievementHeader(
                totalCount: totalCount,
                unlockedCount: unlockedCount,
                progress: progress,
              ),
            ),
            title: const Text('업적'),
            centerTitle: true,
          ),
          
          // Category Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: AchievementTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white54,
                tabs: [
                  const Tab(text: '전체'),
                  ..._categories.map((c) => Tab(text: c.displayName)),
                ],
              ),
            ),
          ),
          
          // Achievement Grid
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 전체 탭
                AchievementGrid(
                  achievements: allAchievements,
                  unlockedIds: unlockedIds,
                ),
                // 카테고리별 탭
                ..._categories.map((category) => AchievementGrid(
                  achievements: AchievementData.getByCategory(category),
                  unlockedIds: unlockedIds,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
