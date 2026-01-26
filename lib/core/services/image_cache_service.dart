import 'package:flutter/material.dart';

/// 이미지 사전 캐싱 서비스
/// 
/// 앱 시작 시 핵심 이미지를 사전 로드하여 UX를 개선합니다.
class ImageCacheService {
  ImageCacheService._();
  
  static bool _isInitialized = false;
  
  /// 핵심 에셋 이미지 경로 목록
  /// 
  /// 앱 시작 시 바로 보이는 화면들의 이미지를 우선 로드
  static const List<String> _criticalAssets = [
    // 포탈 이미지 (시공의 회랑)
    'assets/images/portals/portal_asia.png',
    'assets/images/portals/portal_europe.png',
    'assets/images/portals/portal_americas.png',
    'assets/images/portals/portal_middle_east.png',
    'assets/images/portals/portal_africa.png',
    
    // 핵심 시대 썸네일 (한반도)
    'assets/images/eras/three_kingdoms.png',
    'assets/images/eras/unified_silla.png',
    'assets/images/eras/goryeo.png',
    'assets/images/eras/joseon.png',
    'assets/images/eras/modern.png',
    'assets/images/eras/contemporary.png',
    
    // UI 요소
    'assets/images/map/korea.png',
  ];
  
  /// 초기화 여부 확인
  static bool get isInitialized => _isInitialized;
  
  /// 핵심 이미지 사전 캐싱
  /// 
  /// [context]는 BuildContext로, 스플래시 화면에서 호출합니다.
  /// 백그라운드에서 실행되며 완료를 기다리지 않아도 됩니다.
  static Future<void> precacheCriticalImages(BuildContext context) async {
    if (_isInitialized) return;
    
    debugPrint('[ImageCacheService] Starting precache of ${_criticalAssets.length} images');
    
    final futures = <Future<void>>[];
    
    for (final assetPath in _criticalAssets) {
      futures.add(
        precacheImage(
          AssetImage(assetPath),
          context,
        ).catchError((error) {
          // 개별 이미지 로드 실패 시 전체 프로세스는 계속 진행
          debugPrint('[ImageCacheService] Failed to precache: $assetPath - $error');
        }),
      );
    }
    
    try {
      await Future.wait(futures);
      _isInitialized = true;
      debugPrint('[ImageCacheService] Precaching complete');
    } catch (e) {
      debugPrint('[ImageCacheService] Error during precaching: $e');
    }
  }
  
  /// 특정 이미지들 사전 캐싱 (지연 로딩용)
  /// 
  /// 특정 화면 진입 전 필요한 이미지를 미리 로드
  static Future<void> precacheImages(
    BuildContext context, 
    List<String> assetPaths,
  ) async {
    final futures = assetPaths.map((path) => 
      precacheImage(AssetImage(path), context).catchError((e) {
        debugPrint('[ImageCacheService] Failed to precache: $path');
      }),
    ).toList();
    
    await Future.wait(futures);
  }
  
  /// 이미지 캐시 크기 설정
  /// 
  /// 앱 시작 시 호출하여 캐시 제한 설정
  static void configureImageCache({
    int maximumSize = 100,
    int maximumSizeBytes = 50 * 1024 * 1024, // 50MB
  }) {
    PaintingBinding.instance.imageCache.maximumSize = maximumSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maximumSizeBytes;
    debugPrint('[ImageCacheService] Cache configured: $maximumSize images, ${maximumSizeBytes ~/ (1024 * 1024)}MB');
  }
  
  /// 캐시 초기화 (메모리 부족 시)
  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    _isInitialized = false;
    debugPrint('[ImageCacheService] Cache cleared');
  }
}
