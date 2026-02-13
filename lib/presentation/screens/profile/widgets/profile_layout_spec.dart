import 'package:flutter/widgets.dart';

enum ProfileWidthClass { compact, phone }

/// Profile screen spacing/layout tokens for phone widths.
class ProfileLayoutSpec {
  final ProfileWidthClass widthClass;
  final double effectiveTextScale;

  final double pageHorizontal;
  final double pageTop;
  final double pageBottom;
  final double sectionGap;

  final double cardPadding;
  final double clusterGap;
  final double itemGap;
  final double microGap;

  final double gridGap;
  final double avatarSize;
  final double avatarRailHeight;
  final double rankBarHeight;
  final double statCardPadding;
  final double statsChildAspectRatio;
  final double idCardMinHeight;

  const ProfileLayoutSpec._({
    required this.widthClass,
    required this.effectiveTextScale,
    required this.pageHorizontal,
    required this.pageTop,
    required this.pageBottom,
    required this.sectionGap,
    required this.cardPadding,
    required this.clusterGap,
    required this.itemGap,
    required this.microGap,
    required this.gridGap,
    required this.avatarSize,
    required this.avatarRailHeight,
    required this.rankBarHeight,
    required this.statCardPadding,
    required this.statsChildAspectRatio,
    required this.idCardMinHeight,
  });

  factory ProfileLayoutSpec.fromContext(BuildContext context) {
    final media = MediaQuery.of(context);
    return ProfileLayoutSpec.fromValues(
      width: media.size.width,
      textScale: media.textScaler.scale(1.0),
    );
  }

  factory ProfileLayoutSpec.fromValues({
    required double width,
    required double textScale,
  }) {
    final widthClass = width <= 360
        ? ProfileWidthClass.compact
        : ProfileWidthClass.phone;
    final effectiveTextScale = textScale.clamp(1.0, 1.3).toDouble();
    final hasLargeText = effectiveTextScale > 1.15;
    final isCompact = widthClass == ProfileWidthClass.compact;

    final baseClusterGap = isCompact ? 16.0 : 20.0;
    final baseItemGap = isCompact ? 8.0 : 12.0;
    final textGapBoost = hasLargeText ? 4.0 : 0.0;

    return ProfileLayoutSpec._(
      widthClass: widthClass,
      effectiveTextScale: effectiveTextScale,
      pageHorizontal: isCompact ? 16.0 : 20.0,
      pageTop: isCompact ? 12.0 : 16.0,
      pageBottom: isCompact ? 24.0 : 28.0,
      sectionGap: isCompact ? 24.0 : 28.0,
      cardPadding: isCompact ? 16.0 : 20.0,
      clusterGap: baseClusterGap + textGapBoost,
      itemGap: baseItemGap + textGapBoost,
      microGap: isCompact ? 4.0 : 8.0,
      gridGap: isCompact ? 12.0 : 16.0,
      avatarSize: isCompact ? 64.0 : 72.0,
      avatarRailHeight: isCompact ? 72.0 : 80.0,
      rankBarHeight: isCompact ? 14.0 : 16.0,
      statCardPadding: isCompact ? 12.0 : 14.0,
      statsChildAspectRatio: isCompact ? 1.24 : 1.34,
      idCardMinHeight: isCompact ? 212.0 : 228.0,
    );
  }
}
