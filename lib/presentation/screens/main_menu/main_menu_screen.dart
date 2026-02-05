import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';
import 'package:time_walker/presentation/screens/main_menu/widgets/menu_button.dart';

/// 메인 메뉴 화면
/// 
/// "시간의 문" 컨셉 디자인 + 풍부한 애니메이션
class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[MainMenuScreen] initState');

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    // BGM 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;

      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmMainMenu) {
        ref.read(bgmControllerProvider.notifier).playMainMenuBgm();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('[MainMenuScreen] dispose');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 입자
            const FloatingParticles(
              particleCount: 25,
              particleColor: AppColors.starlight,
              maxSize: 2.5,
            ),

            // 메인 콘텐츠
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: responsive.spacing(50)),
                        _buildTitle(context, responsive),
                        SizedBox(height: responsive.spacing(20)),
                        const Spacer(),
                        _buildMenuButtons(context, responsive),
                        SizedBox(height: responsive.spacing(30)),
                        FadeInWidget(
                          delay: const Duration(milliseconds: 1000),
                          child: _buildVersionInfo(context),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ResponsiveUtils responsive) {
    final logoSize = responsive.isSmallPhone ? 80.0 : 100.0;

    return Column(
      children: [
        ScaleInWidget(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 600),
          child: PulseGlowWidget(
            glowColor: AppColors.primary,
            minGlow: 0.2,
            maxGlow: 0.5,
            duration: const Duration(seconds: 3),
            child: TimeLogo(
              size: logoSize,
              showGlow: true,
            ),
          ),
        ),
        SizedBox(height: responsive.spacing(20)),
        FadeInWidget(
          delay: const Duration(milliseconds: 300),
          slideOffset: const Offset(0, -0.5),
          child: GoldenShimmer(
            duration: const Duration(seconds: 4),
            child: TimeTitle(
              text: AppConstants.appName,
              fontSize: responsive.fontSize(24),
              letterSpacing: responsive.isSmallPhone ? 3 : 5,
            ),
          ),
        ),
        SizedBox(height: responsive.spacing(8)),
        FadeInWidget(
          delay: const Duration(milliseconds: 500),
          child: Text(
            AppLocalizations.of(context)!.app_tagline,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, ResponsiveUtils responsive) {
    final buttonSpacing = responsive.spacing(12);
    final horizontalPadding = responsive.padding(40);
    final l10n = AppLocalizations.of(context)!;

    final menuItems = [
      MenuItem(label: l10n.menu_world_map, icon: Icons.blur_circular, isPrimary: true, route: AppRouter.timePortal),
      MenuItem(label: l10n.menu_encyclopedia, icon: Icons.menu_book, route: AppRouter.encyclopedia),
      MenuItem(label: l10n.menu_quiz, icon: Icons.quiz, route: AppRouter.quiz, heroTag: 'quiz_hero_icon'),
      MenuItem(label: l10n.menu_profile, icon: Icons.person, route: AppRouter.profile),
      MenuItem(label: l10n.menu_settings, icon: Icons.settings, route: AppRouter.settings),
      MenuItem(label: l10n.menu_shop, icon: Icons.shopping_bag, route: AppRouter.shop),
      MenuItem(label: l10n.menu_leaderboard, icon: Icons.leaderboard, isDisabled: true, route: ''),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: buttonSpacing),
            child: StaggeredListItem(
              index: index,
              baseDelay: const Duration(milliseconds: 400),
              itemDelay: const Duration(milliseconds: 80),
              child: MenuButton(
                label: item.label,
                icon: item.icon,
                isPrimary: item.isPrimary,
                isDisabled: item.isDisabled,
                responsive: responsive,
                heroTag: item.heroTag,
                onPressed: item.isDisabled
                    ? () => _showComingSoon(context)
                    : () => context.push(item.route),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.msg_coming_soon),
        backgroundColor: AppColors.info.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Text(
      'v${AppConstants.appVersion}',
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textDisabled,
      ),
    );
  }
}
