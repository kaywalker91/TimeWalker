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
  String get common_completed => '완료';

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
  String get quiz_title => '역사 퀴즈';

  @override
  String quiz_completed_count(Object count) {
    return '$count개 완료';
  }

  @override
  String get quiz_filter_all => '전체';

  @override
  String get quiz_filter_completed => '맞춘 퀴즈';

  @override
  String get quiz_category_all => '전체';

  @override
  String get quiz_empty_completed => '아직 맞춘 퀴즈가 없습니다.\n퀴즈에 도전해보세요!';

  @override
  String get quiz_empty_all => '퀴즈가 없습니다.';

  @override
  String get quiz_pts => 'pts';

  @override
  String get quiz_sec => 's';

  @override
  String get quiz_view_explanation => '해설 보기';

  @override
  String get quiz_retry => '다시 풀기';

  @override
  String get quiz_start_challenge => '도전하기';

  @override
  String get quiz_correct_message => '정답을 맞췄습니다!';

  @override
  String quiz_points_earned(Object points) {
    return '$points포인트 획득';
  }

  @override
  String get quiz_question => '문제';

  @override
  String get quiz_options => '선택지';

  @override
  String get quiz_explanation => '해설';

  @override
  String get quiz_close => '닫기';

  @override
  String get shop_title => '아이템 상점';

  @override
  String get shop_tab_all => '전체';

  @override
  String get shop_tab_consumable => '소모품';

  @override
  String get shop_tab_cosmetic => '치장';

  @override
  String get shop_tab_upgrade => '강화';

  @override
  String get shop_purchase_error_coins => '코인이 부족합니다!';

  @override
  String get shop_purchase_error_owned => '이미 보유한 아이템입니다!';

  @override
  String get shop_confirm_title => '구매 확인';

  @override
  String shop_confirm_message(Object item, Object price) {
    return '$item을(를) $price 코인에 구매하시겠습니까?';
  }

  @override
  String get common_buy => '구매';

  @override
  String shop_purchase_success(Object item) {
    return '$item 구매 완료!';
  }

  @override
  String get shop_empty_list => '구매 가능한 아이템이 없습니다.';

  @override
  String get shop_item_owned => '보유중';

  @override
  String shop_item_price(Object price) {
    return '$price 코인';
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
