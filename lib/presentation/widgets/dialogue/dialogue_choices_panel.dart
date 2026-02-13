import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

/// 대화 선택지 조건 검증 헬퍼
class ChoiceConditionHelper {
  /// 선택지 선택 가능 여부 확인
  static bool canSelectChoice(DialogueChoice choice, UserProgress? progress) {
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
      if (!progress.unlockedCharacterIds.contains(
        condition.requiredCharacter,
      )) {
        return false;
      }
    }

    return true;
  }

  /// 조건 미충족 메시지 생성
  static String getConditionMessage(
    ChoiceCondition condition,
    UserProgress? progress,
  ) {
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
}

/// 대화 선택지 패널
///
/// 대화 중 선택지를 표시하는 위젯
class DialogueChoicesPanel extends StatelessWidget {
  final List<DialogueChoice> choices;
  final UserProgress? userProgress;
  final void Function(DialogueChoice choice) onChoiceSelected;

  const DialogueChoicesPanel({
    super.key,
    required this.choices,
    required this.userProgress,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Container(
      // color: AppColors.black54, // Removed background for embedded use
      padding:
          EdgeInsets.zero, // Removed horizontal padding (handled by parent box)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: choices.map((choice) {
          final canSelect = ChoiceConditionHelper.canSelectChoice(
            choice,
            userProgress,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Tooltip(
              message: !canSelect && choice.condition != null
                  ? ChoiceConditionHelper.getConditionMessage(
                      choice.condition!,
                      userProgress,
                    )
                  : choice.getPreview(locale) ?? '',
              child: _ChoiceButton(
                choice: choice,
                text: choice.getText(locale),
                canSelect: canSelect,
                onPressed: canSelect ? () => onChoiceSelected(choice) : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 개별 선택지 버튼
class _ChoiceButton extends StatelessWidget {
  final DialogueChoice choice;
  final String text;
  final bool canSelect;
  final VoidCallback? onPressed;

  const _ChoiceButton({
    required this.choice,
    required this.text,
    required this.canSelect,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: canSelect
            ? AppColors.dialogueChoiceActive
            : AppColors.dialogueChoiceInactive,
        foregroundColor: canSelect
            ? AppColors.textPrimary
            : AppColors.textDisabled,
        side: BorderSide(
          color: canSelect ? AppColors.dialogueChoiceBorder : AppColors.border,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: canSelect ? 8 : 2,
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: canSelect ? AppColors.white : AppColors.white38,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
