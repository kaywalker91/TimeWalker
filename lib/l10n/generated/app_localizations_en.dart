// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TimeWalker';

  @override
  String get common_error => 'Error';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_close => 'Close';

  @override
  String get common_locked => 'LOCKED';

  @override
  String get common_explore => 'EXPLORE';

  @override
  String get common_talk => 'Talk';

  @override
  String get common_locked_status => 'Locked';

  @override
  String get common_unknown_character => '???';

  @override
  String get era_timeline_title => 'Era Timeline';

  @override
  String get era_timeline_no_eras => 'No eras available yet.';

  @override
  String get era_timeline_locked_msg => 'This era is locked.';

  @override
  String get exploration_title_default => 'Exploration';

  @override
  String get exploration_tutorial_msg =>
      'Welcome Explorer! Pinch to Zoom the map and Tap markers to explore locations.';

  @override
  String get exploration_progress_label => 'Era Progress';

  @override
  String get exploration_era_not_found => 'Era not found';

  @override
  String exploration_location_error(Object error) {
    return 'Error loading locations: $error';
  }

  @override
  String get exploration_location_locked =>
      'This location is not yet accessible.';

  @override
  String get exploration_no_dialogue =>
      'No dialogue available for this character yet.';

  @override
  String get exploration_no_characters =>
      'There are no characters to meet at this location currently.';

  @override
  String get menu_world_map => 'WORLD MAP';

  @override
  String get menu_encyclopedia => 'ENCYCLOPEDIA';

  @override
  String get menu_quiz => 'QUIZ CHALLENGE';

  @override
  String get menu_profile => 'MY PROFILE';

  @override
  String get menu_settings => 'SETTINGS';

  @override
  String get menu_shop => 'SHOP';

  @override
  String get menu_leaderboard => 'LEADERBOARD';

  @override
  String get msg_coming_soon => 'Coming in v1.5!';

  @override
  String get world_map_title => 'TimeWalker World Map';

  @override
  String get world_map_current_location => 'Current Location';

  @override
  String get world_map_location_test => 'Asia - Korea';

  @override
  String world_map_locked_msg(Object region) {
    return '$region is currently locked.';
  }

  @override
  String get app_tagline => 'Become a TimeWalker and explore history.';
}
