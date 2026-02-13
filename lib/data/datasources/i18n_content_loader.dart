import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Centralized loader for i18n content from JSON files.
/// 
/// Loads locale-specific content (character biographies, dialogue nodes, etc.)
/// from the assets/data/i18n/{locale}/ directory structure.
class I18nContentLoader {
  // Cache for loaded content
  final Map<String, Map<String, dynamic>> _cache = {};

  /// Loads character i18n content for the given locale.
  Future<Map<String, dynamic>> loadCharacterContent(Locale locale) async {
    return _loadContent(locale, 'characters');
  }

  /// Loads dialogue i18n content for the given locale.
  Future<Map<String, dynamic>> loadDialogueContent(Locale locale) async {
    return _loadContent(locale, 'dialogues');
  }

  /// Loads quiz i18n content for the given locale.
  Future<Map<String, dynamic>> loadQuizContent(Locale locale) async {
    return _loadContent(locale, 'quizzes');
  }

  /// Loads location i18n content for the given locale.
  Future<Map<String, dynamic>> loadLocationContent(Locale locale) async {
    return _loadContent(locale, 'locations');
  }

  /// Generic method to load content from i18n files with caching.
  Future<Map<String, dynamic>> _loadContent(
    Locale locale,
    String contentType,
  ) async {
    final languageCode = locale.languageCode;
    final cacheKey = '${languageCode}_$contentType';

    // Return from cache if available
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      // Load from asset
      final path = 'assets/data/i18n/$languageCode/$contentType.json';
      final jsonString = await rootBundle.loadString(path);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Cache the loaded data
      _cache[cacheKey] = data;

      return data;
    } catch (e) {
      // Fall back to Korean if the requested locale fails
      if (languageCode != 'ko') {
        return _loadContent(const Locale('ko'), contentType);
      }

      // If Korean also fails, return empty map and log error
      print('Error loading i18n content for $contentType: $e');
      return {};
    }
  }

  /// Clears the cache (useful for testing or locale changes).
  void clearCache() {
    _cache.clear();
  }

  /// Clears cache for a specific locale and content type.
  void clearCacheFor(Locale locale, String contentType) {
    final languageCode = locale.languageCode;
    final cacheKey = '${languageCode}_$contentType';
    _cache.remove(cacheKey);
  }

  /// Pre-loads content for a locale to improve performance.
  Future<void> preloadContent(Locale locale) async {
    await Future.wait([
      loadCharacterContent(locale),
      loadDialogueContent(locale),
      loadQuizContent(locale),
      loadLocationContent(locale),
    ]);
  }
}
