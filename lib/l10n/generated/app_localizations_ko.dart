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
}
