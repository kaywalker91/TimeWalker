import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 장소 배경 이미지 위젯
/// 
/// 역사적 장소의 배경 이미지를 표시하며,
/// 이미지 로드 실패 시 fallback 이미지를 표시합니다.
class LocationBackground extends StatelessWidget {
  /// 주요 배경 이미지 경로
  final String backgroundAsset;
  
  /// 이미지 로드 실패 시 대체 이미지
  final String fallbackAsset;
  
  /// 오버레이 색상 (분위기 연출용)
  final Color? overlayColor;
  
  /// 오버레이 불투명도
  final double overlayOpacity;

  const LocationBackground({
    super.key,
    required this.backgroundAsset,
    required this.fallbackAsset,
    this.overlayColor,
    this.overlayOpacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 배경 이미지
        Image.asset(
          backgroundAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Failed to load background: $backgroundAsset, using fallback');
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                // 최종 fallback: 그라데이션 배경
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.spaceGradientTop,
                        AppColors.spaceGradientMid,
                        AppColors.spaceGradientBottom,
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        
        // 분위기 오버레이
        if (overlayColor != null)
          Container(
            color: overlayColor!.withValues(alpha: overlayOpacity),
          ),
        
        // 상단 그라데이션 (앱바 가독성)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.5),
                  AppColors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // 미세한 비네트 효과
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                AppColors.transparent,
                AppColors.black.withValues(alpha: 0.3),
              ],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
