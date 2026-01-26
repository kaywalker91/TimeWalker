import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class DialogueSelectionSheet extends ConsumerWidget {
  final Character character;
  final List<Dialogue> dialogues;

  const DialogueSelectionSheet({
    super.key,
    required this.character,
    required this.dialogues,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider).value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          if (dialogues.isEmpty)
            _buildEmptyState(context)
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: dialogues.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final dialogue = dialogues[index];
                  return _buildDialogueItem(
                    context, 
                    dialogue, 
                    userProgress,
                  );
                },
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(character.portraitAsset),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.nameKorean,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '대화를 선택하세요',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          '가능한 대화가 없습니다.',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildDialogueItem(
    BuildContext context, 
    Dialogue dialogue, 
    UserProgress? userProgress,
  ) {
    final isCrossover = dialogue.id.startsWith('crossover_');
    final isLocked = _isLocked(dialogue, userProgress);
    final isCompleted = userProgress?.isDialogueCompleted(dialogue.id) ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked 
            ? () => _showLockedMessage(context, dialogue)
            : () {
                context.pop(); // Close sheet
                AppRouter.goToDialogue(context, character.eraId, dialogue.id);
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCrossover 
                ? const Color(0xFF2A1A40) // Purple tint for crossover
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCrossover 
                  ? Colors.amber.withValues(alpha: 0.5) 
                  : Colors.white.withValues(alpha: 0.1),
              width: isCrossover ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCrossover 
                      ? Colors.amber.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                ),
                child: Icon(
                  isLocked 
                      ? Icons.lock 
                      : (isCrossover ? Icons.auto_awesome : Icons.chat_bubble_outline),
                  color: isLocked 
                      ? Colors.grey 
                      : (isCrossover ? Colors.amber : Colors.white),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isCrossover) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'CROSSOVER',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            dialogue.titleKorean,
                            style: TextStyle(
                              color: isLocked ? Colors.grey : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dialogue.description,
                      style: TextStyle(
                        color: isLocked ? Colors.grey[600] : Colors.white60,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Status
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLocked(Dialogue dialogue, UserProgress? userProgress) {
    if (userProgress == null) return true;
    
    // Crossover locking logic
    if (dialogue.id.startsWith('crossover_')) {
      // Parse ID to find partner character
      // e.g., crossover_sejong_davinci -> partner: davinci
      // This is a naive heuristic; ideally, this should be in data.
      // But for now, let's extract potential partner IDs from the dialogue ID
      // or assume the dialogue data structure will be updated later.
      // For this implementation, I'll rely on a known patterns or 
      // check if the dialogue has specific requirements in the future.
      
      // Heuristic: Check all involved characters in the nodes? 
      // Too expensive to parse nodes here.
      // Let's use the ID string for now.
      
      final parts = dialogue.id.split('_');
      if (parts.length >= 3) {
        final char1 = parts[1]; // sejong
        final char2 = parts[2]; // davinci
        
        // Check if both are unlocked
        final isChar1Unlocked = userProgress.unlockedCharacterIds.contains(char1);
        final isChar2Unlocked = userProgress.unlockedCharacterIds.contains(char2);
        
        return !(isChar1Unlocked && isChar2Unlocked);
      }
    }
    
    return false;
  }

  void _showLockedMessage(BuildContext context, Dialogue dialogue) {
    // Show a simple snackbar or dialog explaining why it's locked
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('이 대화를 시작하려면 관련된 모든 인물을 먼저 만나야 합니다.'),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
