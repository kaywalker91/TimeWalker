import 'package:flutter/material.dart';

/// 디바이스 유형
enum DeviceType { phone, tablet, desktop }

/// 화면 크기 브레이크포인트
class Breakpoints {
  static const double phoneMax = 600;
  static const double tabletMax = 1200;
  
  // 세부 브레이크포인트
  static const double smallPhone = 360;
  static const double mediumPhone = 400;
  static const double largePhone = 600;
}

/// 반응형 유틸리티 클래스
class ResponsiveUtils {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;
  late final DeviceType deviceType;
  late final bool isSmallPhone;
  late final bool isLandscape;

  ResponsiveUtils(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isLandscape = size.width > size.height;
    
    if (screenWidth < Breakpoints.phoneMax) {
      deviceType = DeviceType.phone;
    } else if (screenWidth < Breakpoints.tabletMax) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.desktop;
    }
    
    isSmallPhone = screenWidth < Breakpoints.smallPhone;
  }

  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// 화면 너비 비율 기반 값 계산
  double wp(double percentage) => screenWidth * percentage / 100;

  /// 화면 높이 비율 기반 값 계산
  double hp(double percentage) => screenHeight * percentage / 100;

  /// 반응형 폰트 크기
  double fontSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.85;
    if (deviceType == DeviceType.tablet) return baseSize * 1.1;
    if (deviceType == DeviceType.desktop) return baseSize * 1.2;
    return baseSize;
  }

  /// 반응형 패딩
  double padding(double basePadding) {
    if (isSmallPhone) return basePadding * 0.75;
    if (deviceType == DeviceType.tablet) return basePadding * 1.25;
    if (deviceType == DeviceType.desktop) return basePadding * 1.5;
    return basePadding;
  }

  /// 반응형 아이콘 크기
  double iconSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.8;
    if (deviceType == DeviceType.tablet) return baseSize * 1.2;
    if (deviceType == DeviceType.desktop) return baseSize * 1.4;
    return baseSize;
  }

  /// 반응형 간격
  double spacing(double baseSpacing) {
    if (isSmallPhone) return baseSpacing * 0.7;
    if (deviceType == DeviceType.tablet) return baseSpacing * 1.2;
    return baseSpacing;
  }

  /// 그리드 컬럼 수 계산
  int gridColumns({int phoneColumns = 2, int tabletColumns = 3, int desktopColumns = 4}) {
    switch (deviceType) {
      case DeviceType.phone:
        return phoneColumns;
      case DeviceType.tablet:
        return tabletColumns;
      case DeviceType.desktop:
        return desktopColumns;
    }
  }

  /// 최소 터치 타겟 크기 (접근성)
  double get minTouchTarget => isSmallPhone ? 44.0 : 48.0;

  /// 반응형 마커 크기
  double markerSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.7;
    if (deviceType == DeviceType.tablet) return baseSize * 1.1;
    return baseSize;
  }

  /// 반응형 카드 최대 너비
  double cardMaxWidth({double phoneMax = double.infinity, double tabletMax = 600, double desktopMax = 800}) {
    switch (deviceType) {
      case DeviceType.phone:
        return phoneMax;
      case DeviceType.tablet:
        return tabletMax;
      case DeviceType.desktop:
        return desktopMax;
    }
  }

  /// 버튼 높이
  double buttonHeight({double phone = 48, double tablet = 56, double desktop = 60}) {
    switch (deviceType) {
      case DeviceType.phone:
        return isSmallPhone ? phone * 0.9 : phone;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
}

/// BuildContext 확장
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
  
  bool get isSmallScreen => MediaQuery.of(this).size.width < Breakpoints.smallPhone;
  bool get isTablet => MediaQuery.of(this).size.width >= Breakpoints.phoneMax;
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.tabletMax;
  bool get isLandscape => MediaQuery.of(this).size.width > MediaQuery.of(this).size.height;
}

/// 반응형 위젯 빌더
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils responsive) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils(context));
  }
}

/// 레이아웃 기반 반응형 위젯
class ResponsiveLayout extends StatelessWidget {
  final Widget phone;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    switch (responsive.deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? phone;
      case DeviceType.tablet:
        return tablet ?? phone;
      case DeviceType.phone:
        return phone;
    }
  }
}
