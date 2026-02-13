import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/data/datasources/i18n_content_loader.dart';

// ============================================================================
// I18n Content Providers
// ============================================================================
// Provides locale-aware content loading for extended text fields:
// - Character biographies, achievements
// - Location descriptions
// - Dialogue nodes
// - Quiz questions, options, explanations
// ============================================================================

/// I18nContentLoader Provider
/// 
/// Provides singleton instance of I18nContentLoader with caching
final i18nContentLoaderProvider = Provider<I18nContentLoader>((ref) {
  return I18nContentLoader();
});

/// Current Locale Provider
/// 
/// Tracks the current app locale for reactive i18n content loading
final currentLocaleProvider = StateProvider<Locale>((ref) {
  return const Locale('ko'); // Default to Korean
});

/// Character i18n Content Provider
/// 
/// Loads extended character content (biographies, achievements) for given locale
/// 
/// Example usage:
/// ```dart
/// final locale = Localizations.localeOf(context);
/// final content = ref.watch(characterI18nContentProvider(locale.languageCode));
/// final bio = content.value?[characterId]?['biography'];
/// ```
final characterI18nContentProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, localeCode) async {
    final loader = ref.watch(i18nContentLoaderProvider);
    return loader.loadCharacterContent(Locale(localeCode));
  },
);

/// Location i18n Content Provider
/// 
/// Loads extended location content (descriptions) for given locale
final locationI18nContentProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, localeCode) async {
    final loader = ref.watch(i18nContentLoaderProvider);
    return loader.loadLocationContent(Locale(localeCode));
  },
);

/// Dialogue i18n Content Provider
/// 
/// Loads extended dialogue content (nodes with speaker, text, choices) for given locale
final dialogueI18nContentProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, localeCode) async {
    final loader = ref.watch(i18nContentLoaderProvider);
    return loader.loadDialogueContent(Locale(localeCode));
  },
);

/// Quiz i18n Content Provider
/// 
/// Loads quiz content (questions, options, explanations) for given locale
final quizI18nContentProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, localeCode) async {
    final loader = ref.watch(i18nContentLoaderProvider);
    return loader.loadQuizContent(Locale(localeCode));
  },
);
