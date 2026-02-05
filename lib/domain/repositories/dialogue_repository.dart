import 'package:time_walker/domain/entities/dialogue.dart';

abstract class DialogueRepository {
  /// 모든 대화 목록 가져오기
  Future<List<Dialogue>> getAllDialogues();

  /// 특정 시대의 대화 목록 가져오기
  Future<List<Dialogue>> getDialoguesByEra(String eraId);

  /// 특정 인물의 대화 목록 가져오기
  Future<List<Dialogue>> getDialoguesByCharacter(String characterId);

  /// 대화 ID로 대화 정보 가져오기
  Future<Dialogue?> getDialogueById(String id);

  /// 여러 대화 ID로 대화 목록 가져오기 (N+1 방지용 배치 쿼리)
  Future<List<Dialogue>> getDialoguesByIds(List<String> ids);

  /// 대화 진행 상태 저장
  Future<void> saveDialogueProgress(DialogueProgress progress);

  /// 대화 진행 상태 가져오기
  Future<DialogueProgress?> getDialogueProgress(String dialogueId);
}
