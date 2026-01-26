import 'package:flutter/material.dart';
import 'package:time_walker/domain/constants/era_theme_ids.dart';
import 'package:time_walker/domain/entities/era.dart';

class EraTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final String fontFamily;

  const EraTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    this.fontFamily = 'NotoSansKR',
  });
}

class EraThemeRegistry {
  EraThemeRegistry._();

  static const EraTheme _defaultTheme = EraTheme(
    primaryColor: Color(0xFF455A64),
    secondaryColor: Color(0xFF90A4AE),
    accentColor: Color(0xFF42A5F5),
    backgroundColor: Color(0xFFF5F5F5),
    textColor: Color(0xFF212121),
  );

  static const Map<String, EraTheme> _themes = {
    EraThemeIds.defaultTheme: _defaultTheme,
    EraThemeIds.threeKingdoms: EraTheme(
      primaryColor: Color(0xFF8B4513),
      secondaryColor: Color(0xFF228B22),
      accentColor: Color(0xFFFFD700),
      backgroundColor: Color(0xFFF5DEB3),
      textColor: Color(0xFF2F1810),
    ),
    EraThemeIds.goryeo: EraTheme(
      primaryColor: Color(0xFF4169E1),
      secondaryColor: Color(0xFF20B2AA),
      accentColor: Color(0xFFE6BE8A),
      backgroundColor: Color(0xFFF0F8FF),
      textColor: Color(0xFF1C1C1C),
    ),
    EraThemeIds.joseon: EraTheme(
      primaryColor: Color(0xFF800020),
      secondaryColor: Color(0xFF2E8B57),
      accentColor: Color(0xFFFFD700),
      backgroundColor: Color(0xFFFFF8DC),
      textColor: Color(0xFF1C1C1C),
    ),
    EraThemeIds.renaissance: EraTheme(
      primaryColor: Color(0xFF6A0DAD),
      secondaryColor: Color(0xFFDAA520),
      accentColor: Color(0xFFFFD700),
      backgroundColor: Color(0xFFFDF5E6),
      textColor: Color(0xFF2F1810),
    ),
    EraThemeIds.unifiedSilla: EraTheme(
      primaryColor: Color(0xFF4B0082),
      secondaryColor: Color(0xFFFFD700),
      accentColor: Color(0xFF9370DB),
      backgroundColor: Color(0xFFFAFAE6),
      textColor: Color(0xFF2C1B18),
    ),
    EraThemeIds.modern: EraTheme(
      primaryColor: Color(0xFF263238),
      secondaryColor: Color(0xFFD84315),
      accentColor: Color(0xFF78909C),
      backgroundColor: Color(0xFFECEFF1),
      textColor: Color(0xFF212121),
    ),
    EraThemeIds.industrial: EraTheme(
      primaryColor: Color(0xFF37474F),
      secondaryColor: Color(0xFFFF5722),
      accentColor: Color(0xFFCFD8DC),
      backgroundColor: Color(0xFFF5F5F5),
      textColor: Color(0xFF263238),
    ),
    EraThemeIds.contemporary1: EraTheme(
      primaryColor: Color(0xFF5D4037),
      secondaryColor: Color(0xFF33691E),
      accentColor: Color(0xFFD84315),
      backgroundColor: Color(0xFFEFEBE9),
      textColor: Color(0xFF3E2723),
    ),
    EraThemeIds.contemporary2: EraTheme(
      primaryColor: Color(0xFF455A64),
      secondaryColor: Color(0xFFFF6F00),
      accentColor: Color(0xFFCFD8DC),
      backgroundColor: Color(0xFFECEFF1),
      textColor: Color(0xFF263238),
    ),
    EraThemeIds.contemporary3: EraTheme(
      primaryColor: Color(0xFF3F51B5),
      secondaryColor: Color(0xFFE91E63),
      accentColor: Color(0xFF03A9F4),
      backgroundColor: Color(0xFFFAFAFA),
      textColor: Color(0xFF212121),
    ),
    EraThemeIds.contemporary: EraTheme(
      primaryColor: Color(0xFF37474F),
      secondaryColor: Color(0xFFE53935),
      accentColor: Color(0xFF00BCD4),
      backgroundColor: Color(0xFFF5F5F5),
      textColor: Color(0xFF212121),
    ),
    EraThemeIds.future: EraTheme(
      primaryColor: Color(0xFF6200EE),
      secondaryColor: Color(0xFF00E5FF),
      accentColor: Color(0xFFE040FB),
      backgroundColor: Color(0xFF121212),
      textColor: Color(0xFFE0E0E0),
    ),
  };

  static EraTheme byId(String themeId) {
    return _themes[themeId] ?? _defaultTheme;
  }
}

extension EraThemeExtension on Era {
  EraTheme get theme => EraThemeRegistry.byId(themeId);
}
