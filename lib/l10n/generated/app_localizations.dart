import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'TimeWalker'**
  String get appTitle;

  /// No description provided for @common_error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get common_error;

  /// No description provided for @common_confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get common_confirm;

  /// No description provided for @common_cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get common_cancel;

  /// No description provided for @common_close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get common_close;

  /// No description provided for @common_locked.
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get common_locked;

  /// No description provided for @common_explore.
  ///
  /// In ko, this message translates to:
  /// **'탐험하기'**
  String get common_explore;

  /// No description provided for @common_talk.
  ///
  /// In ko, this message translates to:
  /// **'대화하기'**
  String get common_talk;

  /// No description provided for @common_locked_status.
  ///
  /// In ko, this message translates to:
  /// **'잠겨있음'**
  String get common_locked_status;

  /// No description provided for @common_completed.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get common_completed;

  /// No description provided for @common_unknown_character.
  ///
  /// In ko, this message translates to:
  /// **'???'**
  String get common_unknown_character;

  /// No description provided for @era_timeline_title.
  ///
  /// In ko, this message translates to:
  /// **'시대 연대기'**
  String get era_timeline_title;

  /// No description provided for @era_timeline_no_eras.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 시대가 없습니다.'**
  String get era_timeline_no_eras;

  /// No description provided for @era_timeline_locked_msg.
  ///
  /// In ko, this message translates to:
  /// **'이 시대는 잠겨있습니다.'**
  String get era_timeline_locked_msg;

  /// No description provided for @exploration_title_default.
  ///
  /// In ko, this message translates to:
  /// **'탐험'**
  String get exploration_title_default;

  /// No description provided for @exploration_tutorial_msg.
  ///
  /// In ko, this message translates to:
  /// **'탐험가여 환영합니다! 지도를 확대/축소하고 드래그로 이동하세요. 지도 아이콘에서 왕국 범례를 확인하고, 하단 목록 버튼으로 인물/장소를 빠르게 찾을 수 있습니다.'**
  String get exploration_tutorial_msg;

  /// No description provided for @exploration_progress_label.
  ///
  /// In ko, this message translates to:
  /// **'시대 진행률'**
  String get exploration_progress_label;

  /// No description provided for @exploration_era_not_found.
  ///
  /// In ko, this message translates to:
  /// **'시대를 찾을 수 없습니다.'**
  String get exploration_era_not_found;

  /// No description provided for @exploration_location_error.
  ///
  /// In ko, this message translates to:
  /// **'장소를 불러오는 중 오류 발생: {error}'**
  String exploration_location_error(Object error);

  /// No description provided for @exploration_location_locked.
  ///
  /// In ko, this message translates to:
  /// **'이 장소는 아직 접근할 수 없습니다.'**
  String get exploration_location_locked;

  /// No description provided for @exploration_no_dialogue.
  ///
  /// In ko, this message translates to:
  /// **'이 인물과는 아직 대화할 수 없습니다.'**
  String get exploration_no_dialogue;

  /// No description provided for @exploration_no_characters.
  ///
  /// In ko, this message translates to:
  /// **'이 장소에는 현재 만날 수 있는 인물이 없습니다.'**
  String get exploration_no_characters;

  /// No description provided for @exploration_selected_label.
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get exploration_selected_label;

  /// No description provided for @exploration_list_locations.
  ///
  /// In ko, this message translates to:
  /// **'장소 목록'**
  String get exploration_list_locations;

  /// No description provided for @exploration_list_characters.
  ///
  /// In ko, this message translates to:
  /// **'인물 목록'**
  String get exploration_list_characters;

  /// No description provided for @exploration_tab_locations.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get exploration_tab_locations;

  /// No description provided for @exploration_tab_characters.
  ///
  /// In ko, this message translates to:
  /// **'인물'**
  String get exploration_tab_characters;

  /// No description provided for @exploration_no_locations.
  ///
  /// In ko, this message translates to:
  /// **'장소가 없습니다.'**
  String get exploration_no_locations;

  /// No description provided for @exploration_legend_title.
  ///
  /// In ko, this message translates to:
  /// **'왕국 필터'**
  String get exploration_legend_title;

  /// No description provided for @exploration_status_title.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get exploration_status_title;

  /// No description provided for @exploration_help_title.
  ///
  /// In ko, this message translates to:
  /// **'탐험 도움말'**
  String get exploration_help_title;

  /// No description provided for @menu_world_map.
  ///
  /// In ko, this message translates to:
  /// **'세계 지도'**
  String get menu_world_map;

  /// No description provided for @menu_encyclopedia.
  ///
  /// In ko, this message translates to:
  /// **'역사 도감'**
  String get menu_encyclopedia;

  /// No description provided for @menu_quiz.
  ///
  /// In ko, this message translates to:
  /// **'퀴즈 도전'**
  String get menu_quiz;

  /// No description provided for @menu_profile.
  ///
  /// In ko, this message translates to:
  /// **'내 프로필'**
  String get menu_profile;

  /// No description provided for @menu_settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get menu_settings;

  /// No description provided for @menu_shop.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get menu_shop;

  /// No description provided for @menu_leaderboard.
  ///
  /// In ko, this message translates to:
  /// **'리더보드'**
  String get menu_leaderboard;

  /// No description provided for @msg_coming_soon.
  ///
  /// In ko, this message translates to:
  /// **'v1.5 출시 예정!'**
  String get msg_coming_soon;

  /// No description provided for @world_map_title.
  ///
  /// In ko, this message translates to:
  /// **'TimeWalker 세계 지도'**
  String get world_map_title;

  /// No description provided for @world_map_current_location.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치'**
  String get world_map_current_location;

  /// No description provided for @world_map_location_test.
  ///
  /// In ko, this message translates to:
  /// **'아시아 - 한국'**
  String get world_map_location_test;

  /// No description provided for @world_map_locked_msg.
  ///
  /// In ko, this message translates to:
  /// **'{region} 지역은 현재 잠겨있습니다.'**
  String world_map_locked_msg(Object region);

  /// No description provided for @app_tagline.
  ///
  /// In ko, this message translates to:
  /// **'시간을 걷는 자가 되어 역사를 탐험하세요'**
  String get app_tagline;

  /// No description provided for @quiz_title.
  ///
  /// In ko, this message translates to:
  /// **'역사 퀴즈'**
  String get quiz_title;

  /// No description provided for @quiz_completed_count.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 완료'**
  String quiz_completed_count(Object count);

  /// No description provided for @quiz_filter_all.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get quiz_filter_all;

  /// No description provided for @quiz_filter_completed.
  ///
  /// In ko, this message translates to:
  /// **'맞춘 퀴즈'**
  String get quiz_filter_completed;

  /// No description provided for @quiz_category_all.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get quiz_category_all;

  /// No description provided for @quiz_empty_completed.
  ///
  /// In ko, this message translates to:
  /// **'아직 맞춘 퀴즈가 없습니다.\n퀴즈에 도전해보세요!'**
  String get quiz_empty_completed;

  /// No description provided for @quiz_empty_all.
  ///
  /// In ko, this message translates to:
  /// **'퀴즈가 없습니다.'**
  String get quiz_empty_all;

  /// No description provided for @quiz_pts.
  ///
  /// In ko, this message translates to:
  /// **'pts'**
  String get quiz_pts;

  /// No description provided for @quiz_sec.
  ///
  /// In ko, this message translates to:
  /// **'s'**
  String get quiz_sec;

  /// No description provided for @quiz_view_explanation.
  ///
  /// In ko, this message translates to:
  /// **'해설 보기'**
  String get quiz_view_explanation;

  /// No description provided for @quiz_retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 풀기'**
  String get quiz_retry;

  /// No description provided for @quiz_start_challenge.
  ///
  /// In ko, this message translates to:
  /// **'도전하기'**
  String get quiz_start_challenge;

  /// No description provided for @quiz_correct_message.
  ///
  /// In ko, this message translates to:
  /// **'정답을 맞췄습니다!'**
  String get quiz_correct_message;

  /// No description provided for @quiz_points_earned.
  ///
  /// In ko, this message translates to:
  /// **'{points}포인트 획득'**
  String quiz_points_earned(Object points);

  /// No description provided for @quiz_question.
  ///
  /// In ko, this message translates to:
  /// **'문제'**
  String get quiz_question;

  /// No description provided for @quiz_options.
  ///
  /// In ko, this message translates to:
  /// **'선택지'**
  String get quiz_options;

  /// No description provided for @quiz_explanation.
  ///
  /// In ko, this message translates to:
  /// **'해설'**
  String get quiz_explanation;

  /// No description provided for @quiz_close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get quiz_close;

  /// No description provided for @shop_title.
  ///
  /// In ko, this message translates to:
  /// **'아이템 상점'**
  String get shop_title;

  /// No description provided for @shop_tab_all.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get shop_tab_all;

  /// No description provided for @shop_tab_consumable.
  ///
  /// In ko, this message translates to:
  /// **'소모품'**
  String get shop_tab_consumable;

  /// No description provided for @shop_tab_cosmetic.
  ///
  /// In ko, this message translates to:
  /// **'치장'**
  String get shop_tab_cosmetic;

  /// No description provided for @shop_tab_upgrade.
  ///
  /// In ko, this message translates to:
  /// **'강화'**
  String get shop_tab_upgrade;

  /// No description provided for @shop_purchase_error_coins.
  ///
  /// In ko, this message translates to:
  /// **'코인이 부족합니다!'**
  String get shop_purchase_error_coins;

  /// No description provided for @shop_purchase_error_owned.
  ///
  /// In ko, this message translates to:
  /// **'이미 보유한 아이템입니다!'**
  String get shop_purchase_error_owned;

  /// No description provided for @shop_confirm_title.
  ///
  /// In ko, this message translates to:
  /// **'구매 확인'**
  String get shop_confirm_title;

  /// No description provided for @shop_confirm_message.
  ///
  /// In ko, this message translates to:
  /// **'{item}을(를) {price} 코인에 구매하시겠습니까?'**
  String shop_confirm_message(Object item, Object price);

  /// No description provided for @common_buy.
  ///
  /// In ko, this message translates to:
  /// **'구매'**
  String get common_buy;

  /// No description provided for @shop_purchase_success.
  ///
  /// In ko, this message translates to:
  /// **'{item} 구매 완료!'**
  String shop_purchase_success(Object item);

  /// No description provided for @shop_empty_list.
  ///
  /// In ko, this message translates to:
  /// **'구매 가능한 아이템이 없습니다.'**
  String get shop_empty_list;

  /// No description provided for @shop_item_owned.
  ///
  /// In ko, this message translates to:
  /// **'보유중'**
  String get shop_item_owned;

  /// No description provided for @shop_item_price.
  ///
  /// In ko, this message translates to:
  /// **'{price} 코인'**
  String shop_item_price(Object price);

  /// No description provided for @profile_title.
  ///
  /// In ko, this message translates to:
  /// **'내 프로필'**
  String get profile_title;

  /// No description provided for @profile_rank_progress.
  ///
  /// In ko, this message translates to:
  /// **'랭크 진행도'**
  String get profile_rank_progress;

  /// No description provided for @profile_next_rank_pts.
  ///
  /// In ko, this message translates to:
  /// **'다음 랭크까지 {points}점'**
  String profile_next_rank_pts(Object points);

  /// No description provided for @profile_stat_exploration.
  ///
  /// In ko, this message translates to:
  /// **'탐험'**
  String get profile_stat_exploration;

  /// No description provided for @profile_stat_collection.
  ///
  /// In ko, this message translates to:
  /// **'수집'**
  String get profile_stat_collection;

  /// No description provided for @profile_stat_knowledge.
  ///
  /// In ko, this message translates to:
  /// **'지식'**
  String get profile_stat_knowledge;

  /// No description provided for @profile_stat_playtime.
  ///
  /// In ko, this message translates to:
  /// **'총 플레이 시간'**
  String get profile_stat_playtime;

  /// No description provided for @profile_stat_eras.
  ///
  /// In ko, this message translates to:
  /// **'방문한 시대'**
  String get profile_stat_eras;

  /// No description provided for @profile_eras_count.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 시대'**
  String profile_eras_count(Object count);

  /// No description provided for @profile_stat_dialogues.
  ///
  /// In ko, this message translates to:
  /// **'완료한 대화'**
  String get profile_stat_dialogues;

  /// No description provided for @common_error_stats_load.
  ///
  /// In ko, this message translates to:
  /// **'통계를 불러오는데 실패했습니다.'**
  String get common_error_stats_load;

  /// No description provided for @rank_novice.
  ///
  /// In ko, this message translates to:
  /// **'초보 탐험가'**
  String get rank_novice;

  /// No description provided for @rank_apprentice.
  ///
  /// In ko, this message translates to:
  /// **'견습 역사가'**
  String get rank_apprentice;

  /// No description provided for @rank_intermediate.
  ///
  /// In ko, this message translates to:
  /// **'중급 역사가'**
  String get rank_intermediate;

  /// No description provided for @rank_advanced.
  ///
  /// In ko, this message translates to:
  /// **'고급 역사가'**
  String get rank_advanced;

  /// No description provided for @rank_expert.
  ///
  /// In ko, this message translates to:
  /// **'역사 전문가'**
  String get rank_expert;

  /// No description provided for @rank_master.
  ///
  /// In ko, this message translates to:
  /// **'역사 마스터'**
  String get rank_master;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
