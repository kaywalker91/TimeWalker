/// TimeWalker 대화 엔티티 라이브러리
/// 
/// 대화 관련 모든 엔티티를 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/domain/entities/dialogue/dialogue_entities.dart';
/// 
/// final dialogue = Dialogue(
///   id: 'sejong_01',
///   characterId: 'sejong',
///   title: 'Meeting King Sejong',
///   titleKorean: '세종대왕과의 만남',
///   description: '한글 창제의 비밀을 알아보세요.',
///   nodes: [...],
/// );
/// ```
library;

export 'dialogue_reward.dart';
export 'dialogue_choice.dart';
export 'dialogue_node.dart';
export 'dialogue_entity.dart';
export 'dialogue_progress.dart';
