/// TimeWalker 공통 피드백 위젯 라이브러리
/// 
/// 로딩, 에러, 빈 상태 등 사용자 피드백 관련 위젯들을 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/presentation/widgets/common/feedback/feedback_widgets.dart';
/// 
/// // 로딩 상태
/// CommonLoadingState(message: '로딩 중...');
/// CommonLoadingState.simple();
/// CommonLoadingState.overlay(message: '저장 중...');
/// 
/// // 에러 상태
/// CommonErrorState(message: '오류 발생', onRetry: () => refresh());
/// CommonErrorState.network(onRetry: () => fetchData());
/// CommonErrorState.loadFailed(onRetry: () => reload());
/// 
/// // 빈 상태
/// CommonEmptyState(message: '아직 데이터가 없습니다');
/// CommonEmptyState.noSearchResults();
/// CommonEmptyState.notDiscovered(onAction: () => goToExplore());
/// ```
library;

export 'loading_state.dart';
export 'error_state.dart';
export 'empty_state.dart';
