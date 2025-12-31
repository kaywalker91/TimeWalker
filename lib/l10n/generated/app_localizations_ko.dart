// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'TimeWalker';

  @override
  String get common_error => '오류';

  @override
  String get common_confirm => '확인';

  @override
  String get common_cancel => '취소';

  @override
  String get common_close => '닫기';

  @override
  String get common_locked => '잠김';

  @override
  String get common_explore => '탐험하기';

  @override
  String get common_talk => '대화하기';

  @override
  String get common_locked_status => '잠겨있음';

  @override
  String get common_completed => '완료';

  @override
  String get common_unknown_character => '???';

  @override
  String get era_timeline_title => '시대 연대기';

  @override
  String get era_timeline_no_eras => '사용 가능한 시대가 없습니다.';

  @override
  String get era_timeline_locked_msg => '이 시대는 잠겨있습니다.';

  @override
  String get exploration_title_default => '탐험';

  @override
  String get exploration_tutorial_msg =>
      '탐험가여 환영합니다! 지도를 확대/축소하고 드래그로 이동하세요. 지도 아이콘에서 왕국 범례를 확인하고, 하단 목록 버튼으로 인물/장소를 빠르게 찾을 수 있습니다.';

  @override
  String get exploration_progress_label => '시대 진행률';

  @override
  String get exploration_era_not_found => '시대를 찾을 수 없습니다.';

  @override
  String exploration_location_error(Object error) {
    return '장소를 불러오는 중 오류 발생: $error';
  }

  @override
  String get exploration_location_locked => '이 장소는 아직 접근할 수 없습니다.';

  @override
  String get exploration_no_dialogue => '이 인물과는 아직 대화할 수 없습니다.';

  @override
  String get exploration_no_characters => '이 장소에는 현재 만날 수 있는 인물이 없습니다.';

  @override
  String get exploration_selected_label => '선택';

  @override
  String get exploration_list_locations => '장소 목록';

  @override
  String get exploration_list_characters => '인물 목록';

  @override
  String get exploration_tab_locations => '장소';

  @override
  String get exploration_tab_characters => '인물';

  @override
  String get exploration_no_locations => '장소가 없습니다.';

  @override
  String get exploration_legend_title => '왕국 필터';

  @override
  String get exploration_status_title => '상태';

  @override
  String get exploration_help_title => '탐험 도움말';

  @override
  String get menu_world_map => '세계 지도';

  @override
  String get menu_encyclopedia => '역사 도감';

  @override
  String get menu_quiz => '퀴즈 도전';

  @override
  String get menu_profile => '내 프로필';

  @override
  String get menu_settings => '설정';

  @override
  String get menu_shop => '상점';

  @override
  String get menu_leaderboard => '리더보드';

  @override
  String get msg_coming_soon => 'v1.5 출시 예정!';

  @override
  String get world_map_title => 'TimeWalker 세계 지도';

  @override
  String get world_map_current_location => '현재 위치';

  @override
  String get world_map_location_test => '아시아 - 한국';

  @override
  String world_map_locked_msg(Object region) {
    return '$region 지역은 현재 잠겨있습니다.';
  }

  @override
  String get app_tagline => '시간을 걷는 자가 되어 역사를 탐험하세요';

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
  String get profile_title => '내 프로필';

  @override
  String get profile_rank_progress => '랭크 진행도';

  @override
  String profile_next_rank_pts(Object points) {
    return '다음 랭크까지 $points점';
  }

  @override
  String get profile_stat_exploration => '탐험';

  @override
  String get profile_stat_collection => '수집';

  @override
  String get profile_stat_knowledge => '지식';

  @override
  String get profile_stat_playtime => '총 플레이 시간';

  @override
  String get profile_stat_eras => '방문한 시대';

  @override
  String profile_eras_count(Object count) {
    return '$count개 시대';
  }

  @override
  String get profile_stat_dialogues => '완료한 대화';

  @override
  String get common_error_stats_load => '통계를 불러오는데 실패했습니다.';

  @override
  String get rank_novice => '초보 탐험가';

  @override
  String get rank_apprentice => '견습 역사가';

  @override
  String get rank_intermediate => '중급 역사가';

  @override
  String get rank_advanced => '고급 역사가';

  @override
  String get rank_expert => '역사 전문가';

  @override
  String get rank_master => '역사 마스터';
}
