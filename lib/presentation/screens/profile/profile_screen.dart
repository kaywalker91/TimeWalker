import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_stat_widgets.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_header_widgets.dart';

/// 프로필 화면
/// 
/// "시간의 문" 테마 - 탐험가 프로필
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);
    final encyclopediaStatsAsync = ref.watch(encyclopediaListProvider);
    final responsive = context.responsive;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: userProgressAsync.when(
            data: (userProgress) {
              return encyclopediaStatsAsync.when(
                data: (allEntries) {
                  final totalEntries = allEntries.length;
                  final unlockedEntries = userProgress.unlockedFactIds.length +
                      userProgress.unlockedCharacterIds.length;

                  final collectionRate = totalEntries > 0 ? unlockedEntries / totalEntries : 0.0;
                  final explorationRate = userProgress.overallProgress;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAppBar(context),
                        Padding(
                          padding: EdgeInsets.all(responsive.padding(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 1. User Avatar & Rank
                              ProfileUserHeader(
                                userProgress: userProgress,
                                responsive: responsive,
                              ),
                              SizedBox(height: responsive.spacing(32)),

                              // 2. Rank Progress
                              ProfileRankProgress(
                                userProgress: userProgress,
                                responsive: responsive,
                              ),
                              SizedBox(height: responsive.spacing(32)),

                              // 3. Stats Dashboard
                              _buildStatCirclesLayout(
                                context,
                                userProgress,
                                explorationRate,
                                collectionRate,
                                responsive,
                              ),
                              SizedBox(height: responsive.spacing(48)),

                              // 4. Detailed Stats List
                              ProfileStatTile(
                                label: l10n.profile_stat_playtime,
                                value: userProgress.totalPlayTimeFormatted,
                                icon: Icons.timer,
                                responsive: responsive,
                              ),
                              ProfileStatTile(
                                label: l10n.profile_stat_eras,
                                value: l10n.profile_eras_count(userProgress.unlockedEraIds.length),
                                icon: Icons.history_edu,
                                responsive: responsive,
                              ),
                              ProfileStatTile(
                                label: l10n.profile_stat_dialogues,
                                value: '${userProgress.completedDialogueIds.length}',
                                icon: Icons.chat_bubble_outline,
                                responsive: responsive,
                              ),
                            ],
                          ),
                        ),
                      ],
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
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.profile_title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: AppColors.iconPrimary),
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCirclesLayout(
    BuildContext context,
    dynamic userProgress,
    double explorationRate,
    double collectionRate,
    ResponsiveUtils responsive,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
    final statCircles = [
      CircularStatWidget(
        label: l10n.profile_stat_exploration,
        progress: explorationRate,
        color: AppColors.info,
        icon: Icons.map,
        responsive: responsive,
      ),
      CircularStatWidget(
        label: l10n.profile_stat_collection,
        progress: collectionRate,
        color: AppColors.secondary,
        icon: Icons.book,
        responsive: responsive,
      ),
      CircularStatWidget(
        label: l10n.profile_stat_knowledge,
        progress: (userProgress.totalKnowledge / 1000).clamp(0.0, 1.0),
        color: AppColors.primary,
        icon: Icons.lightbulb,
        overrideText: userProgress.totalKnowledge.toString(),
        responsive: responsive,
      ),
    ];

    if (responsive.isLandscape || responsive.deviceType == DeviceType.tablet) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: statCircles,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: responsive.spacing(16),
      runSpacing: responsive.spacing(16),
      children: statCircles,
    );
  }
}
