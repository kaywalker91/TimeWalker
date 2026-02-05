import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_header_widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// 프로필 화면
/// 
/// "시간의 문" 테마 - 탐험가 프로필 (Identity Card)
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);
    final encyclopediaStatsAsync = ref.watch(encyclopediaListProvider);
    final responsive = context.responsive;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.profile_title,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            shadows: AppShadows.textMd,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.settings, color: AppColors.iconPrimary),
            ),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: Stack(
          children: [
            // Floating Particles Background
            const Positioned.fill(
              child: FloatingParticles(
                particleCount: 20,
                particleColor: AppColors.primary,
              ),
            ),
            
            SafeArea(
              child: userProgressAsync.when(
                data: (userProgress) {
                  return encyclopediaStatsAsync.when(
                    data: (allEntries) {
                      final totalEntries = allEntries.length;
                      final unlockedEntries = userProgress.unlockedFactIds.length +
                          userProgress.unlockedCharacterIds.length;

                      final collectionRate = totalEntries > 0 ? unlockedEntries / totalEntries : 0.0;
                      final explorationRate = userProgress.overallProgress;

                      return AnimationLimiter(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(responsive.padding(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(child: widget),
                              ),
                              children: [
                                // 1. Time Walker Identity Card
                                TimeWalkerIdCard(
                                  userProgress: userProgress,
                                  responsive: responsive,
                                ),
                                SizedBox(height: responsive.spacing(40)),

                                // 2. Rank Progress (Neon)
                                NeonRankProgress(
                                  userProgress: userProgress,
                                  responsive: responsive,
                                ),
                                SizedBox(height: responsive.spacing(40)),

                                // 3. Stats Dashboard (Grid)
                                _buildStatsGrid(
                                  context,
                                  userProgress,
                                  explorationRate,
                                  collectionRate,
                                  responsive,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const CommonLoadingState.simple(),
                    error: (_, _) => CommonErrorState(
                      message: l10n.common_error_stats_load,
                      showRetryButton: false,
                    ),
                  );
                },
                loading: () => const CommonLoadingState.simple(),
                error: (e, s) => CommonErrorState(message: 'Error: $e', showRetryButton: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    dynamic userProgress,
    double explorationRate,
    double collectionRate,
    ResponsiveUtils responsive,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
    // Data list for grid
    final stats = [
      {'label': l10n.profile_stat_exploration, 'value': '${(explorationRate * 100).toInt()}%', 'icon': Icons.map, 'color': AppColors.info},
      {'label': l10n.profile_stat_collection, 'value': '${(collectionRate * 100).toInt()}%', 'icon': Icons.book, 'color': AppColors.secondary},
      {'label': l10n.profile_stat_knowledge, 'value': '${userProgress.totalKnowledge}', 'icon': Icons.lightbulb, 'color': AppColors.primary},
      {'label': l10n.profile_stat_playtime, 'value': userProgress.totalPlayTimeFormatted, 'icon': Icons.timer, 'color': AppColors.teal},
      {'label': l10n.profile_stat_eras, 'value': '${userProgress.unlockedEraIds.length}', 'icon': Icons.history_edu, 'color': AppColors.orange},
      {'label': l10n.profile_stat_dialogues, 'value': '${userProgress.completedDialogueIds.length}', 'icon': Icons.chat_bubble_outline, 'color': AppColors.pink},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatGlassCard(
          label: stat['label'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildStatGlassCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
