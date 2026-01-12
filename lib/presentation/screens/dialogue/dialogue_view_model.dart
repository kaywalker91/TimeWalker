import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== State ==============

class DialogueState {
  final Dialogue? dialogue;
  final DialogueNode? currentNode;
  final String displayedText;
  final bool isTyping;
  final bool isCompleted;
  final List<DialogueNode> history;
  final List<UnlockEvent> unlockEvents; // Added
  final DialogueReward? lastReward; // 마지막으로 획득한 보상 (UI 표시용)

  const DialogueState({
    this.dialogue,
    this.currentNode,
    this.displayedText = '',
    this.isTyping = false,
    this.isCompleted = false,
    this.history = const [],
    this.unlockEvents = const [],
    this.lastReward,
  });

  DialogueState copyWith({
    Dialogue? dialogue,
    DialogueNode? currentNode,
    String? displayedText,
    bool? isTyping,
    bool? isCompleted,
    List<DialogueNode>? history,
    List<UnlockEvent>? unlockEvents,
    DialogueReward? lastReward,
  }) {
    return DialogueState(
      dialogue: dialogue ?? this.dialogue,
      currentNode: currentNode ?? this.currentNode,
      displayedText: displayedText ?? this.displayedText,
      isTyping: isTyping ?? this.isTyping,
      isCompleted: isCompleted ?? this.isCompleted,
      history: history ?? this.history,
      unlockEvents: unlockEvents ?? this.unlockEvents,
      lastReward: lastReward,
    );
  }
}

// ============== ViewModel (Notifier) ==============

class DialogueViewModel extends StateNotifier<DialogueState> {
  final Ref ref;
  Timer? _typingTimer;

  DialogueViewModel(this.ref) : super(const DialogueState());

  Future<void> initialize(String dialogueId) async {
    _log('initialize dialogueId=$dialogueId');
    state = const DialogueState(); // Reset
    final dialogue = await ref.read(dialogueByIdProvider(dialogueId).future);
    if (dialogue == null) {
      _log('dialogue not found id=$dialogueId');
      return;
    }

    final startNode = dialogue.startNode;
    _log(
      'dialogue loaded id=${dialogue.id} nodes=${dialogue.nodes.length} start=${startNode?.id ?? 'null'}',
    );
    state = state.copyWith(
      dialogue: dialogue,
      currentNode: startNode,
      history: [],
    );

    if (startNode != null) {
      _startTyping(startNode.text);
    }
  }

