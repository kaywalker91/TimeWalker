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
  final String? backgroundAsset;

  const DialogueSelectionSheet({
    super.key,
    required this.character,
    required this.dialogues,
    this.backgroundAsset,
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
          top: BorderSide(color: AppColors.white.withValues(alpha: 0.1)),
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
          backgroundColor: AppColors.transparent,
          backgroundImage: AssetImage(character.portraitAsset),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.nameKorean,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '대화를 선택하세요',
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: AppColors.white70),
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
          style: TextStyle(color: AppColors.white54),
        ),
      ),
    );
  }

  Widget _buildDialogueItem(
    BuildContext context,
    Dialogue dialogue,
    UserProgress? userProgress,
  ) {
    final isCompleted = userProgress?.isDialogueCompleted(dialogue.id) ?? false;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          context.pop(); // Close sheet
          AppRouter.goToDialogue(
            context,
            character.eraId,
            dialogue.id,
            backgroundAsset: backgroundAsset,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialogue.titleKorean,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dialogue.description,
                      style: const TextStyle(
                        color: AppColors.white60,
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
                const Icon(Icons.check_circle, color: AppColors.green, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
