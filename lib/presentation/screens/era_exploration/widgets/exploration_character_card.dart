import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';
import 'package:time_walker/presentation/widgets/dialogue/dialogue_selection_sheet.dart';

/// 캐릭터 카드 위젯
/// 
/// 탐험 화면 및 위치 상세에서 캐릭터를 표시하는 카드입니다.
/// 잠금 상태에 따라 다른 UI를 표시하며, 대화 기능을 제공합니다.
class ExplorationCharacterCard extends ConsumerWidget {
  /// 표시할 캐릭터
  final Character character;
  
  /// 시대 테마 (색상 지정용)
  final EraTheme theme;
  
  /// 상단 마진 (기본: 0)
  final double topMargin;
  
  /// 하단 마진 (기본: 16)
  final double bottomMargin;

  const ExplorationCharacterCard({
    super.key,
    required this.character,
    required this.theme,
    this.topMargin = 0,
    this.bottomMargin = 16,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = !character.isAccessible;

    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked
              ? Colors.transparent
              : theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isLocked ? Colors.grey[700] : theme.primaryColor,
          backgroundImage: 
              isLocked ? null : AssetImage(character.portraitAsset),
          child: isLocked
              ? const Icon(Icons.lock, color: Colors.white30)
              : null,
        ),
        title: Text(
          isLocked ? AppLocalizations.of(context)!.common_unknown_character : character.nameKorean,
          style: TextStyle(
            color: isLocked ? Colors.grey : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          isLocked ? AppLocalizations.of(context)!.common_locked_status : character.title,
          style: TextStyle(
            color: isLocked ? Colors.grey[700] : theme.accentColor,
            fontSize: 12,
          ),
        ),
        trailing: isLocked
            ? null
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () => _openDialogue(context, ref),
                child: Text(AppLocalizations.of(context)!.common_talk),
              ),
      ),
    );
  }

  Future<void> _openDialogue(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final dialogues =
          await ref.read(dialogueListByCharacterProvider(character.id).future);
      if (!context.mounted) return;
      
      if (dialogues.isEmpty) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.exploration_no_dialogue),
          ),
        );
        return;
      }
      
      // dialogues가 1개 이상이면 항상 선택 시트를 보여줌 (다시보기 등 포함)
      // 또는 2개 이상일 때만 보여주고 1개일 때는 바로 진입?
      // 기획 의도에 따라 다르나, "Crossover" 같은 숨겨진 대화 발견의 기쁨을 위해
      // 1개라도 시트를 보여줘서 확장성을 암시하는 것이 좋을 수도 있음.
      // 하지만 편의성을 위해 1개일 때는 바로 진입하고, 2개 이상일 때만 시트를 띄우는 것이 일반적 UX.
      // 다만, 구현 계획에서는 "Always show sheet"로 결정했음 (future content visibility).
      
      // Update logic: Always show sheet to handle locking logic & crossover visibility consistently
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => DialogueSelectionSheet(
          character: character,
          dialogues: dialogues,
        ),
      );
      
    } catch (_) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.exploration_no_dialogue),
        ),
      );
    }
  }
}

