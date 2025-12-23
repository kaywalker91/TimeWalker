import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';

/// 메인 메뉴 화면
/// - 게임 시작
/// - 설정
/// - 상점 (v1.5)
/// - 리더보드 (v1.5)
class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    
    // BGM 시작 (메인 메뉴 BGM)
    // 현재 트랙이 다를 때만 재생하여 중복 호출 방지
    final currentTrack = ref.watch(currentBgmTrackProvider);
    if (currentTrack != AudioConstants.bgmMainMenu) {
      // WidgetsBinding.addPostFrameCallback을 사용하여 build 완료 후 실행
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bgmControllerProvider.notifier).playMainMenuBgm();
      });
    }
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
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
                    SizedBox(height: responsive.spacing(60)),
                    // 타이틀
                    _buildTitle(context, responsive),
                    SizedBox(height: responsive.spacing(20)),

                    const Spacer(),
                    // 메뉴 버튼들
                    _buildMenuButtons(context, ref, responsive),
                    SizedBox(height: responsive.spacing(40)),
                    // 버전 정보
                    _buildVersionInfo(context),
                    SizedBox(height: responsive.spacing(20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ResponsiveUtils responsive) {
    final logoSize = responsive.isSmallPhone ? 80.0 : 100.0;
    final iconSize = responsive.iconSize(50);
    
    return Column(
      children: [
        // 로고 아이콘
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF1493), Color(0xFF00FFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(logoSize * 0.25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF1493).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.timer, size: iconSize, color: Colors.white),
        ),
        SizedBox(height: responsive.spacing(20)),
        // 게임 타이틀
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF1493), Color(0xFF00FFFF)],
          ).createShader(bounds),
          child: Text(
            AppConstants.appName.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: responsive.isSmallPhone ? 3 : 5,
              fontSize: responsive.fontSize(24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, WidgetRef ref, ResponsiveUtils responsive) {
    final buttonSpacing = responsive.spacing(15);
    final horizontalPadding = responsive.padding(40);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // 세계 지도 (탐험) 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_world_map,
            icon: Icons.public,
            isPrimary: true,
            responsive: responsive,
            onPressed: () {
              context.push(AppRouter.worldMap);
            },
          ),
          SizedBox(height: buttonSpacing),
          // 도감 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_encyclopedia,
            icon: Icons.menu_book,
            responsive: responsive,
            onPressed: () => context.push(AppRouter.encyclopedia),
          ),
          SizedBox(height: buttonSpacing),
          // 퀴즈 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_quiz,
            icon: Icons.quiz,
            responsive: responsive,
            onPressed: () => context.push(AppRouter.quiz),
          ),
          SizedBox(height: buttonSpacing),
          // 프로필 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_profile,
            icon: Icons.person,
            responsive: responsive,
            onPressed: () => context.push(AppRouter.profile),
          ),
          SizedBox(height: buttonSpacing),
          // 설정 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_settings,
            icon: Icons.settings,
            responsive: responsive,
            onPressed: () => context.push(AppRouter.settings),
          ),
          SizedBox(height: buttonSpacing),
          // 상점 버튼
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_shop,
            icon: Icons.shopping_bag,
            isDisabled: false,
            responsive: responsive,
            onPressed: () => context.push(AppRouter.shop),
          ),
          SizedBox(height: buttonSpacing),
          // 리더보드 버튼 (v1.5)
          _MenuButton(
            label: AppLocalizations.of(context)!.menu_leaderboard,
            icon: Icons.leaderboard,
            isDisabled: true,
            responsive: responsive,
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.msg_coming_soon)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Text(
      'v${AppConstants.appVersion}',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.white38),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final ResponsiveUtils responsive;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.responsive,
    this.isPrimary = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = responsive.buttonHeight(phone: 50, tablet: 60);
    final fontSize = responsive.fontSize(16);
    final iconSize = responsive.iconSize(22);
    
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFFFF1493)
              : Colors.white.withValues(alpha: 0.1),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
          disabledForegroundColor: Colors.white38,
          elevation: isPrimary ? 5 : 0,
          shadowColor: isPrimary ? const Color(0xFFFF1493) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isPrimary
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize),
            SizedBox(width: responsive.spacing(10)),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: responsive.isSmallPhone ? 1 : 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
