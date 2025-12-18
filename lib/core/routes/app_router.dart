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

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
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
        builder: (context, state) => const MainMenuScreen(),
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
        builder: (context, state) => const WorldMapScreen(),
      ),

      GoRoute(
        path: regionDetail,
        name: 'regionDetail',
        builder: (context, state) {
          final regionId = state.pathParameters['regionId'] ?? '';
          return RegionDetailScreen(regionId: regionId);
        },
      ),

      GoRoute(
        path: eraTimeline,
        name: 'eraTimeline',
        builder: (context, state) {
          final regionId = state.pathParameters['regionId'] ?? '';
          final countryId = state.pathParameters['countryId'] ?? '';
          return EraTimelineScreen(regionId: regionId, countryId: countryId);
        },
      ),

      // TODO: 시대 탐험 화면 구현 후 활성화
      GoRoute(
        path: eraExploration,
        name: 'eraExploration',
        builder: (context, state) {
          final eraId = state.pathParameters['eraId'] ?? '';
          return EraExplorationScreen(eraId: eraId);
        },
      ),

      // TODO: 대화 화면 구현 후 활성화
      GoRoute(
        path: dialogue,
        name: 'dialogue',
        builder: (context, state) {
          final eraId = state.pathParameters['eraId'] ?? '';
          final dialogueId = state.pathParameters['dialogueId'] ?? '';
          return DialogueScreen(dialogueId: dialogueId, eraId: eraId);
        },
      ),

      // ============== 도감 화면 ==============
      GoRoute(
        path: encyclopedia,
        name: 'encyclopedia',
        builder: (context, state) => const EncyclopediaScreen(),
      ),

      GoRoute(
        path: encyclopediaDetail,
        name: 'encyclopediaDetail',
        builder: (context, state) {
          final entryId = state.pathParameters['entryId'] ?? '';
          return EncyclopediaDetailScreen(entryId: entryId);
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
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: achievements,
        name: 'achievements',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Achievements - Coming Soon')),
        ),
      ),

      GoRoute(
        path: statistics,
        name: 'statistics',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Statistics - Coming Soon')),
        ),
      ),

      GoRoute(
        path: quiz,
        name: 'quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: quizPlay,
        name: 'quizPlay',
        builder: (context, state) {
            final quizId = state.pathParameters['quizId'] ?? '';
            return QuizPlayScreen(quizId: quizId);
        },
      ),

      // ============== 상점 & 설정 ==============
      GoRoute(
        path: shop,
        name: 'shop',
        builder: (context, state) => const ShopScreen(),
      ),

      GoRoute(
        path: inventory,
        name: 'inventory',
        builder: (context, state) => const InventoryScreen(),
      ),

      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
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
}
