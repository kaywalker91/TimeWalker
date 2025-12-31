/// TimeWalker 공통 AppBar 위젯 라이브러리
/// 
/// 앱 전체에서 사용할 수 있는 일관된 스타일의 AppBar 위젯들을 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/presentation/widgets/common/app_bars/app_bars.dart';
/// 
/// // 기본 AppBar
/// TimeWalkerAppBar(
///   title: '타임라인',
///   actions: [
///     TimeWalkerAppBarAction(
///       icon: Icons.settings,
///       onPressed: () => openSettings(),
///     ),
///   ],
/// );
/// 
/// // 투명 배경 AppBar
/// TimeWalkerAppBar.transparent(title: '세계 지도');
/// 
/// // 심플 AppBar (배경 없는 뒤로가기)
/// TimeWalkerAppBar.simple(title: '프로필');
/// 
/// // SliverAppBar
/// TimeWalkerSliverAppBar(
///   title: '도감',
///   expandedHeight: 200,
///   flexibleSpace: Image.asset('background.png'),
/// );
/// ```
library;

export 'time_walker_app_bar.dart';