  void _startTyping(String fullText) {
    _typingTimer?.cancel();
    state = state.copyWith(isTyping: true, displayedText: '');

    int currentIndex = 0;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (currentIndex < fullText.length) {
        currentIndex++;
        state = state.copyWith(
          displayedText: fullText.substring(0, currentIndex),
        );
      } else {
        _stopTyping();
      }
    });
  }

  void _stopTyping() {
    _typingTimer?.cancel();
    if (state.currentNode != null) {
      state = state.copyWith(
        isTyping: false,
        displayedText: state.currentNode!.text,
      );
    }
  }

  void skipTyping() {
    if (state.isTyping) {
      _stopTyping();
    }
  }

  /// 선택지 선택 처리 (보상 지급 포함)
  Future<void> selectChoice(DialogueChoice choice) async {
    if (state.isTyping) return;
    
    // 1. 조건 검증
    if (!_canSelectChoice(choice)) {
      // 조건 미충족 시 안내 (UI에서 처리)
      return;
    }
    
    // 2. 선택지 보상 처리
    if (choice.reward != null) {
      await _applyReward(choice.reward!);
      // 보상 표시를 위한 상태 업데이트
      state = state.copyWith(lastReward: choice.reward);
    }
    
    // 3. 노드 이동
    _moveToNode(choice.nextNodeId);
  }
  
  /// 선택지 선택 가능 여부 확인 (조건 검증)
  bool _canSelectChoice(DialogueChoice choice) {
    if (choice.condition == null) return true;
    
    final progress = ref.read(userProgressProvider).value;
    if (progress == null) return false;
    
    final condition = choice.condition!;
    
    // 지식 포인트 확인
    if (condition.requiredKnowledge != null) {
      if (progress.totalKnowledge < condition.requiredKnowledge!) {
        return false;
      }
    }
    
    // 역사 사실 확인
    if (condition.requiredFact != null) {
      if (!progress.unlockedFactIds.contains(condition.requiredFact)) {
        return false;
      }
    }
    
    // 인물 해금 확인
    if (condition.requiredCharacter != null) {
      if (!progress.unlockedCharacterIds.contains(condition.requiredCharacter)) {
        return false;
      }
    }
    
    return true;
  }
  
  /// 보상 적용 (선택지 또는 노드 보상)
  Future<void> _applyReward(DialogueReward reward) async {
    if (!reward.hasReward) return;
    
    await ref.read(userProgressProvider.notifier).updateProgress((progress) {
      var updated = progress.copyWith(
        totalKnowledge: progress.totalKnowledge + reward.knowledgePoints,
      );
      
      // 역사 사실 해금
      if (reward.unlockFactId != null && 
          !updated.unlockedFactIds.contains(reward.unlockFactId)) {
        updated = updated.copyWith(
          unlockedFactIds: [...updated.unlockedFactIds, reward.unlockFactId!],
        );
      }
      
      // 인물 해금
      if (reward.unlockCharacterId != null && 
          !updated.unlockedCharacterIds.contains(reward.unlockCharacterId)) {
        updated = updated.copyWith(
          unlockedCharacterIds: [...updated.unlockedCharacterIds, reward.unlockCharacterId!],
        );
      }
      
      // 업적 획득
      if (reward.achievementId != null && 
          !updated.achievementIds.contains(reward.achievementId)) {
        updated = updated.copyWith(
          achievementIds: [...updated.achievementIds, reward.achievementId!],
        );
      }
      
      return updated;
    });
  }

  void next() {
    if (state.isTyping) {
      skipTyping();
      return;
    }
    final currentNode = state.currentNode;
    if (currentNode == null) return;

    if (currentNode.isEnd) {
      _finishDialogue();
    } else if (!currentNode.hasChoices && currentNode.nextNodeId != null) {
      _moveToNode(currentNode.nextNodeId!);
    }
  }

  void _moveToNode(String nodeId) {
    final dialogue = state.dialogue;
    if (dialogue == null) {
      _log('moveToNode ignored dialogue=null nodeId=$nodeId');
      return;
    }

    final nextNode = dialogue.getNodeById(nodeId);
    _log(
      'moveToNode nodeId=$nodeId resolved=${nextNode?.id ?? 'null'}',
    );
    if (nextNode != null) {
      // 노드 보상 처리 (있는 경우)
      if (nextNode.reward != null) {
        _applyReward(nextNode.reward!);
        // 보상 표시를 위한 상태 업데이트
        state = state.copyWith(lastReward: nextNode.reward);
      }
      
      state = state.copyWith(
        history: [...state.history, state.currentNode!],
        currentNode: nextNode,
        lastReward: null, // 새 노드로 이동 시 보상 초기화
      );
      _startTyping(nextNode.text);
    } else {
      _finishDialogue();
    }
  }

  Future<void> _finishDialogue() async {
    _log('finishDialogue start');
    // state = state.copyWith(isCompleted: true); // Move to after update to capture events first? No, UI needs to know completion.
    // Actually, let's keep isCompleted = true, but we'll add events.
    
    // Save Progress logic
    final dialogue = state.dialogue;
    if (dialogue != null) {
      _log('finishDialogue dialogueId=${dialogue.id}');
      // 1. Calculate Rewards
      
      // 2. Update User Progress
      // Fetch Character to get Era ID
      final character = await ref.read(characterRepositoryProvider).getCharacterById(dialogue.characterId);
      final eraId = character?.eraId;
      final characterId = dialogue.characterId;
      _log(
        'finishDialogue characterId=$characterId eraId=${eraId ?? 'null'}',
      );

      // 진행률 계산을 위해 먼저 대화 목록 가져오기
      List<Dialogue> eraDialogues = [];
      if (eraId != null) {
        eraDialogues = await ref.read(dialogueRepositoryProvider).getDialoguesByEra(eraId);
      }
      
      final progressionService = ref.read(progressionServiceProvider);
      
      // 추가 해금 이벤트 목록 (인물 해금용)
      final additionalUnlocks = <UnlockEvent>[];
      
      final unlocks = await ref.read(userProgressProvider.notifier).updateProgress((progress) {
        // Check if already completed to avoid double dipping knowledge points
        if (progress.isDialogueCompleted(dialogue.id)) {
          return progress;
        }

        final newCompleted = [...progress.completedDialogueIds, dialogue.id];
        
        // 대화 레벨 보상 적용 (이미 선택지/노드에서 받은 보상 제외)
        // 대화 완료 보상은 별도로 처리하지 않고, 선택지/노드 보상만 누적
        final newKnowledge = progress.totalKnowledge;

        Map<String, double> newEraProgress = progress.eraProgress;
        if (eraId != null && eraDialogues.isNotEmpty) {
          // 정확한 진행률 계산
          // 임시로 완료된 대화 목록에 현재 대화 추가하여 계산
          final tempProgress = progress.copyWith(completedDialogueIds: newCompleted);
          final eraProgress = progressionService.calculateEraProgress(
            eraId,
            tempProgress,
            eraDialogues,
          );
          
          newEraProgress = {
            ...progress.eraProgress,
            eraId: eraProgress,
          };
        }

        // 3. 인물 해금 처리 - 대화 완료 시 자동으로 역사 도감에 추가
        List<String> newUnlockedCharacterIds = progress.unlockedCharacterIds;
        Map<String, DateTime> newEncyclopediaDiscoveryDates = progress.encyclopediaDiscoveryDates;
        
        // 인물이 아직 해금되지 않은 경우에만 추가
        if (!progress.unlockedCharacterIds.contains(characterId)) {
          newUnlockedCharacterIds = [...progress.unlockedCharacterIds, characterId];
          _log('Character unlocked: $characterId');
          
          // 인물 해금 이벤트 추가
          additionalUnlocks.add(UnlockEvent(
            type: UnlockType.character,
            id: characterId,
            name: character?.nameKorean ?? characterId,
            message: '${character?.nameKorean ?? '인물'}이(가) 역사 도감에 추가되었습니다!',
          ));
        }
        
        // 도감에 인물 ID와 발견 날짜 추가 (역사 도감 발견 처리)
        if (!progress.isEncyclopediaDiscovered(characterId)) {
          newEncyclopediaDiscoveryDates = {
            ...progress.encyclopediaDiscoveryDates,
            characterId: DateTime.now(), // 현재 시간으로 발견 날짜 기록
          };
          _log('Encyclopedia entry discovered: $characterId at ${DateTime.now()}');
          
          // 역사 도감 발견 이벤트 추가
          additionalUnlocks.add(UnlockEvent(
            type: UnlockType.encyclopedia,
            id: characterId,
            name: character?.nameKorean ?? characterId,
            message: '역사 도감에 새로운 항목이 추가되었습니다!',
          ));
        }

        // Update basic progress
        return progress.copyWith(
          completedDialogueIds: newCompleted,
          totalKnowledge: newKnowledge,
          eraProgress: newEraProgress,
          unlockedCharacterIds: newUnlockedCharacterIds,
          encyclopediaDiscoveryDates: newEncyclopediaDiscoveryDates,
        );
      });
      
      // 기존 해금 이벤트와 추가 해금 이벤트 합치기
      final allUnlocks = [...unlocks, ...additionalUnlocks];
      
      // 4. Update state with unlocks and completion status
      state = state.copyWith(
        isCompleted: true,
        unlockEvents: allUnlocks,
      );
    } else {
        state = state.copyWith(isCompleted: true);
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _log(String message) {
    debugPrint('[DialogueViewModel] $message');
  }
}

// Provider
final dialogueViewModelProvider =
    StateNotifierProvider.family<DialogueViewModel, DialogueState, String>((
      ref,
      dialogueId,
    ) {
      return DialogueViewModel(ref);
    });
