import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/player_avatars.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_header_widgets.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_layout_spec.dart';
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
    final settings = ref.watch(settingsProvider);
    final layoutSpec = ProfileLayoutSpec.fromContext(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(layoutSpec.itemGap),
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
              padding: EdgeInsets.all(layoutSpec.itemGap),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.settings, color: AppColors.iconPrimary),
            ),
            onPressed: () => context.push('/settings'),
          ),
          SizedBox(width: layoutSpec.microGap),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.timePortal),
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
                      final unlockedEntries =
                          userProgress.unlockedFactIds.length +
                          userProgress.unlockedCharacterIds.length;

                      final collectionRate = totalEntries > 0
                          ? unlockedEntries / totalEntries
                          : 0.0;
                      final explorationRate = userProgress.overallProgress;

                      return AnimationLimiter(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            layoutSpec.pageHorizontal,
                            layoutSpec.pageTop,
                            layoutSpec.pageHorizontal,
                            layoutSpec.pageBottom,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(child: widget),
                              ),
                              children: [
                                // 1. Time Walker Identity Card
                                TimeWalkerIdCard(
                                  key: const Key('profile_id_card'),
                                  userProgress: userProgress,
                                  layoutSpec: layoutSpec,
                                  playerName: settings.playerName,
                                  playerAvatarIndex: settings.playerAvatarIndex,
                                ),
                                SizedBox(height: layoutSpec.sectionGap),

                                // 2. Profile Edit Section (이름 편집 + 아바타 선택)
                                _buildProfileEditSection(
                                  context,
                                  ref,
                                  settings,
                                  layoutSpec,
                                ),
                                SizedBox(height: layoutSpec.sectionGap),

                                // 2. Rank Progress (Neon)
                                NeonRankProgress(
                                  key: const Key('profile_rank_section'),
                                  userProgress: userProgress,
                                  layoutSpec: layoutSpec,
                                ),
                                SizedBox(height: layoutSpec.sectionGap),

                                // 3. Stats Dashboard (Grid)
                                _buildStatsGrid(
                                  context,
                                  userProgress,
                                  explorationRate,
                                  collectionRate,
                                  layoutSpec,
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
                error: (e, s) => CommonErrorState(
                  message: 'Error: $e',
                  showRetryButton: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    UserProgress userProgress,
    double explorationRate,
    double collectionRate,
    ProfileLayoutSpec layoutSpec,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // Data list for grid
    final stats = [
      {
        'label': l10n.profile_stat_exploration,
        'value': '${(explorationRate * 100).toInt()}%',
        'icon': Icons.map,
        'color': AppColors.info,
      },
      {
        'label': l10n.profile_stat_collection,
        'value': '${(collectionRate * 100).toInt()}%',
        'icon': Icons.book,
        'color': AppColors.secondary,
      },
      {
        'label': l10n.profile_stat_knowledge,
        'value': '${userProgress.totalKnowledge}',
        'icon': Icons.lightbulb,
        'color': AppColors.primary,
      },
      {
        'label': l10n.profile_stat_playtime,
        'value': userProgress.totalPlayTimeFormatted,
        'icon': Icons.timer,
        'color': AppColors.teal,
      },
      {
        'label': l10n.profile_stat_eras,
        'value': '${userProgress.unlockedEraIds.length}',
        'icon': Icons.history_edu,
        'color': AppColors.orange,
      },
      {
        'label': l10n.profile_stat_dialogues,
        'value': '${userProgress.completedDialogueIds.length}',
        'icon': Icons.chat_bubble_outline,
        'color': AppColors.pink,
      },
    ];

    return GridView.builder(
      key: const Key('profile_stats_grid'),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width >= 600 ? 3 : 2,
        mainAxisSpacing: layoutSpec.gridGap,
        crossAxisSpacing: layoutSpec.gridGap,
        childAspectRatio: layoutSpec.statsChildAspectRatio,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatGlassCard(
          label: stat['label'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
          layoutSpec: layoutSpec,
        );
      },
    );
  }

  Widget _buildStatGlassCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required ProfileLayoutSpec layoutSpec,
  }) {
    return Container(
      padding: EdgeInsets.all(layoutSpec.statCardPadding),
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
        children: [
          Container(
            padding: EdgeInsets.all(layoutSpec.itemGap / 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: layoutSpec.itemGap),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(height: layoutSpec.microGap),
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
            ),
          ),
        ],
      ),
    );
  }

  // ── 프로필 편집 섹션 ──

  Widget _buildProfileEditSection(
    BuildContext context,
    WidgetRef ref,
    GameSettings settings,
    ProfileLayoutSpec layoutSpec,
  ) {
    return Container(
      key: const Key('profile_edit_section'),
      padding: EdgeInsets.all(layoutSpec.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 편집 행
          Row(
            key: const Key('profile_edit_name_row'),
            children: [
              Icon(Icons.edit_note, color: AppColors.primary, size: 20),
              SizedBox(width: layoutSpec.itemGap),
              Text(
                '이름 변경',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                key: const Key('profile_name_edit_button'),
                onTap: () =>
                    _showNameEditDialog(context, ref, settings.playerName),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: EdgeInsets.symmetric(
                    horizontal: layoutSpec.clusterGap,
                    vertical: layoutSpec.itemGap,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        settings.playerName,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: layoutSpec.microGap),
                      Icon(Icons.edit, color: AppColors.primary, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: layoutSpec.clusterGap),
          // 아바타 선택
          Row(
            key: const Key('profile_avatar_title_row'),
            children: [
              Icon(Icons.face, color: AppColors.primary, size: 20),
              SizedBox(width: layoutSpec.itemGap),
              Text(
                '아바타 선택',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: layoutSpec.itemGap),
          SizedBox(
            key: const Key('profile_avatar_rail'),
            height: layoutSpec.avatarRailHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PlayerAvatars.count,
              itemBuilder: (context, index) {
                final isSelected = settings.playerAvatarIndex == index;
                return GestureDetector(
                  key: ValueKey<String>('profile_avatar_option_$index'),
                  onTap: () {
                    ref
                        .read(settingsProvider.notifier)
                        .updatePlayerAvatar(index);
                  },
                  child: Container(
                    width: layoutSpec.avatarSize,
                    height: layoutSpec.avatarSize,
                    margin: EdgeInsets.only(right: layoutSpec.itemGap),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.white.withValues(alpha: 0.15),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        PlayerAvatars.getAvatarPath(index),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 28,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white.withValues(alpha: 0.3),
                            ),
                            Text(
                              PlayerAvatars.labels[index],
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.white70,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('이름 변경', style: TextStyle(color: AppColors.white)),
        content: TextField(
          controller: controller,
          maxLength: 12,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: PlayerAvatars.defaultName,
            hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.3)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            counterStyle: TextStyle(
              color: AppColors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(settingsProvider.notifier).updatePlayerName(name);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('확인', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
