/// TimeWalker 퀴즈 엔티티 라이브러리
/// 
/// 퀴즈 관련 모든 엔티티를 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/domain/entities/quiz/quiz_entities.dart';
/// 
/// final quiz = Quiz(
///   id: 'sejong_hangul_01',
///   question: '한글은 언제 창제되었나요?',
///   type: QuizType.multipleChoice,
///   difficulty: QuizDifficulty.easy,
///   options: ['1443년', '1446년', '1450년', '1456년'],
///   correctAnswer: '1443년',
///   explanation: '한글은 1443년에 창제되었습니다.',
///   eraId: 'joseon',
/// );
/// ```
library;

export 'quiz_enums.dart';
export 'quiz_entity.dart';
export 'quiz_session.dart';
