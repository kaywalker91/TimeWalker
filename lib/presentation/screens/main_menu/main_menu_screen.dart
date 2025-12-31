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
    
    // BGM 초기화 (build가 아닌 initState에서 한 번만 실행)
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
    
    // BGM은 initState에서 처리됨 (build에서 중복 실행 방지)
    
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
                        
                        // 타이틀 섹션
                        _buildTitle(context, responsive),
                        SizedBox(height: responsive.spacing(20)),

                        const Spacer(),
                        
                        // 메뉴 버튼들
                        _buildMenuButtons(context, responsive),
                        SizedBox(height: responsive.spacing(30)),
                        
                        // 버전 정보
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
        // 로고 with 애니메이션
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
        
        // 게임 타이틀
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
        
        // 서브 타이틀
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
    
    final menuItems = [
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_world_map,
        icon: Icons.public,
        isPrimary: true,
        route: AppRouter.worldMap,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_encyclopedia,
        icon: Icons.menu_book,
        route: AppRouter.encyclopedia,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_quiz,
        icon: Icons.quiz,
        route: AppRouter.quiz,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_profile,
        icon: Icons.person,
        route: AppRouter.profile,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_settings,
        icon: Icons.settings,
        route: AppRouter.settings,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_shop,
        icon: Icons.shopping_bag,
        route: AppRouter.shop,
      ),
      _MenuItem(
        label: AppLocalizations.of(context)!.menu_leaderboard,
        icon: Icons.leaderboard,
        isDisabled: true,
        route: '',
      ),
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
              child: _MenuButton(
                label: item.label,
                icon: item.icon,
                isPrimary: item.isPrimary,
                isDisabled: item.isDisabled,
                responsive: responsive,
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

class _MenuItem {
  final String label;
  final IconData icon;
  final String route;
  final bool isPrimary;
  final bool isDisabled;
  
  const _MenuItem({
    required this.label,
    required this.icon,
    required this.route,
    this.isPrimary = false,
    this.isDisabled = false,
  });
}

/// 애니메이션이 적용된 메뉴 버튼 위젯
class _MenuButton extends StatefulWidget {
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
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;
  
  bool get _isActive => !widget.isDisabled;
  
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.responsive.buttonHeight(phone: 52, tablet: 60);
    final fontSize = widget.responsive.fontSize(15);
    final iconSize = widget.responsive.iconSize(22);
    
    // 데코레이션 결정
    BoxDecoration decoration;
    Color textColor;
    
    if (widget.isDisabled) {
      decoration = BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      );
      textColor = AppColors.textDisabled;
    } else if (widget.isPrimary) {
      decoration = BoxDecoration(
        gradient: _isPressed 
            ? AppGradients.goldenButtonPressed 
            : AppGradients.goldenButton,
        borderRadius: BorderRadius.circular(14),
        boxShadow: _isPressed ? null : (_isHovered 
            ? AppShadows.goldenGlowLg 
            : AppShadows.goldenGlowMd),
      );
      textColor = AppColors.background;
    } else {
      decoration = BoxDecoration(
        color: _isHovered 
            ? AppColors.surface.withValues(alpha: 0.6) 
            : AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isHovered 
              ? AppColors.primary.withValues(alpha: 0.5) 
              : AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: _isHovered ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ] : null,
      );
      textColor = AppColors.textPrimary;
    }
    
    return MouseRegion(
      onEnter: _isActive ? (_) => setState(() => _isHovered = true) : null,
      onExit: _isActive ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTapDown: _isActive ? (_) {
          setState(() => _isPressed = true);
          _pressController.forward();
        } : null,
        onTapUp: _isActive ? (_) {
          setState(() => _isPressed = false);
          _pressController.reverse();
        } : null,
        onTapCancel: _isActive ? () {
          setState(() => _isPressed = false);
          _pressController.reverse();
        } : null,
        onTap: _isActive ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: _pressAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pressAnimation.value,
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                width: double.infinity,
                height: buttonHeight,
                decoration: decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: iconSize,
                      color: textColor,
                    ),
                    SizedBox(width: widget.responsive.spacing(10)),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: widget.responsive.isSmallPhone ? 1 : 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
