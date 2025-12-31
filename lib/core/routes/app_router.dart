import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/presentation/screens/splash/splash_screen.dart';
import 'package:time_walker/presentation/screens/settings/settings_screen.dart';
import 'package:time_walker/presentation/screens/main_menu/main_menu_screen.dart';

// TODO: 화면 구현 후 import 활성화
import 'package:time_walker/presentation/screens/era_timeline/era_timeline_screen.dart';
import 'package:time_walker/presentation/screens/region_detail/region_detail_screen.dart';
import 'package:time_walker/presentation/screens/world_map/world_map_screen.dart';
// import 'package:time_walker/presentation/screens/auth/auth_screen.dart';
// import 'package:time_walker/presentation/screens/tutorial/tutorial_screen.dart';
import 'package:time_walker/presentation/screens/era_exploration/era_exploration_screen.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_screen.dart';
import 'package:time_walker/presentation/screens/encyclopedia/encyclopedia_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/encyclopedia/encyclopedia_detail_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/quiz/quiz_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/quiz/quiz_play_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/shop/shop_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/inventory/inventory_screen.dart'; // Added
import 'package:time_walker/presentation/screens/profile/profile_screen.dart'; // Unlocked
import 'package:time_walker/presentation/screens/achievement/achievement_screen.dart'; // Added
import 'package:time_walker/presentation/screens/location_exploration/location_exploration_screen.dart'; // Added
// import 'package:time_walker/presentation/screens/game_over/game_over_screen.dart';

/// TimeWalker 앱 라우팅 설정
class AppRouter {
  AppRouter._();

  // ============== 기본 라우트 ==============
  static const String splash = '/';
  static const String auth = '/auth';
  static const String tutorial = '/tutorial';
  static const String mainMenu = '/main-menu';

  // ============== 메인 탐험 라우트 ==============
  static const String worldMap = '/world-map';
  static const String regionDetail = '/region/:regionId';
  static const String eraTimeline = '/region/:regionId/country/:countryId';
  static const String eraExploration = '/era/:eraId';
  static const String locationExploration = '/era/:eraId/location/:locationId';
  static const String dialogue = '/era/:eraId/dialogue/:dialogueId';

  // ============== 콘텐츠 라우트 ==============
  static const String encyclopedia = '/encyclopedia';
  static const String encyclopediaDetail = '/encyclopedia/:entryId';
  static const String quiz = '/quiz'; // Unlocked
  static const String quizPlay = '/quiz/:quizId'; // Unlocked
  static const String shop = '/shop';
  static const String inventory = '/inventory'; // Added

  // ============== 사용자 라우트 ==============
  static const String profile = '/profile';
  static const String achievements = '/profile/achievements';
  static const String statistics = '/profile/statistics';

  // ============== 상점 라우트 ==============
  // static const String shop = '/shop'; // This line was duplicated and moved up
  static const String settings = '/settings';

  /// 앱 라우터 인스턴스
  /// 
  /// BGM 자동 관리를 원할 경우 BgmNavigatorObserver를 observers에 추가:
  /// ```dart
  /// // main.dart 또는 앱 초기화 시
  /// AppRouter.router.routerDelegate.navigatorKey.currentContext?.read(
  ///   bgmNavigatorObserverProvider,
  /// );
  /// ```
  /// 
  /// 참고: 현재는 각 화면의 initState에서 BGM을 관리하고 있으므로
  /// 옵저버 사용은 선택 사항입니다.
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true, // 디버그 모드에서 라우트 로깅
    routes: [
      // ============== 기본 화면 ==============
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: mainMenu,
        name: 'mainMenu',
        pageBuilder: (context, state) => _goldenPage(const MainMenuScreen(), state),
      ),

      // TODO: 인증 화면 구현 후 활성화
      // GoRoute(
      //   path: auth,
      //   name: 'auth',
      //   builder: (context, state) => const AuthScreen(),
      // ),

      // TODO: 튜토리얼 화면 구현 후 활성화
      // GoRoute(
      //   path: tutorial,
      //   name: 'tutorial',
      //   builder: (context, state) => const TutorialScreen(),
      // ),

      // ============== 메인 탐험 화면 ==============
      GoRoute(
        path: worldMap,
        name: 'worldMap',
        pageBuilder: (context, state) => _timePortalPage(const WorldMapScreen(), state),
      ),

      GoRoute(
        path: regionDetail,
        name: 'regionDetail',
        pageBuilder: (context, state) {
          final regionId = state.pathParameters['regionId'] ?? '';
          return _goldenPage(RegionDetailScreen(regionId: regionId), state);
        },
      ),

      GoRoute(
        path: eraTimeline,
        name: 'eraTimeline',
        pageBuilder: (context, state) {
          final regionId = state.pathParameters['regionId'] ?? '';
          final countryId = state.pathParameters['countryId'] ?? '';
          return _timePortalPage(EraTimelineScreen(regionId: regionId, countryId: countryId), state);
        },
      ),

      // TODO: 시대 탐험 화면 구현 후 활성화
      GoRoute(
        path: eraExploration,
        name: 'eraExploration',
        pageBuilder: (context, state) {
          final eraId = state.pathParameters['eraId'] ?? '';
          return _timePortalPage(EraExplorationScreen(eraId: eraId), state);
        },
      ),

      // TODO: 대화 화면 구현 후 활성화
      GoRoute(
        path: dialogue,
        name: 'dialogue',
        pageBuilder: (context, state) {
          final eraId = state.pathParameters['eraId'] ?? '';
          final dialogueId = state.pathParameters['dialogueId'] ?? '';
          return _goldenPage(DialogueScreen(dialogueId: dialogueId, eraId: eraId), state);
        },
      ),

