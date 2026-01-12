import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeStyle {
  defaultDark,
  midnight,
}

class ThemeController extends StateNotifier<AppThemeStyle> {
  ThemeController() : super(AppThemeStyle.defaultDark);

  void setStyle(AppThemeStyle style) {
    state = style;
  }
  
  void toggleTheme() {
    state = state == AppThemeStyle.defaultDark 
        ? AppThemeStyle.midnight 
        : AppThemeStyle.defaultDark;
  }
}

final themeProvider = StateNotifierProvider<ThemeController, AppThemeStyle>((ref) {
  return ThemeController();
});
