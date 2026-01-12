import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/app_lifecycle_manager.dart';
import 'package:time_walker/core/themes/app_theme.dart';
import 'package:time_walker/core/services/hive_service.dart';
import 'package:time_walker/presentation/providers/theme_provider.dart';

Future<void> main() async {
  // Flutter 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 데이터베이스 초기화
  await HiveService.initialize();

  runApp(
    const ProviderScope(
      child: AppLifecycleManager(
        child: TimeRunnerApp(),
      ),
    ),
  );
}

class TimeRunnerApp extends ConsumerWidget {
  const TimeRunnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStyle = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: 'TimeWalker',
      locale: const Locale('ko'), // Force Korean as requested
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: themeStyle == AppThemeStyle.midnight ? AppTheme.midnightTheme : AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
