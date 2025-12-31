import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/app_lifecycle_manager.dart';
import 'package:time_walker/core/themes/app_theme.dart';

void main() {
  // Flutter 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // 비동기 초기화 로직(SystemChrome 등)은 SplashScreen으로 이관하여
  // 앱 실행 속도를 높이고 흰 화면(White Screen) 이슈를 방지함

  runApp(
    const ProviderScope(
      child: AppLifecycleManager(
        child: TimeRunnerApp(),
      ),
    ),
  );
}

class TimeRunnerApp extends StatelessWidget {
  const TimeRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TimeWalker', // 앱 이름 수정 (TimeRunner -> TimeWalker)
      locale: const Locale('ko'), // Force Korean as requested
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
