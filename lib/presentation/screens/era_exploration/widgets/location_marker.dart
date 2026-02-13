import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// 지도 마커 위젯
/// 
/// 시대 탐험 화면에서 위치를 표시하는 원형 마커입니다.
/// 잠금, 완료, 선택 상태를 시각적으로 표시합니다.
class LocationMarker extends StatelessWidget {
  /// 표시할 위치
  final Location location;
  
  /// 마커의 기본 색상
  final Color baseColor;
  
  /// 마커의 X좌표 (왼쪽)
  final double left;
  
  /// 마커의 Y좌표 (위쪽)
  final double top;
  
  /// 마커 크기
  final double markerSize;
  
  /// 흐리게 표시 여부 (필터링으로 비활성화 시)
  final bool isDimmed;
  
  /// 선택됨 여부
  final bool isSelected;
  
  /// 라벨 표시 여부
  final bool showLabel;
  
  /// 탭 핸들러
  final VoidCallback? onTap;

  const LocationMarker({
    super.key,
    required this.location,
    required this.baseColor,
    required this.left,
    required this.top,
    required this.markerSize,
    required this.isDimmed,
    required this.isSelected,
    required this.showLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !location.isAccessible;
    final iconSize = markerSize * 0.56;
    final opacity = isDimmed ? 0.25 : 1.0;
    final markerColor = isLocked ? AppColors.greyDark : baseColor;
    final borderColor = isLocked ? AppColors.grey : baseColor;
    final icon = isLocked
        ? Icons.lock
        : location.isCompleted
            ? Icons.check
            : Icons.place;

    return Positioned(
      left: left - markerSize * 0.8,
      top: top - markerSize * 0.8,
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.exploration_location_locked),
                ),
              );
              return;
            }
            onTap?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Marker Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Container(
                      width: markerSize * 1.35,
                      height: markerSize * 1.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.6),
                          width: markerSize * 0.08,
                        ),
                      ),
                    ),
                  Container(
                    width: markerSize,
                    height: markerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: markerColor,
                      border: Border.all(
                        color: borderColor,
                        width: markerSize * 0.06,
                      ),
                      boxShadow: isLocked
                          ? []
                          : [
                              BoxShadow(
                                color: borderColor.withValues(alpha: 0.5),
                                blurRadius: markerSize * 0.3,
                                spreadRadius: markerSize * 0.04,
                              ),
                            ],
                    ),
                    child: Icon(icon, color: AppColors.white, size: iconSize),
                  ),
                ],
              ),
              if (showLabel) ...[
                SizedBox(height: markerSize * 0.16),
                // Label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: markerSize * 0.16,
                    vertical: markerSize * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black87,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Text(
                    location.getNameForContext(context),
                    style: TextStyle(
                      color: isLocked ? AppColors.grey : AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: markerSize * 0.24,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 위치 앵커 위젯 (마커와 연결선의 시작점)
class LocationAnchor extends StatelessWidget {
  /// 앵커의 X좌표
  final double left;
  
  /// 앵커의 Y좌표
  final double top;
  
  /// 앵커 크기
  final double size;
  
  /// 앵커 색상
  final Color color;
  
  /// 흐리게 표시 여부
  final bool isDimmed;
  
  /// 선택됨 여부
  final bool isSelected;

  const LocationAnchor({
    super.key,
    required this.left,
    required this.top,
    required this.size,
    required this.color,
    required this.isDimmed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isDimmed ? 0.35 : 1.0;
    final indicatorSize = isSelected ? size * 1.6 : size;

    return Positioned(
      left: left - indicatorSize * 0.5,
      top: top - indicatorSize * 0.5,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.9),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.6),
              width: indicatorSize * 0.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: indicatorSize * 1.2,
                spreadRadius: indicatorSize * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상태 범례 위젯
class StatusLegend extends StatelessWidget {
  /// 범례 색상
  final Color color;
  
  /// 범례 라벨
  final String label;

  const StatusLegend({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
