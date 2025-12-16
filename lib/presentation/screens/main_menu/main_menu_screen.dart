import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';

/// 메인 메뉴 화면
/// - 게임 시작
/// - 설정
/// - 상점 (v1.5)
/// - 리더보드 (v1.5)
class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: Column(
            children: [
              const SizedBox(height: 60),
              // 타이틀
              _buildTitle(context),
              const SizedBox(height: 20),

              const Spacer(),
              // 메뉴 버튼들
              _buildMenuButtons(context, ref),
              const SizedBox(height: 40),
              // 버전 정보
              _buildVersionInfo(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        // 로고 아이콘
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF1493), Color(0xFF00FFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF1493).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.timer, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
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
              letterSpacing: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // 세계 지도 (탐험) 버튼
          _MenuButton(
            label: 'WORLD MAP',
            icon: Icons.public,
            isPrimary: true,
            onPressed: () {
              context.go(AppRouter.worldMap);
            },
          ),
          const SizedBox(height: 15),
          // 설정 버튼
          _MenuButton(
            label: 'SETTINGS',
            icon: Icons.settings,
            onPressed: () => context.push(AppRouter.settings),
          ),
          const SizedBox(height: 15),
          // 상점 버튼 (v1.5)
          _MenuButton(
            label: 'SHOP',
            icon: Icons.shopping_bag,
            isDisabled: true,
            onPressed: () {
              // TODO: v1.5에서 구현
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming in v1.5!')));
            },
          ),
          const SizedBox(height: 15),
          // 리더보드 버튼 (v1.5)
          _MenuButton(
            label: 'LEADERBOARD',
            icon: Icons.leaderboard,
            isDisabled: true,
            onPressed: () {
              // TODO: v1.5에서 구현
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming in v1.5!')));
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

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
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
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
