import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/app_colors.dart';
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
  final String? backgroundAsset;

  const DialogueScreen({
    super.key,
    required this.dialogueId,
    required this.eraId,
    this.backgroundAsset,
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

      // 대화에 등장하는 캐릭터 미리 로드
      _prefetchDialogueCharacters();

      // BGM 시작
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmDialogue) {
        ref.read(bgmControllerProvider.notifier).playDialogueBgm();
      }
    });
  }

  /// 대화에 등장하는 모든 화자 캐릭터를 미리 로드
  Future<void> _prefetchDialogueCharacters() async {
    try {
      final dialogue = await ref.read(dialogueByIdProvider(widget.dialogueId).future);
      if (dialogue == null) return;

      final speakerIds = dialogue.nodes
          .map((n) => n.speakerId)
          .where((id) => id.isNotEmpty)
          .toSet();

      // 모든 캐릭터를 병렬로 프리페치
      _log('prefetching ${speakerIds.length} characters: $speakerIds');
      await Future.wait(
        speakerIds.map((id) => ref.read(characterByIdProvider(id).future)),
      );
      _log('prefetch completed for ${speakerIds.length} characters');

      // 프리페치 완료 후 UI 강제 rebuild (mounted 체크)
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _log('prefetch error: $e');
    }
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
    
    // 화자 캐릭터 정보를 ID로 직접 조회
    final speakerId = state.currentNode?.speakerId;
    _log('speakerId from currentNode: "$speakerId"');
    final speakerAsync = (speakerId != null && speakerId.isNotEmpty)
        ? ref.watch(characterByIdProvider(speakerId))
        : null;

    final speakerName = _resolveSpeakerName(
      l10n: l10n,
      speakerId: speakerId,
      character: speakerAsync?.valueOrNull,
    );
    

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 단색 배경 - 인물 이미지 자체에 배경이 포함되어 있으므로 간결하게 처리
          Positioned.fill(
            child: Container(color: AppColors.dialogueBackground),
          ),
          
          // 1.5. 보상 알림 오버레이
          RewardOverlay(reward: state.lastReward),

          // 2. 캐릭터 초상화
          Positioned.fill(
            bottom: 200,
            child: _buildCharacterPortrait(
              speakerAsync: speakerAsync,
              speakerName: speakerName,
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
              icon: const Icon(Icons.close, color: AppColors.white70),
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

  /// 캐릭터 포트레이트 위젯 빌드
  Widget _buildCharacterPortrait({
    required AsyncValue<Character?>? speakerAsync,
    required String speakerName,
    required String emotion,
  }) {
    _log('buildPortrait speakerName=$speakerName speakerAsync=$speakerAsync');

    if (speakerAsync == null) {
      _log('buildPortrait -> PlaceholderPortrait (speakerAsync is null)');
      return PlaceholderPortrait(label: speakerName);
    }

    return speakerAsync.when(
      loading: () {
        _log('buildPortrait -> LoadingPortrait');
        return LoadingPortrait(label: speakerName);
      },
      error: (e, _) {
        _log('buildPortrait -> PlaceholderPortrait (error: $e)');
        return PlaceholderPortrait(label: speakerName);
      },
      data: (character) {
        _log('buildPortrait -> data: ${character?.id ?? 'null'} portrait=${character?.portraitAsset ?? 'null'}');
        return character == null
            ? PlaceholderPortrait(label: speakerName)
            : CharacterPortrait(character: character, emotion: emotion);
      },
    );
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
          AppRouter.goToQuizPlay(context, quiz.id);
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
