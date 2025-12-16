import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/services/progression_service.dart'; // Added
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

  const DialogueState({
    this.dialogue,
    this.currentNode,
    this.displayedText = '',
    this.isTyping = false,
    this.isCompleted = false,
    this.history = const [],
    this.unlockEvents = const [],
  });

  DialogueState copyWith({
    Dialogue? dialogue,
    DialogueNode? currentNode,
    String? displayedText,
    bool? isTyping,
    bool? isCompleted,
    List<DialogueNode>? history,
    List<UnlockEvent>? unlockEvents,
  }) {
    return DialogueState(
      dialogue: dialogue ?? this.dialogue,
      currentNode: currentNode ?? this.currentNode,
      displayedText: displayedText ?? this.displayedText,
      isTyping: isTyping ?? this.isTyping,
      isCompleted: isCompleted ?? this.isCompleted,
      history: history ?? this.history,
      unlockEvents: unlockEvents ?? this.unlockEvents,
    );
  }
}

// ============== ViewModel (Notifier) ==============

class DialogueViewModel extends StateNotifier<DialogueState> {
  final Ref ref;
  Timer? _typingTimer;

  DialogueViewModel(this.ref) : super(const DialogueState());

  Future<void> initialize(String dialogueId) async {
    state = const DialogueState(); // Reset
    final dialogue = await ref.read(dialogueByIdProvider(dialogueId).future);
    if (dialogue == null) return;

    final startNode = dialogue.startNode;
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

  void selectChoice(DialogueChoice choice) {
    if (state.isTyping) return;
    // Process reward here if needed
    _moveToNode(choice.nextNodeId);
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
    if (dialogue == null) return;

    final nextNode = dialogue.getNodeById(nodeId);
    if (nextNode != null) {
      state = state.copyWith(
        history: [...state.history, state.currentNode!],
        currentNode: nextNode,
      );
      _startTyping(nextNode.text);
    } else {
      _finishDialogue();
    }
  }

  Future<void> _finishDialogue() async {
    // state = state.copyWith(isCompleted: true); // Move to after update to capture events first? No, UI needs to know completion.
    // Actually, let's keep isCompleted = true, but we'll add events.
    
    // Save Progress logic
    final dialogue = state.dialogue;
    if (dialogue != null) {
      // 1. Calculate Rewards
      
      // 2. Update User Progress
      // Fetch Character to get Era ID
      final character = await ref.read(characterRepositoryProvider).getCharacterById(dialogue.characterId);
      final eraId = character?.eraId;

      final unlocks = await ref.read(userProgressProvider.notifier).updateProgress((progress) {
        // Check if already completed to avoid double dipping knowledge points
        if (progress.isDialogueCompleted(dialogue.id)) {
          return progress;
        }

        final newCompleted = [...progress.completedDialogueIds, dialogue.id];
        final newKnowledge =
            progress.totalKnowledge + dialogue.totalRewardPoints;

        Map<String, double> newEraProgress = progress.eraProgress;
        if (eraId != null) {
          final currentEraProgress = progress.getEraProgress(eraId);
          // Increment progress (e.g., 0.1 per dialogue for MVP)
          final nextProgress = (currentEraProgress + 0.1).clamp(0.0, 1.0);
          
          newEraProgress = {
            ...progress.eraProgress,
            eraId: nextProgress,
          };
        }

        // Update basic progress
        return progress.copyWith(
          completedDialogueIds: newCompleted,
          totalKnowledge: newKnowledge,
          eraProgress: newEraProgress,
        );
      });
      
      // 3. Update state with unlocks and completion status
      state = state.copyWith(
        isCompleted: true,
        unlockEvents: unlocks,
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
}

// Provider
final dialogueViewModelProvider =
    StateNotifierProvider.family<DialogueViewModel, DialogueState, String>((
      ref,
      dialogueId,
    ) {
      return DialogueViewModel(ref);
    });
