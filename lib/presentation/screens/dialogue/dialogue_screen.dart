import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/dialogue/reward_notification.dart';

import 'package:time_walker/core/routes/app_router.dart';

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
      
      // BGM 시작 (대화 BGM)
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmDialogue) {
        ref.read(bgmControllerProvider.notifier).playDialogueBgm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final closeAction = () => _handleDialogueExit(context);
    // Listen for completion state change
    ref.listen(dialogueViewModelProvider(widget.dialogueId), (previous, next) {
      if (previous?.isCompleted == false && next.isCompleted) {
        _showCompletionDialog(context, next.unlockEvents);
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
      return _DialogueLoadFailure(
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
        error: (_, __) => _DialogueLoadFailure(
          message: l10n.exploration_no_dialogue,
          onClose: closeAction,
        ),
        data: (dialogue) {
          if (dialogue == null) {
            return _DialogueLoadFailure(
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
              color: const Color(0xFF1E1E2C),
              // TODO: Add Era Background Image with Blur
            ),
          ),
          
          // 1.5. Reward Notification Overlay
          RewardOverlay(reward: state.lastReward),

          // 2. Character Portrait (Center)
          Positioned.fill(
            bottom: 200, // Leave space for dialogue box
            child: speaker == null
                ? _PlaceholderPortrait(label: speakerName)
                : _CharacterPortrait(
                    character: speaker,
                    emotion: state.currentNode!.emotion,
                  ),
          ),

          // 3. Dialogue Box (Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _DialogueBox(
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
                                  ? const Color(0xFF2C2C3E)
                                  : const Color(0xFF1A1A2E),
                              foregroundColor: canSelect
                                  ? Colors.white
                                  : Colors.white38,
                              side: BorderSide(
                                color: canSelect
                                    ? const Color(0xFFFFD700)
                                    : Colors.grey,
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

  void _showCompletionDialog(BuildContext context, List<UnlockEvent> unlocks) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C3E),
        title: const Text(
          'Dialogue Completed',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'You have gained new knowledge!',
              style: TextStyle(color: Colors.white70),
            ),
            if (unlocks.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              const Text(
                'UNLOCKED!',
                style: TextStyle(
                  color: Colors.amber,
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
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (e.message != null)
                                Text(
                                  e.message!,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog first
              Navigator.of(dialogContext).pop();

              // Then navigate back to exploration
              // Using explicit go is safer than pop here to ensure we land on the right screen
              AppRouter.goToEraExploration(context, widget.eraId);
            },
            child: const Text('Continue'),
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

class _DialogueLoadFailure extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const _DialogueLoadFailure({
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(responsive.padding(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white70,
                  size: responsive.iconSize(64),
                ),
                SizedBox(height: responsive.spacing(16)),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: responsive.fontSize(16),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.spacing(24)),
                ElevatedButton(
                  onPressed: onClose,
                  child: Text(AppLocalizations.of(context)!.common_close),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPortrait extends StatelessWidget {
  final String label;

  const _PlaceholderPortrait({required this.label});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.person_outline,
            color: Colors.white24,
            size: responsive.iconSize(160),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white38,
              fontSize: responsive.fontSize(14),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterPortrait extends StatelessWidget {
  final Character character;
  final String emotion;

  const _CharacterPortrait({required this.character, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    // Determine asset based on emotion
    String assetPath = character.portraitAsset;
    
    // Try to find matching emotion asset
    if (character.emotionAssets.isNotEmpty) {
      try {
        final match = character.emotionAssets.firstWhere(
            (path) => path.contains('_${emotion}.') || path.contains(emotion));
        assetPath = match;
      } catch (_) {
        // No match found, use default portrait
      }
    }

    // Responsive portrait height
    final portraitHeight = responsive.isSmallPhone 
        ? 400.0 
        : responsive.deviceType == DeviceType.tablet 
            ? 700.0 
            : 600.0;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: portraitHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                   return Icon(Icons.person, size: responsive.iconSize(200), color: Colors.grey[400]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogueBox extends StatefulWidget {
  final DialogueState state;
  final String speakerName;
  final VoidCallback onNext;

  const _DialogueBox({
    required this.state,
    required this.speakerName,
    required this.onNext,
  });

  @override
  State<_DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<_DialogueBox> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant _DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.displayedText != oldWidget.state.displayedText) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentNode = widget.state.currentNode!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final responsive = context.responsive;
    
    // Responsive sizing
    final boxHeight = responsive.isSmallPhone ? 200.0 : 250.0;
    final speakerFontSize = responsive.fontSize(18);
    final textFontSize = responsive.fontSize(16);
    final horizontalPadding = responsive.padding(24);

    return GestureDetector(
      onTap: widget.onNext,
      child: Container(
        height: boxHeight + bottomPadding,
        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 16 + bottomPadding),
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker Name
            Text(
              widget.speakerName,
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: speakerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(16)),

            // Text Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Text(
                  widget.state.displayedText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize,
                    height: 1.6,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ),

            // Choices or Next Indicator
            if (!widget.state.isTyping && !currentNode.hasChoices)
              Align(alignment: Alignment.bottomRight, child: _BlinkingCursor()),
          ],
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  _BlinkingCursorState createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
    );
  }
}
