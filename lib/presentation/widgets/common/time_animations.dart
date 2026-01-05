/// TimeWalker 애니메이션 위젯 라이브러리
/// 
/// 이 파일은 기존 호환성을 위해 animations/ 폴더의 모든 위젯들을 re-export합니다.
/// 새로운 코드에서는 animations/animations.dart를 직접 import하는 것을 권장합니다.
/// 
/// 분리된 파일들:
/// - page_transitions.dart: TimePortalPageRoute, GoldenPageRoute
/// - fade_scale_animations.dart: FadeInWidget, ScaleInWidget, StaggeredListItem
/// - glow_effects.dart: PulseGlowWidget, GoldenShimmer
/// - loaders.dart: TimeLoader
/// - particles.dart: FloatingParticles, TimePortalRings
library;

export 'animations/animations.dart';