      // 장소 탐험 화면 (신규)
      GoRoute(
        path: locationExploration,
        name: 'locationExploration',
        pageBuilder: (context, state) {
          final eraId = state.pathParameters['eraId'] ?? '';
          final locationId = state.pathParameters['locationId'] ?? '';
          return _timePortalPage(
            LocationExplorationScreen(eraId: eraId, locationId: locationId),
            state,
          );
        },
      ),

      // ============== 도감 화면 ==============
      GoRoute(
        path: encyclopedia,
        name: 'encyclopedia',
        pageBuilder: (context, state) => _goldenPage(const EncyclopediaScreen(), state),
      ),

      GoRoute(
        path: encyclopediaDetail,
        name: 'encyclopediaDetail',
        pageBuilder: (context, state) {
          final entryId = state.pathParameters['entryId'] ?? '';
          return _goldenPage(EncyclopediaDetailScreen(entryId: entryId), state);
        },
      ),

      // ============== 퀴즈 화면 ==============
      // These routes are moved below the profile routes as per the instruction
      // GoRoute(
      //   path: quiz,
      //   name: 'quiz',
      //   builder: (context, state) =>
      //       const Scaffold(body: Center(child: Text('Quiz - Coming Soon'))),
      // ),

      // GoRoute(
      //   path: quizPlay,
      //   name: 'quizPlay',
      //   builder: (context, state) {
      //     final quizId = state.pathParameters['quizId'] ?? '';
      //     return Scaffold(
      //       body: Center(child: Text('Quiz Play: $quizId - Coming Soon')),
      //     );
      //   },
      // ),

      // ============== 프로필 화면 ==============
      GoRoute(
        path: profile,
        name: 'profile',
        pageBuilder: (context, state) => _goldenPage(const ProfileScreen(), state),
      ),

      GoRoute(
        path: achievements,
        name: 'achievements',
        pageBuilder: (context, state) => _goldenPage(const AchievementScreen(), state),
      ),

      GoRoute(
        path: statistics,
        name: 'statistics',
        pageBuilder: (context, state) => _goldenPage(
          const Scaffold(
            body: Center(child: Text('Statistics - Coming Soon')),
          ),
          state,
        ),
      ),

      GoRoute(
        path: quiz,
        name: 'quiz',
        pageBuilder: (context, state) => _goldenPage(const QuizScreen(), state),
      ),
      GoRoute(
        path: quizPlay,
        name: 'quizPlay',
        pageBuilder: (context, state) {
            final quizId = state.pathParameters['quizId'] ?? '';
            return _timePortalPage(QuizPlayScreen(quizId: quizId), state);
        },
      ),

      // ============== 상점 & 설정 ==============
      GoRoute(
        path: shop,
        name: 'shop',
        pageBuilder: (context, state) => _goldenPage(const ShopScreen(), state),
      ),

      GoRoute(
        path: inventory,
        name: 'inventory',
        pageBuilder: (context, state) => _goldenPage(const InventoryScreen(), state),
      ),

      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => _goldenPage(const SettingsScreen(), state),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('${state.uri}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(worldMap),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );

  // ============== 라우트 트랜지션 헬퍼 ==============

  /// 시간 포탈 효과 (중요 화면 전환용)
  /// - EraTimeline, EraExploration, WorldMap 등
  static CustomTransitionPage _timePortalPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// 골든 페이드 효과 (일반 화면 전환용)
  /// - DetailScreen, Profile, Shop 등
  static CustomTransitionPage _goldenPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuint,
        );
        return SlideTransition(
          position: Tween<Offset>(
             begin: const Offset(0.0, 0.05),
             end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      },
    );
  }

  // ============== 네비게이션 헬퍼 메서드 ==============

  /// 지역 상세 페이지로 이동
  static void goToRegion(BuildContext context, String regionId) {
    context.pushNamed('regionDetail', pathParameters: {'regionId': regionId});
  }

  /// 시대 타임라인으로 이동
  static void goToEraTimeline(
    BuildContext context,
    String regionId,
    String countryId,
  ) {
    context.pushNamed(
      'eraTimeline',
      pathParameters: {'regionId': regionId, 'countryId': countryId},
    );
  }

  /// 시대 탐험으로 이동
  static void goToEraExploration(BuildContext context, String eraId) {
    context.pushNamed('eraExploration', pathParameters: {'eraId': eraId});
  }

  /// 대화 화면으로 이동
  static void goToDialogue(
    BuildContext context,
    String eraId,
    String dialogueId,
  ) {
    context.pushNamed(
      'dialogue',
      pathParameters: {'eraId': eraId, 'dialogueId': dialogueId},
    );
  }

  static void goToEncyclopedia(BuildContext context) {
    context.push(encyclopedia);
  }

  /// 도감 상세로 이동
  static void goToEncyclopediaEntry(BuildContext context, String entryId) {
    context.pushNamed('encyclopediaDetail', pathParameters: {'entryId': entryId});
  }

  static void goToQuiz(BuildContext context) {
    context.push(quiz);
  }

  /// 퀴즈 플레이로 이동
  static void goToQuizPlay(BuildContext context, String quizId) {
    context.pushNamed('quizPlay', pathParameters: {'quizId': quizId});
  }

  static void goToShop(BuildContext context) {
    context.push(shop);
  }

  static void goToInventory(BuildContext context) {
    context.push(inventory);
  }

  /// 업적 화면으로 이동
  static void goToAchievements(BuildContext context) {
    context.push(achievements);
  }
}
