import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 스플래시 화면
/// 
/// - "시간의 문" 컨셉의 풍부한 애니메이션
/// - 황금빛 로고와 시간 포탈 효과
/// - 떠다니는 입자 효과
/// - 자동으로 메인 메뉴로 이동
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('[SplashScreen] initState');
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // 로고 등장 애니메이션
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    
    // 펄스 글로우 애니메이션
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _logoController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    try {
      // 1. 시스템 UI 설정
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // 2. 최소 로딩 시간 보장 (애니메이션 효과)
      await Future.delayed(const Duration(milliseconds: 2500));
      
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      if (mounted) {
        context.go(AppRouter.mainMenu);
      }
    }
  }

  @override
  void dispose() {
    debugPrint('[SplashScreen] dispose');
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 떠다니는 입자 효과
            const FloatingParticles(
              particleCount: 40,
              particleColor: AppColors.starlight,
              maxSize: 3,
            ),
            
            // 시간 포탈 링 효과
            Center(
              child: TimePortalRings(
                size: 320,
                color: AppColors.secondary,
              ),
            ),
            
            // 메인 콘텐츠
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildMainContent(),
                    ),
                  );
                },
              ),
            ),
            
            // 하단 버전 정보
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: FadeInWidget(
                delay: const Duration(milliseconds: 1000),
                child: Text(
                  'v${AppConstants.appVersion}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 로고 with 펄스 글로우
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: _pulseAnimation.value),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const TimeLogo.large(),
            );
          },
        ),
        const SizedBox(height: 30),
        
        // 앱 이름 with 쉬머
        GoldenShimmer(
          duration: const Duration(seconds: 3),
          child: TimeTitle.large(text: AppConstants.appName),
        ),
        const SizedBox(height: 12),
        
        // 태그라인
        FadeInWidget(
          delay: const Duration(milliseconds: 800),
          child: Text(
            AppLocalizations.of(context)!.app_tagline,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 60),
        
        // 커스텀 시간 로더
        FadeInWidget(
          delay: const Duration(milliseconds: 1200),
          child: const TimeLoader(
            size: 40,
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      ],
    );
  }
}
