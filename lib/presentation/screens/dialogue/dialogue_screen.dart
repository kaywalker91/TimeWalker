import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

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
    // Initialize Logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dialogueViewModelProvider(widget.dialogueId).notifier)
          .initialize(widget.dialogueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for completion state change
    ref.listen(dialogueViewModelProvider(widget.dialogueId), (previous, next) {
      if (previous?.isCompleted == false && next.isCompleted) {
        _showCompletionDialog(context, next.unlockEvents);
      }
    });

    final state = ref.watch(dialogueViewModelProvider(widget.dialogueId));

    if (state.dialogue == null || state.currentNode == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Fetch Speaker Character Data
    final speakerAsync = ref.watch(characterListByEraProvider(widget.eraId));

    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        children: [
          // 1. Background (Dimmed)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1E1E2C),
              // TODO: Add Era Background Image with Blur
            ),
          ),

          // 2. Character Portrait (Center)
          Positioned.fill(
            bottom: 200, // Leave space for dialogue box
            child: speakerAsync.when(
              data: (characters) {
                final speakerId = state.currentNode?.speakerId;
                if (speakerId == null) return const SizedBox.shrink();

                Character? character;
                try {
                   character = characters.firstWhere((c) => c.id == speakerId);
                } catch (_) {
                   // Fallback to first available character or ignore if list is empty
                   if (characters.isNotEmpty) {
                     character = characters.first;
                   }
                }
                
                if (character == null) return const SizedBox.shrink();

                return _CharacterPortrait(
                  character: character,
                  emotion: state.currentNode!.emotion,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // 3. Dialogue Box (Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: speakerAsync.when(
              data: (characters) {
                 // ... existing speaker resolution ... (omitted for brevity in match, but included in logic)
                 // Actually we need to match the exact content to replace the child.
                 // Let's rely on the previous content structure.
                 final speakerId = state.currentNode?.speakerId;
                 String speakerName = 'Unknown';
                 if (speakerId != null) {
                    try {
                      final character = characters.firstWhere((c) => c.id == speakerId);
                      speakerName = character.nameKorean;
                    } catch (_) {
                      if (speakerId == 'sejong') speakerName = '세종대왕';
                      if (speakerId == 'gwanggaeto') speakerName = '광개토대왕';
                    }
                 }
                 
                 return _DialogueBox(
                  state: state,
                  speakerName: speakerName,
                  onNext: () => ref
                      .read(dialogueViewModelProvider(widget.dialogueId).notifier)
                      .next(),
                  // onChoice removed from here
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
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
                    ...state.currentNode!.choices.map((choice) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C2C3E),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFFFFD700), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              // Use minimumSize instead of fixed height
                              minimumSize: const Size(double.infinity, 56),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                            ),
                            onPressed: () => ref
                                .read(dialogueViewModelProvider(widget.dialogueId)
                                    .notifier)
                                .selectChoice(choice),
                            child: Text(
                              choice.text,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.3, // Improve readability for multi-line
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
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
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
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
