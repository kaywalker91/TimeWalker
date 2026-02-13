import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// 시대 탐험 플로팅 패널 위젯
///
/// Sprint 5: 미니멀한 인장 스타일 플로팅 버튼
/// 장소/캐릭터 목록 바텀시트를 표시하는 컴팩트한 FAB
class EraHudPanel extends ConsumerWidget {
  final Era era;
  final List<Location> locations;
  final Location? selectedLocation;
  final EraExplorationLayoutSpec layoutSpec;
  final VoidCallback onShowLocations;
  final VoidCallback onShowCharacters;

  const EraHudPanel({
    super.key,
    required this.era,
    required this.locations,
    this.selectedLocation,
    required this.layoutSpec,
    required this.onShowLocations,
    required this.onShowCharacters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final glowAlpha = disableAnimations ? 0.08 : 0.2;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useWrap = layoutSpec.prefersHudWrap;
        final useSingleColumn = layoutSpec.prefersHudSingleColumn;
        final spacing = responsive.spacing(6);
        final double wrapButtonWidth;
        if (useSingleColumn) {
          wrapButtonWidth = constraints.maxWidth;
        } else {
          wrapButtonWidth = (constraints.maxWidth - spacing) / 2;
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.padding(6),
            vertical: responsive.padding(layoutSpec.hudVerticalPadding),
          ),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: era.theme.accentColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: era.theme.accentColor.withValues(alpha: glowAlpha),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: useWrap
              ? Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    SizedBox(
                      width: wrapButtonWidth,
                      child: _SealStyleButton(
                        icon: Icons.analytics_outlined,
                        label: l10n.exploration_tab_progress,
                        accentColor: era.theme.accentColor,
                        onTap: onShowLocations,
                        responsive: responsive,
                        layoutSpec: layoutSpec,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                    SizedBox(
                      width: wrapButtonWidth,
                      child: _SealStyleButton(
                        icon: Icons.person,
                        label: l10n.exploration_list_characters,
                        accentColor: era.theme.accentColor,
                        onTap: onShowCharacters,
                        responsive: responsive,
                        layoutSpec: layoutSpec,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: _SealStyleButton(
                        icon: Icons.analytics_outlined,
                        label: l10n.exploration_tab_progress,
                        accentColor: era.theme.accentColor,
                        onTap: onShowLocations,
                        responsive: responsive,
                        layoutSpec: layoutSpec,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                    Container(
                      height: responsive.spacing(28),
                      width: 1,
                      color: AppColors.white.withValues(alpha: 0.15),
                      margin: EdgeInsets.symmetric(
                        horizontal: responsive.spacing(4),
                      ),
                    ),
                    Expanded(
                      child: _SealStyleButton(
                        icon: Icons.person,
                        label: l10n.exploration_list_characters,
                        accentColor: era.theme.accentColor,
                        onTap: onShowCharacters,
                        responsive: responsive,
                        layoutSpec: layoutSpec,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// 인장 스타일 버튼 (도장 느낌)
class _SealStyleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;
  final ResponsiveUtils responsive;
  final EraExplorationLayoutSpec layoutSpec;
  final bool disableAnimations;

  const _SealStyleButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
    required this.responsive,
    required this.layoutSpec,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final compactLabel =
        layoutSpec.textScaleClass == EraExplorationTextScaleClass.xlarge ||
        layoutSpec.textScaleClass == EraExplorationTextScaleClass.max;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        splashFactory: disableAnimations ? NoSplash.splashFactory : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints(minHeight: layoutSpec.hudMinHeight),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.padding(compactLabel ? 10 : 12),
            vertical: responsive.padding(compactLabel ? 8 : 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 인장 스타일 아이콘 컨테이너
              Container(
                padding: EdgeInsets.all(
                  responsive.padding(compactLabel ? 5 : 6),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: responsive.iconSize(compactLabel ? 13 : 14),
                  color: accentColor,
                ),
              ),
              SizedBox(width: responsive.spacing(compactLabel ? 6 : 8)),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: responsive.fontSize(compactLabel ? 11 : 12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
