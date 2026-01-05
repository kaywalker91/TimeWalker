/// TimeWalker 대화 위젯 라이브러리
/// 
/// 대화 화면에서 사용되는 위젯들을 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/presentation/widgets/dialogue/dialogue_widgets.dart';
/// 
/// // 대화 박스
/// DialogueBox(
///   state: dialogueState,
///   speakerName: '세종대왕',
///   onNext: () => advanceDialogue(),
/// );
/// 
/// // 캐릭터 초상화
/// CharacterPortrait(
///   character: character,
///   emotion: 'happy',
/// );
/// 
/// // 깜빡이는 커서
/// BlinkingCursor();
/// 
/// // 로드 실패 화면
/// DialogueLoadFailure(
///   message: '대화를 불러올 수 없습니다',
///   onClose: () => Navigator.pop(context),
/// );
/// ```
library;

export 'blinking_cursor.dart';
export 'character_portrait.dart';
export 'dialogue_box.dart';
export 'dialogue_choices_panel.dart';
export 'dialogue_completion_dialog.dart';
export 'dialogue_load_failure.dart';
export 'reward_notification.dart';
