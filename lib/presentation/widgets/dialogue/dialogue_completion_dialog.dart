import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/domain/services/progression_service.dart';

/// 대화 완료 다이얼로그
/// 
/// 대화가 완료되었을 때 해금된 콘텐츠와 관련 퀴즈를 표시하는 다이얼로그
class DialogueCompletionDialog extends StatelessWidget {
  final List<UnlockEvent> unlocks;
  final List<Quiz> relatedQuizzes;
  final VoidCallback onContinue;
  final void Function(Quiz quiz) onQuizStart;

  const DialogueCompletionDialog({
    super.key,
    required this.unlocks,
    required this.relatedQuizzes,
    required this.onContinue,
    required this.onQuizStart,
  });

  bool get hasRelatedQuiz => relatedQuizzes.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            _buildUnlocksSection(),
          ],
          if (hasRelatedQuiz) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.divider),
            const SizedBox(height: 12),
            _buildQuizPrompt(),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onContinue,
          child: Text(
            hasRelatedQuiz ? '나중에' : 'Continue',
            style: TextStyle(
              color: hasRelatedQuiz ? AppColors.textDisabled : AppColors.info,
            ),
          ),
        ),
        if (hasRelatedQuiz)
          ElevatedButton.icon(
            onPressed: () => onQuizStart(relatedQuizzes.first),
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
    );
  }

  Widget _buildUnlocksSection() {
    return Column(
      children: [
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
        ...unlocks.map((e) => _UnlockEventTile(event: e)),
      ],
    );
  }

  Widget _buildQuizPrompt() {
    return Container(
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
    );
  }
}

/// 해금 이벤트 타일
class _UnlockEventTile extends StatelessWidget {
  final UnlockEvent event;

  const _UnlockEventTile({required this.event});

  /// 해금 타입에 따른 아이콘 반환
  IconData _getIconForType(UnlockType type) {
    switch (type) {
      case UnlockType.era:
        return Icons.public;
      case UnlockType.country:
        return Icons.flag;
      case UnlockType.region:
        return Icons.map;
      case UnlockType.rank:
        return Icons.military_tech;
      case UnlockType.feature:
        return Icons.new_releases;
      case UnlockType.encyclopedia:
        return Icons.menu_book;
      case UnlockType.character:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            _getIconForType(event.type),
            color: AppColors.dialogueReward,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (event.message != null)
                  Text(
                    event.message!,
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
    );
  }
}
