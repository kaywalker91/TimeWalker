import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/enhanced_timeline_gutter.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/exploration_models.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/location_story_card.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

/// Timeline node tile with gutter and location card
class StoryNodeTile extends StatelessWidget {
  final Era era;
  final Location location;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;

  const StoryNodeTile({
    super.key,
    required this.era,
    required this.location,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final accent = _colorForLocation(location, era);
    final status = location.status;
    final isLocked = !status.isAccessible;
    final displayYear = location.displayYear;
    final kingdomLabel = location.kingdom != null
        ? (KingdomConfig.meta[location.kingdom!]?.label ?? location.kingdom!)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnhancedTimelineGutter(
          accentColor: accent,
          status: status,
          isFirst: isFirst,
          isLast: isLast,
          isSelected: isSelected,
          displayYear: displayYear,
        ),
        SizedBox(width: responsive.spacing(8)),
        Expanded(
          child: LocationStoryCard(
            location: location,
            accentColor: accent,
            isSelected: isSelected,
            isLocked: isLocked,
            kingdomLabel: kingdomLabel,
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Color _colorForLocation(Location location, Era era) {
    final kingdom = location.kingdom;
    final meta = kingdom != null ? KingdomConfig.meta[kingdom] : null;
    return meta?.color ?? era.theme.accentColor;
  }
}
