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
  String get common_completed => 'Completed';

  @override
  String get quiz_progress_title => 'Quiz Challenge';

  @override
  String get quiz_completed => 'Completed';

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
      'Welcome Explorer! Scroll through the timeline to select historical places and start exploring! Gain knowledge by talking to characters.';

  @override
  String get time_portal_help_title => 'Time Portal Help';

  @override
  String get time_portal_help_msg =>
      'Tap the 5 civilization portals to travel to that era. Locked portals can be unlocked by increasing your explorer level.';

  @override
  String get quiz_help_title => 'Quiz Item Guide';

  @override
  String get quiz_help_msg =>
      '💡 Hint: Removes 2 wrong answers.\n⏳ Time Stop: Freezes time for 10 seconds.\nYou can purchase items in the Shop.';

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
  String get exploration_selected_label => 'Selected';

  @override
  String get exploration_list_locations => 'Locations';

  @override
  String get exploration_list_characters => 'Characters';

  @override
  String get exploration_tab_locations => 'Locations';

  @override
  String get exploration_tab_progress => 'Progress';

  @override
  String get exploration_stats_completed => 'Completed';

  @override
  String get exploration_stats_in_progress => 'In Progress';

  @override
  String get exploration_stats_locked => 'Locked';

  @override
  String get exploration_filter_all => 'All';

  @override
  String get exploration_filter_completed => 'Completed';

  @override
  String get exploration_filter_in_progress => 'In Progress';

  @override
  String get exploration_filter_locked => 'Unexplored';

  @override
  String get exploration_search_placeholder => 'Search locations...';

  @override
  String exploration_location_characters_count(Object count) {
    return '$count';
  }

  @override
  String get exploration_no_search_results => 'No results found';

  @override
  String get exploration_tab_characters => 'Characters';

  @override
  String get exploration_no_locations => 'No locations available.';

  @override
  String get exploration_legend_title => 'Kingdom Filters';

  @override
  String get exploration_status_title => 'Status';

  @override
  String get exploration_help_title => 'Exploration Help';

  @override
  String get dialogue_choices_scroll_hint_more => 'More choices below';

  @override
  String get menu_world_map => 'TIME CORRIDOR';

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

  @override
  String get quiz_title => 'History Quiz';

  @override
  String quiz_completed_count(Object count) {
    return '$count completed';
  }

  @override
  String get quiz_filter_all => 'All';

  @override
  String get quiz_filter_completed => 'Completed';

  @override
  String get quiz_category_all => 'All';

  @override
  String get quiz_empty_completed => 'No completed quizzes yet.\nTry a quiz!';

  @override
  String get quiz_empty_all => 'No quizzes available.';

  @override
  String get quiz_pts => 'pts';

  @override
  String get quiz_sec => 's';

  @override
  String get quiz_view_explanation => 'View explanation';

  @override
  String get quiz_retry => 'Try again';

  @override
  String get quiz_start_challenge => 'Challenge';

  @override
  String get quiz_correct_message => 'Correct!';

  @override
  String quiz_points_earned(Object points) {
    return '$points points earned';
  }

  @override
  String get quiz_question => 'Question';

  @override
  String get quiz_options => 'Options';

  @override
  String get quiz_explanation => 'Explanation';

  @override
  String get quiz_close => 'Close';

  @override
  String get quiz_play_title => 'Quiz Challenge';

  @override
  String get quiz_submit => 'Submit Answer';

  @override
  String quiz_time_remaining(int seconds) {
    return 'Time Remaining: ${seconds}s';
  }

  @override
  String get quiz_time_frozen => 'Time Frozen!';

  @override
  String get quiz_correct_review => 'Correct! (Review)';

  @override
  String quiz_correct_points(int points) {
    return 'Correct! +$points pts';
  }

  @override
  String get quiz_incorrect => 'Incorrect!';

  @override
  String get quiz_hint_used => 'Hint used! 2 wrong answers removed.';

  @override
  String get quiz_time_freeze_used =>
      'Chronos Time Stop! Time frozen for 10 seconds.';

  @override
  String get quiz_item_use_failed => 'Failed to use item!';

  @override
  String get quiz_not_found => 'Quiz not found';

  @override
  String get quiz_difficulty_easy => 'Easy';

  @override
  String get quiz_difficulty_medium => 'Medium';

  @override
  String get quiz_difficulty_hard => 'Hard';

  @override
  String get quiz_move_to_joseon => 'Go to Joseon Dynasty';

  @override
  String get quiz_move_to_three_kingdoms => 'Go to Three Kingdoms';

  @override
  String get quiz_move_to_goryeo => 'Go to Goryeo Dynasty';

  @override
  String get quiz_move_to_gaya => 'Go to Gaya Period';

  @override
  String get quiz_move_to_ancient => 'Go to Ancient Korea';

  @override
  String get quiz_move_to_era => 'Go to Era Exploration';

  @override
  String quiz_progress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get shop_title => 'Item Shop';

  @override
  String get shop_tab_all => 'All';

  @override
  String get shop_tab_consumable => 'Consumables';

  @override
  String get shop_tab_cosmetic => 'Cosmetics';

  @override
  String get shop_tab_upgrade => 'Upgrades';

  @override
  String get shop_purchase_error_coins => 'Not enough coins!';

  @override
  String get shop_purchase_error_owned => 'You already own this item!';

  @override
  String get shop_confirm_title => 'Purchase Confirmation';

  @override
  String shop_confirm_message(Object item, Object price) {
    return 'Purchase $item for $price coins?';
  }

  @override
  String get common_buy => 'Buy';

  @override
  String shop_purchase_success(Object item) {
    return 'Purchased $item!';
  }

  @override
  String get shop_empty_list => 'No items available for purchase.';

  @override
  String get shop_item_owned => 'Owned';

  @override
  String shop_item_price(Object price) {
    return '$price coins';
  }

  @override
  String get profile_title => 'My Profile';

  @override
  String get profile_rank_progress => 'Rank Progress';

  @override
  String profile_next_rank_pts(Object points) {
    return '$points pts to next rank';
  }

  @override
  String get profile_identity_name => 'NAME';

  @override
  String get profile_identity_rank => 'RANK';

  @override
  String get profile_stat_exploration => 'Explorer';

  @override
  String get profile_stat_collection => 'Collection';

  @override
  String get profile_stat_knowledge => 'Knowledge';

  @override
  String get profile_stat_playtime => 'Total Playtime';

  @override
  String get profile_stat_eras => 'Eras Visited';

  @override
  String profile_eras_count(Object count) {
    return '$count Eras';
  }

  @override
  String get profile_stat_dialogues => 'Completed Dialogues';

  @override
  String get common_error_stats_load => 'Failed to load stats.';

  @override
  String get rank_novice => 'Novice Explorer';

  @override
  String get rank_apprentice => 'Apprentice Historian';

  @override
  String get rank_intermediate => 'Intermediate Historian';

  @override
  String get rank_advanced => 'Advanced Historian';

  @override
  String get rank_expert => 'History Expert';

  @override
  String get rank_master => 'Time Master';
}
