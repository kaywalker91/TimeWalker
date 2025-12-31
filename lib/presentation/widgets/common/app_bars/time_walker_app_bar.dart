import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/themes/themes.dart';

/// TimeWalker 공통 AppBar
/// 
/// 모든 화면에서 일관된 앱바 UI를 제공합니다.
/// "시간의 문" 테마에 맞는 투명 배경 + 황금빛 액센트 스타일
class TimeWalkerAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// AppBar 제목
  final String? title;
  
  /// 제목 위젯 (title 대신 사용)
  final Widget? titleWidget;
  
  /// 뒤로가기 버튼 표시 여부 (기본: true)
  final bool showBackButton;
  
  /// 커스텀 뒤로가기 콜백
  final VoidCallback? onBack;
  
  /// 오른쪽 액션 버튼들
  final List<Widget>? actions;
  
  /// AppBar 배경색 (기본: 투명)
  final Color? backgroundColor;
  
  /// 타이틀 중앙 정렬 여부 (기본: true)
  final bool centerTitle;
  
  /// 뒤로가기 버튼 배경 표시 여부 (기본: true)
  final bool showBackButtonBackground;
  
  /// 높이 (기본: kToolbarHeight)
  final double height;

  const TimeWalkerAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.showBackButtonBackground = true,
    this.height = kToolbarHeight,
  });

  /// 투명 배경 + 원형 버튼 스타일 (기본 스타일)
  const TimeWalkerAppBar.transparent({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.centerTitle = true,
  })  : backgroundColor = Colors.transparent,
        showBackButtonBackground = true,
        height = kToolbarHeight;

  /// 심플 스타일 (배경 없는 뒤로가기 버튼)
  const TimeWalkerAppBar.simple({
    super.key,
    this.title,
    this.titleWidget,
    this.onBack,
    this.actions,
    this.centerTitle = true,
  })  : showBackButton = true,
        backgroundColor = Colors.transparent,
        showBackButtonBackground = false,
        height = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      toolbarHeight: height,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      
      // 뒤로가기 버튼
      leading: showBackButton ? _buildBackButton(context) : null,
      
      // 타이틀
      title: titleWidget ?? (title != null
          ? Text(
              title!,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              ),
            )
          : null),
      
      // 액션 버튼들
      actions: actions?.map((action) {
        // ActionButton이면 그대로, 아니면 래핑
        if (action is TimeWalkerAppBarAction) {
          return action;
        }
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: action,
        );
      }).toList(),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final button = IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.pop(context);
        }
      },
    );

    if (showBackButtonBackground) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: button,
        ),
      );
    }

    return button;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// AppBar 액션 버튼
/// 
/// 일관된 스타일의 액션 버튼을 생성합니다.
class TimeWalkerAppBarAction extends StatelessWidget {
  /// 버튼 아이콘
  final IconData icon;
  
  /// 클릭 콜백
  final VoidCallback onPressed;
  
  /// 배경 표시 여부 (기본: true)
  final bool showBackground;
  
  /// 아이콘 색상 (기본: AppColors.iconPrimary)
  final Color? iconColor;
  
  /// 배지 표시 (알림 등)
  final bool showBadge;
  
  /// 배지 숫자 (0이면 점만 표시)
  final int? badgeCount;

  const TimeWalkerAppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showBackground = true,
    this.iconColor,
    this.showBadge = false,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconButton = IconButton(
      icon: Icon(icon, color: iconColor ?? AppColors.iconPrimary),
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
    );

    if (showBadge) {
      iconButton = Badge(
        isLabelVisible: showBadge,
        label: badgeCount != null && badgeCount! > 0
            ? Text(
                badgeCount! > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(fontSize: 10),
              )
            : null,
        child: iconButton,
      );
    }

    if (showBackground) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: iconButton,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: iconButton,
    );
  }
}

/// 확장 AppBar (스크롤 시 축소되는 타입)
/// 
/// SliverAppBar 래퍼로, 이미지/배경이 있는 화면에서 사용
class TimeWalkerSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? flexibleSpace;
  final double expandedHeight;
  final bool pinned;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const TimeWalkerSliverAppBar({
    super.key,
    this.title,
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.pinned = true,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      backgroundColor: AppColors.background,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
            onPressed: () {
              HapticFeedback.lightImpact();
              if (onBack != null) {
                onBack!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      actions: actions?.map((action) {
        if (action is TimeWalkerAppBarAction) {
          return action;
        }
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: action,
        );
      }).toList(),
      flexibleSpace: FlexibleSpaceBar(
        title: title != null
            ? Text(
                title!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              )
            : null,
        background: flexibleSpace ?? Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.timePortal,
          ),
        ),
      ),
    );
  }
}
