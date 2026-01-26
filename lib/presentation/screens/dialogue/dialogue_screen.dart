import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';
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
    _log('initState dialogueId=${widget.dialogueId} eraId=${widget.eraId}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dialogueViewModelProvider(widget.dialogueId).notifier)
          .initialize(widget.dialogueId);
      
      // 관련 퀴즈 미리 로드
      ref.read(quizListByDialogueProvider(widget.dialogueId));
      
      // BGM 시작
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
    
    // 대화 완료 상태 변화 감지
    ref.listen(dialogueViewModelProvider(widget.dialogueId), (previous, next) {
      if (previous?.isCompleted == false && next.isCompleted) {
        _showCompletionDialog(next.unlockEvents);
      }
      if (previous?.dialogue == null && next.dialogue != null) {
        _log('dialogue loaded id=${next.dialogue!.id} nodes=${next.dialogue!.nodes.length}');
      }
      if (previous?.currentNode?.id != next.currentNode?.id) {
        _log('node changed ${previous?.currentNode?.id ?? 'null'} -> ${next.currentNode?.id ?? 'null'}');
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
      _log('missing params dialogueId="${widget.dialogueId}" eraId="${widget.eraId}"');
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
    
    // 화자 캐릭터 정보
    // Crossover Support: 화자가 현재 시대의 인물이 아닐 수 있으므로 EraProvider가 아닌
    // CharacterRepository를 통해 직접 ID로 조회하거나, 모든 캐릭터 풀에서 찾아야 함.
    // 하지만 성능상 현재 대화의 speakerId로 개별 조회하는 것이 나음.
    // 여기서는 간단하게 build method 내에서 async로 가져오기 어려우므로,
    // FutureProvider를 사용하거나, ViewModel에서 speaker 정보를 관리하도록 변경하는 것이 이상적임.
    // 차선책: ref.watch(characterByIdProvider(speakerId)) 같은 것이 있으면 좋음.
    // 현재 구조에서는 ViewModel이 DialogueNode를 가지고 있으므로, 
    // ViewModel이 speaker 캐릭터 객체도 로드해서 state에 포함시키는 것이 가장 깔끔함.
    
    // 하지만 ViewModel 수정 없이 처리하려면:
    // characterRepositoryProvider.getCharacterById를 FutureBuilder로 처리?
    // 아니면 ref.watch(characterProvider(speakerId)) 패턴?
    
    // 기존 코드:
    // final speakerAsync = ref.watch(characterListByEraProvider(widget.eraId));
    // final characters = speakerAsync.valueOrNull ?? const <Character>[];
    // ... filtering ...
    
    // 개선 코드:
    // CharacterListByEra는 현재 시대 캐릭터만 가져오므로 Crossover 시 타 시대 캐릭터(예: 다빈치)를 못 찾음.
    // 해결책: speakerId가 있으면 해당 ID로 캐릭터를 가져오는 Provider를 watch.
    
    final speakerId = state.currentNode?.speakerId;
    
    // Crossover Support: 화자 캐릭터 정보를 ID로 직접 조회
    // 현재 시대에 구애받지 않고 모든 캐릭터를 로드할 수 있음
    Character? speaker;
    if (speakerId != null) {
      final speakerAsync = ref.watch(characterByIdProvider(speakerId));
      speaker = speakerAsync.valueOrNull;
    }

    final speakerName = _resolveSpeakerName(
      l10n: l10n,
      speakerId: speakerId,
      character: speaker,
    );
    

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 배경
          Positioned.fill(
            child: Container(color: AppColors.dialogueBackground),
          ),
          
          // 1.5. 보상 알림 오버레이
          RewardOverlay(reward: state.lastReward),

          // 2. 캐릭터 초상화
          Positioned.fill(
            bottom: 200,
            child: speaker == null
                ? PlaceholderPortrait(label: speakerName)
                : CharacterPortrait(
                    character: speaker,
                    emotion: state.currentNode!.emotion,
                  ),
          ),

          // 3. 대화 상자
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

          // 4. 선택지 오버레이
          if (!state.isTyping && (state.currentNode?.hasChoices ?? false))
            Positioned.fill(
              bottom: 250,
              child: DialogueChoicesPanel(
                choices: state.currentNode!.choices,
                userProgress: ref.watch(userProgressProvider).value,
                onChoiceSelected: (choice) async {
                  await ref
                      .read(dialogueViewModelProvider(widget.dialogueId).notifier)
                      .selectChoice(choice);
                },
              ),
            ),

          // 5. 닫기 버튼
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

  Future<void> _showCompletionDialog(List<UnlockEvent> unlocks) async {
    final quizRepository = ref.read(quizRepositoryProvider);
    final relatedQuizzes = await quizRepository.getQuizzesByDialogueId(widget.dialogueId);
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => DialogueCompletionDialog(
        unlocks: unlocks,
        relatedQuizzes: relatedQuizzes,
        onContinue: () {
          Navigator.of(dialogContext).pop();
          _handleDialogueExit(context);
        },
        onQuizStart: (quiz) {
          Navigator.of(dialogContext).pop();
          context.go('/quiz/${quiz.id}');
        },
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
