import 'dart:math' as math;

import 'package:flutter/widgets.dart';

enum EraExplorationWidthClass { compact, phone, phablet, tablet }

enum EraExplorationTextScaleClass { normal, large, xlarge, max }

/// Responsive sizing tokens shared across era exploration widgets.
class EraExplorationLayoutSpec {
  final EraExplorationWidthClass widthClass;
  final EraExplorationTextScaleClass textScaleClass;
  final double effectiveTextScale;

  final double cardImageAspectRatio;
  final double cardMinHeight;
  final double cardMaxHeight;
  final int cardTitleMaxLines;
  final int cardDescriptionMaxLines;

  final double hudMinHeight;
  final double hudVerticalPadding;
  final double listBottomSafePadding;

  final double tabMinHeight;
  final int tabLabelMaxLines;

  const EraExplorationLayoutSpec({
    required this.widthClass,
    required this.textScaleClass,
    required this.effectiveTextScale,
    required this.cardImageAspectRatio,
    required this.cardMinHeight,
    required this.cardMaxHeight,
    required this.cardTitleMaxLines,
    required this.cardDescriptionMaxLines,
    required this.hudMinHeight,
    required this.hudVerticalPadding,
    required this.listBottomSafePadding,
    required this.tabMinHeight,
    required this.tabLabelMaxLines,
  });

  factory EraExplorationLayoutSpec.fromContext(BuildContext context) {
    return EraExplorationLayoutSpec.fromMediaQueryData(MediaQuery.of(context));
  }

  factory EraExplorationLayoutSpec.fromMediaQueryData(MediaQueryData media) {
    return EraExplorationLayoutSpec.fromValues(
      width: media.size.width,
      textScale: media.textScaler.scale(1.0),
    );
  }

  factory EraExplorationLayoutSpec.fromValues({
    required double width,
    required double textScale,
  }) {
    final widthClass = _resolveWidthClass(width);
    final textScaleClass = _resolveTextScaleClass(textScale);
    final effectiveTextScale = textScale.clamp(1.0, 1.6).toDouble();
    final base = _baseByWidthClass(widthClass);
    final scaleFactor = _scaleFactorByTextClass(textScaleClass);

    final cardMinHeight = base.cardMinHeight * scaleFactor;
    final cardMaxHeight = math.max(
      cardMinHeight + 40,
      base.cardMaxHeight * scaleFactor,
    );

    return EraExplorationLayoutSpec(
      widthClass: widthClass,
      textScaleClass: textScaleClass,
      effectiveTextScale: effectiveTextScale,
      cardImageAspectRatio: base.cardImageAspectRatio,
      cardMinHeight: cardMinHeight,
      cardMaxHeight: cardMaxHeight,
      cardTitleMaxLines: effectiveTextScale <= 1.15 ? 2 : 1,
      cardDescriptionMaxLines: effectiveTextScale <= 1.15 ? 2 : 1,
      hudMinHeight: math.max(48, base.hudMinHeight),
      hudVerticalPadding: base.hudVerticalPadding,
      listBottomSafePadding: base.listBottomSafePadding,
      tabMinHeight: base.tabMinHeight,
      tabLabelMaxLines: 1,
    );
  }

  bool get prefersHudWrap {
    return widthClass == EraExplorationWidthClass.compact ||
        textScaleClass == EraExplorationTextScaleClass.xlarge ||
        textScaleClass == EraExplorationTextScaleClass.max;
  }

  bool get prefersHudSingleColumn {
    return widthClass == EraExplorationWidthClass.compact &&
        textScaleClass != EraExplorationTextScaleClass.normal;
  }

  static EraExplorationWidthClass _resolveWidthClass(double width) {
    if (width <= 360) return EraExplorationWidthClass.compact;
    if (width <= 412) return EraExplorationWidthClass.phone;
    if (width <= 600) return EraExplorationWidthClass.phablet;
    return EraExplorationWidthClass.tablet;
  }

  static EraExplorationTextScaleClass _resolveTextScaleClass(double scale) {
    if (scale <= 1.15) return EraExplorationTextScaleClass.normal;
    if (scale <= 1.3) return EraExplorationTextScaleClass.large;
    if (scale <= 1.6) return EraExplorationTextScaleClass.xlarge;
    return EraExplorationTextScaleClass.max;
  }

  static _LayoutBaseTokens _baseByWidthClass(
    EraExplorationWidthClass widthClass,
  ) {
    switch (widthClass) {
      case EraExplorationWidthClass.compact:
        return const _LayoutBaseTokens(
          cardImageAspectRatio: 1.55,
          cardMinHeight: 222,
          cardMaxHeight: 284,
          hudMinHeight: 48,
          hudVerticalPadding: 8,
          listBottomSafePadding: 16,
          tabMinHeight: 48,
        );
      case EraExplorationWidthClass.phone:
        return const _LayoutBaseTokens(
          cardImageAspectRatio: 1.75,
          cardMinHeight: 228,
          cardMaxHeight: 300,
          hudMinHeight: 48,
          hudVerticalPadding: 8,
          listBottomSafePadding: 18,
          tabMinHeight: 48,
        );
      case EraExplorationWidthClass.phablet:
        return const _LayoutBaseTokens(
          cardImageAspectRatio: 2.0,
          cardMinHeight: 236,
          cardMaxHeight: 340,
          hudMinHeight: 52,
          hudVerticalPadding: 10,
          listBottomSafePadding: 20,
          tabMinHeight: 50,
        );
      case EraExplorationWidthClass.tablet:
        return const _LayoutBaseTokens(
          cardImageAspectRatio: 2.35,
          cardMinHeight: 248,
          cardMaxHeight: 380,
          hudMinHeight: 56,
          hudVerticalPadding: 12,
          listBottomSafePadding: 24,
          tabMinHeight: 56,
        );
    }
  }

  static double _scaleFactorByTextClass(
    EraExplorationTextScaleClass textClass,
  ) {
    switch (textClass) {
      case EraExplorationTextScaleClass.normal:
        return 1.0;
      case EraExplorationTextScaleClass.large:
        return 1.05;
      case EraExplorationTextScaleClass.xlarge:
        return 1.1;
      case EraExplorationTextScaleClass.max:
        return 1.14;
    }
  }
}

class _LayoutBaseTokens {
  final double cardImageAspectRatio;
  final double cardMinHeight;
  final double cardMaxHeight;
  final double hudMinHeight;
  final double hudVerticalPadding;
  final double listBottomSafePadding;
  final double tabMinHeight;

  const _LayoutBaseTokens({
    required this.cardImageAspectRatio,
    required this.cardMinHeight,
    required this.cardMaxHeight,
    required this.hudMinHeight,
    required this.hudVerticalPadding,
    required this.listBottomSafePadding,
    required this.tabMinHeight,
  });
}
