import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// 시대 탐험 플로팅 패널 위젯
///
/// Sprint 5: 미니멀한 인장 스타일 플로팅 버튼
/// 장소/캐릭터 목록 바텀시트를 표시하는 컴팩트한 FAB
class EraHudPanel extends ConsumerWidget {
  final Era era;
  final List<Location> locations;
  final Location? selectedLocation;
  final VoidCallback onShowLocations;
  final VoidCallback onShowCharacters;

  const EraHudPanel({
    super.key,
    required this.era,
    required this.locations,
    this.selectedLocation,
    required this.onShowLocations,
    required this.onShowCharacters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;

    // 플로팅 인장 스타일 패널
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(6),
        vertical: responsive.padding(6),
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
          // 왕국별 글로우
          BoxShadow(
            color: era.theme.accentColor.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // 진행 현황 버튼 (통계/데이터 관점)
          Expanded(
            child: _SealStyleButton(
              icon: Icons.analytics_outlined,
              label: AppLocalizations.of(context)!.exploration_tab_progress,
              accentColor: era.theme.accentColor,
              onTap: onShowLocations,
              responsive: responsive,
            ),
          ),
          Container(
            height: responsive.spacing(28),
            width: 1,
            color: AppColors.white.withValues(alpha: 0.15),
            margin: EdgeInsets.symmetric(horizontal: responsive.spacing(4)),
          ),
          // 캐릭터 버튼 (인장 스타일)
          Expanded(
            child: _SealStyleButton(
              icon: Icons.person,
              label: AppLocalizations.of(context)!.exploration_list_characters,
              accentColor: era.theme.accentColor,
              onTap: onShowCharacters,
              responsive: responsive,
            ),
          ),
        ],
      ),
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

  const _SealStyleButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.padding(12),
            vertical: responsive.padding(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 인장 스타일 아이콘 컨테이너
              Container(
                padding: EdgeInsets.all(responsive.padding(6)),
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
                  size: responsive.iconSize(14),
                  color: accentColor,
                ),
              ),
              SizedBox(width: responsive.spacing(8)),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontSize: responsive.fontSize(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
