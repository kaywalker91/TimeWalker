import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/dialogue/dialogue_widgets.dart';

class DialogueScreen extends ConsumerStatefulWidget {
  final String dialogueId;
  final String eraId;

  const DialogueScreen({
    super.key,
    required this.dialogueId,
    required this.eraId,
  });

  @override
  ConsumerState<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends ConsumerState<DialogueScreen> {
  @override
  void initState() {
    super.initState();
    _log(
      'initState dialogueId=${widget.dialogueId} eraId=${widget.eraId}',
    );
    // Initialize Logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dialogueViewModelProvider(widget.dialogueId).notifier)
          .initialize(widget.dialogueId);
      
      // 관련 퀴즈 미리 로드 (대화 완료 시점에서 사용)
      ref.read(quizListByDialogueProvider(widget.dialogueId));
      
      // BGM 시작 (대화 BGM)
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmDialogue) {
        ref.read(bgmControllerProvider.notifier).playDialogueBgm();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('[DialogueScreen] dispose - dialogueId=${widget.dialogueId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    void closeAction() => _handleDialogueExit(context);
    // Listen for completion state change
    ref.listen(dialogueViewModelProvider(widget.dialogueId), (previous, next) {
      if (previous?.isCompleted == false && next.isCompleted) {
        _showCompletionDialog(next.unlockEvents);
      }
      if (previous?.dialogue == null && next.dialogue != null) {
        _log(
          'dialogue loaded id=${next.dialogue!.id} nodes=${next.dialogue!.nodes.length}',
        );
      }
      if (previous?.currentNode?.id != next.currentNode?.id) {
        _log(
          'node changed ${previous?.currentNode?.id ?? 'null'} -> ${next.currentNode?.id ?? 'null'}',
        );
      }
    });
    ref.listen(dialogueByIdProvider(widget.dialogueId), (previous, next) {
      next.when(
        data: (dialogue) => _log(
          'dialogueById resolved id=${dialogue?.id ?? 'null'} nodes=${dialogue?.nodes.length ?? 0}',
        ),
        error: (err, _) => _log('dialogueById error=$err'),
        loading: () => _log('dialogueById loading'),
      );
    });
    ref.listen(characterListByEraProvider(widget.eraId), (previous, next) {
      next.when(
        data: (characters) => _log(
          'charactersByEra resolved eraId=${widget.eraId} count=${characters.length}',
        ),
        error: (err, _) => _log('charactersByEra error=$err'),
        loading: () => _log('charactersByEra loading eraId=${widget.eraId}'),
      );
    });

    final state = ref.watch(dialogueViewModelProvider(widget.dialogueId));
    final dialogueAsync = ref.watch(dialogueByIdProvider(widget.dialogueId));

    if (widget.dialogueId.isEmpty || widget.eraId.isEmpty) {
      _log(
        'missing params dialogueId="${widget.dialogueId}" eraId="${widget.eraId}"',
      );
      return DialogueLoadFailure(
        message: l10n.exploration_no_dialogue,
        onClose: closeAction,
      );
    }

    if (state.dialogue == null || state.currentNode == null) {
      _log('state missing dialogue/currentNode');
      return dialogueAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => DialogueLoadFailure(
          message: l10n.exploration_no_dialogue,
          onClose: closeAction,
        ),
        data: (dialogue) {
          if (dialogue == null) {
            return DialogueLoadFailure(
              message: l10n.exploration_no_dialogue,
              onClose: closeAction,
            );
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    }
    // Fetch Speaker Character Data
    final speakerAsync = ref.watch(characterListByEraProvider(widget.eraId));
    final characters = speakerAsync.valueOrNull ?? const <Character>[];
    final speakerId = state.currentNode?.speakerId;
    Character? speaker;
    if (speakerId != null) {
      try {
        speaker = characters.firstWhere((c) => c.id == speakerId);
      } catch (_) {
        speaker = null;
      }
    }
    if (speaker == null) {
      _log('speaker not found speakerId=${speakerId ?? 'null'}');
    }
    final speakerName = _resolveSpeakerName(
      l10n: l10n,
      speakerId: speakerId,
      character: speaker,
    );

    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background (Dimmed)
          Positioned.fill(
            child: Container(
              color: AppColors.dialogueBackground,
              // TODO: Add Era Background Image with Blur
            ),
          ),
          
          // 1.5. Reward Notification Overlay
          RewardOverlay(reward: state.lastReward),

          // 2. Character Portrait (Center)
          Positioned.fill(
            bottom: 200, // Leave space for dialogue box
            child: speaker == null
                ? PlaceholderPortrait(label: speakerName)
                : CharacterPortrait(
                    character: speaker,
                    emotion: state.currentNode!.emotion,
                  ),
          ),

          // 3. Dialogue Box (Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DialogueBox(
              state: state,
              speakerName: speakerName,
              onNext: () => ref
                  .read(dialogueViewModelProvider(widget.dialogueId).notifier)
                  .next(),
            ),
          ),

          // 4. Choices Overlay (Center/Bottom) - NEW LAYER
          if (!state.isTyping && (state.currentNode?.hasChoices ?? false))
            Positioned.fill(
              bottom: 250, // Above the dialogue box
              child: Container(
                color: Colors.black54, // Dim background behind choices for focus
                padding: const EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.currentNode!.choices.map((choice) {
                      // 조건 검증
                      final userProgress = ref.watch(userProgressProvider).value;
                      final canSelect = _canSelectChoice(choice, userProgress);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Tooltip(
                          message: !canSelect && choice.condition != null
                              ? _getConditionMessage(choice.condition!, userProgress)
                              : choice.preview ?? '',
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canSelect
                                  ? AppColors.dialogueChoiceActive
                                  : AppColors.dialogueChoiceInactive,
                              foregroundColor: canSelect
                                  ? AppColors.textPrimary
                                  : AppColors.textDisabled,
                              side: BorderSide(
                                color: canSelect
                                    ? AppColors.dialogueChoiceBorder
                                    : AppColors.border,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: canSelect ? 8 : 2,
                              minimumSize: const Size(double.infinity, 56),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                            ),
                            onPressed: canSelect
                                ? () async {
                                    await ref
                                        .read(dialogueViewModelProvider(widget.dialogueId)
                                            .notifier)
                                        .selectChoice(choice);
                                  }
                                : null,
                            child: Text(
                              choice.text,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: canSelect ? Colors.white : Colors.white38,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          // 4. Close Button (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: closeAction,
            ),
          ),
        ],
      ),
    );
  }

  void _log(String message) {
    debugPrint('[DialogueScreen] $message');
  }

  /// 선택지 선택 가능 여부 확인
  bool _canSelectChoice(DialogueChoice choice, UserProgress? progress) {
    if (choice.condition == null) return true;
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
  
  /// 조건 미충족 메시지 생성
  String _getConditionMessage(ChoiceCondition condition, UserProgress? progress) {
    if (progress == null) return '진행 상태를 불러올 수 없습니다.';
    
    if (condition.requiredKnowledge != null) {
      final needed = condition.requiredKnowledge! - progress.totalKnowledge;
      if (needed > 0) {
        return '이 선택지를 하려면 $needed점의 지식이 더 필요합니다.';
      }
    }
    
    if (condition.requiredFact != null) {
      return '이 선택지를 하려면 특정 역사 사실을 먼저 발견해야 합니다.';
    }
    
    if (condition.requiredCharacter != null) {
      return '이 선택지를 하려면 특정 인물을 먼저 만나야 합니다.';
    }
    
    return '조건을 만족하지 못했습니다.';
  }

  Future<void> _showCompletionDialog(List<UnlockEvent> unlocks) async {
    // 관련 퀴즈 확인 - repository에서 직접 로드
    final quizRepository = ref.read(quizRepositoryProvider);
    final relatedQuizzes = await quizRepository.getQuizzesByDialogueId(widget.dialogueId);
    final hasRelatedQuiz = relatedQuizzes.isNotEmpty;
    
    if (!mounted) return;
    
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.dialogueSurface,
        title: Text(
          'Dialogue Completed',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 60, color: AppColors.success),
            const SizedBox(height: 16),
            Text(
              'You have gained new knowledge!',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            if (unlocks.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: AppColors.divider),
              const SizedBox(height: 16),
              Text(
                'UNLOCKED!',
                style: TextStyle(
                  color: AppColors.dialogueReward,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              ...unlocks.map(
                (e) => Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          e.type == UnlockType.era
                              ? Icons.public
                              : Icons.emoji_events,
                          color: AppColors.dialogueReward,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.name,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (e.message != null)
                                Text(
                                  e.message!,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            // 관련 퀴즈가 있으면 안내 메시지 표시
            if (hasRelatedQuiz) ...[
              const SizedBox(height: 16),
              Divider(color: AppColors.divider),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '관련 퀴즈가 있습니다!',
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '배운 내용을 테스트해보세요',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          // 계속하기 버튼
          TextButton(
            onPressed: () {
              // Close the dialog first
              Navigator.of(dialogContext).pop();

              // Then navigate back properly
              _handleDialogueExit(context);
            },
            child: Text(
              hasRelatedQuiz ? '나중에' : 'Continue',
              style: TextStyle(
                color: hasRelatedQuiz ? AppColors.textDisabled : AppColors.info,
              ),
            ),
          ),
          // 퀴즈 도전 버튼 (관련 퀴즈가 있을 때만)
          if (hasRelatedQuiz)
            ElevatedButton.icon(
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                
                // Navigate to quiz - 대화 화면을 퀴즈 화면으로 교체
                // (go 사용으로 뒤로가기 시 대화 화면으로 돌아가지 않음)
                final firstQuiz = relatedQuizzes.first;
                context.go('/quiz/${firstQuiz.id}');
              },
              icon: const Icon(Icons.quiz, size: 18),
              label: const Text('퀴즈 도전!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _resolveSpeakerName({
    required AppLocalizations l10n,
    required String? speakerId,
    required Character? character,
  }) {
    if (character != null) {
      return character.nameKorean;
    }
    if (speakerId == null || speakerId.isEmpty) {
      return l10n.common_unknown_character;
    }
    switch (speakerId) {
      case 'sejong':
        return '세종대왕';
      case 'gwanggaeto':
        return '광개토대왕';
      default:
        return l10n.common_unknown_character;
    }
  }

  void _handleDialogueExit(BuildContext context) {
    _log('exit requested');
    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }
    if (widget.eraId.isNotEmpty) {
      AppRouter.goToEraExploration(context, widget.eraId);
      return;
    }
    context.go(AppRouter.worldMap);
  }
}
