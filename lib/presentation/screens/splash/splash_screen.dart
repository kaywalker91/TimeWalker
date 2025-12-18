import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';

/// 스플래시 화면
/// - 앱 로고 및 로딩 표시
/// - 초기 데이터 로드 및 시스템 설정
/// - 자동으로 메인 메뉴로 이동
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. 시스템 UI 설정
      // - 화면 방향 고정 (세로 모드)
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // - 상태바 투명 및 색상 설정
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF1A1A2E),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // 2. 데이터 초기화 (추후 구현)
      // - Hive 초기화
      // - 설정 로드
      // - Firebase 초기화

      // 최소 로딩 시간 보장 (애니메이션 효과)
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      // 초기화 중 에러 발생 시 로그 출력 (실제 앱에서는 Crashlytics 등으로 전송)
      debugPrint('Initialization error: $e');
    } finally {
      // 성공/실패 여부와 관계없이 화면 이동 (무한 로딩 방지)
      if (mounted) {
        context.go(AppRouter.mainMenu);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 로고 플레이스홀더
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF1493), Color(0xFF00FFFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF1493,
                            ).withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.timer,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 앱 이름 (Constants 사용)
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                    ),
                    const SizedBox(height: 10),
                    // 태그라인
                    Text(
                      AppLocalizations.of(context)!.app_tagline,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 50),
                    // 로딩 인디케이터
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF00FFFF),
                        ),
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
