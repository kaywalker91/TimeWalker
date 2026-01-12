import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// 시대 탐험 HUD 패널 위젯
///
/// 시대 테마 그라데이션, 엠블럼, 커스텀 프로그레스 바를 포함한 하단 플로팅 패널
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

    return Container(
      padding: EdgeInsets.all(responsive.padding(12)),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: era.theme.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 선택된 장소 프리뷰 (선택 시에만 노출)
          if (selectedLocation != null) ...[
            _buildLocationPreview(context, selectedLocation!, responsive),
            SizedBox(height: responsive.spacing(12)),
          ],

          // 액션 버튼
          _buildActionButtons(context, responsive),
        ],
      ),
    );
  }

  Widget _buildLocationPreview(
    BuildContext context,
    Location location,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(12),
        vertical: responsive.padding(10),
      ),
      decoration: BoxDecoration(
        color: era.theme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: era.theme.accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(8)),
            decoration: BoxDecoration(
              color: era.theme.accentColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.place,
              color: era.theme.accentColor,
              size: responsive.iconSize(18),
            ),
          ),
          SizedBox(width: responsive.spacing(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.exploration_selected_label,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: responsive.fontSize(10),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  location.nameKorean,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.fontSize(13),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: era.theme.accentColor.withValues(alpha: 0.7),
            size: responsive.iconSize(20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ResponsiveUtils responsive) {
    return Row(
      children: [
        Expanded(
          child: _HudActionButton(
            icon: Icons.location_on,
            label: AppLocalizations.of(context)!.exploration_list_locations,
            accentColor: era.theme.accentColor,
            onTap: onShowLocations,
            responsive: responsive,
          ),
        ),
        SizedBox(width: responsive.spacing(10)),
        Expanded(
          child: _HudActionButton(
            icon: Icons.person,
            label: AppLocalizations.of(context)!.exploration_list_characters,
            accentColor: era.theme.accentColor,
            onTap: onShowCharacters,
            responsive: responsive,
          ),
        ),
      ],
    );
  }
}

/// HUD 액션 버튼
class _HudActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;
  final ResponsiveUtils responsive;

  const _HudActionButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: responsive.padding(12),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: responsive.iconSize(18),
                color: accentColor.withValues(alpha: 0.9),
              ),
              SizedBox(width: responsive.spacing(8)),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
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
