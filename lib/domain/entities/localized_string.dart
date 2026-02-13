import 'package:flutter/material.dart';

/// A helper class for managing localized strings with fallback support.
/// 
/// Stores translations for multiple locales and provides methods to retrieve
/// the appropriate translation based on the current locale.
class LocalizedString {
  final Map<String, String> _values;

  LocalizedString({
    required String ko,
    String? en,
  }) : _values = {
          'ko': ko,
          if (en != null) 'en': en,
        };

  /// Gets the localized string for the given locale.
  /// Falls back to Korean if the requested locale is not available.
  String get(Locale locale) {
    final languageCode = locale.languageCode;
    return _values[languageCode] ?? _values['ko'] ?? '';
  }

  /// Gets the localized string for the current context's locale.
  String getForContext(BuildContext context) {
    return get(Localizations.localeOf(context));
  }

  /// Returns the Korean version (default/fallback).
  String get ko => _values['ko'] ?? '';

  /// Returns the English version if available.
  String? get en => _values['en'];

  /// Creates a LocalizedString from JSON.
  factory LocalizedString.fromJson(Map<String, dynamic> json) {
    return LocalizedString(
      ko: json['ko'] as String? ?? '',
      en: json['en'] as String?,
    );
  }

  /// Converts this LocalizedString to JSON.
  Map<String, dynamic> toJson() {
    return {
      'ko': ko,
      if (en != null) 'en': en,
    };
  }

  /// Creates a LocalizedString with the same value for all locales.
  factory LocalizedString.same(String value) {
    return LocalizedString(ko: value, en: value);
  }

  @override
  String toString() => ko; // Default to Korean for toString

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedString &&
          runtimeType == other.runtimeType &&
          _values.toString() == other._values.toString();

  @override
  int get hashCode => _values.toString().hashCode;
}
