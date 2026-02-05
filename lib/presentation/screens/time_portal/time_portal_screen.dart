import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/civilization_provider.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/civilization_portal.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/exploration_panel.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/locked_portal_dialog.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/space_time_background.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// 시공의 회랑 (Time Portal) 화면
/// 
/// 5대 문명 포탈을 통해 시간 여행을 시작하는 메인 허브 화면입니다.
class TimePortalScreen extends ConsumerStatefulWidget {
  const TimePortalScreen({super.key});

  @override
  ConsumerState<TimePortalScreen> createState() => _TimePortalScreenState();
}

class _TimePortalScreenState extends ConsumerState<TimePortalScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;
      
      // BGM 재생 (월드맵 BGM 재사용)
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmWorldMap) {
        ref.read(bgmControllerProvider.notifier).playWorldMapBgm();
      }
    });
  }

  void _onCivilizationTap(Civilization civilization) {
    // 햅틱 피드백
    HapticFeedback.lightImpact();
    
    if (civilization.status == CivilizationStatus.locked) {
      // 잠금된 문명
      _showLockedDialog(civilization);
    } else {
      // 해금된 문명 → 해당 지역 상세 화면으로 이동
      // 기존 RegionDetailScreen 활용 (region ID와 civilization ID 매핑)
      context.pushNamed(
        'regionDetail',
        pathParameters: {'regionId': civilization.id},
      );
    }
  }

  void _showLockedDialog(Civilization civ) {
    showDialog(
      context: context,

      builder: (context) => LockedPortalDialog(
        civilization: civ,
        onConfirm: () => Navigator.pop(context),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
            AppLocalizations.of(context)!.time_portal_help_title,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
            AppLocalizations.of(context)!.time_portal_help_msg,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final civilizationsAsync = ref.watch(civilizationsWithProgressProvider);
    final currentCivAsync = ref.watch(currentCivilizationProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.mainMenu);
            }
          },
        ),
        title: Text(
          '시공의 회랑',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.iconPrimary),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showHelpDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.iconPrimary),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(AppRouter.settings);
            },
          ),
        ],
      ),
      body: SpaceTimeBackground(
        targetColor: currentCivAsync.value?.portalColor.toColor(),
        child: SafeArea(
          // SafeArea 내부에서 Column으로 영역 분리
          child: civilizationsAsync.when(
            data: (civilizations) => Column(
              children: [
                // 포탈 영역 (가용 공간 전체 사용)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildPortalGrid(
                        civilizations,
                        constraints,
                        currentCivAsync.value,
                      );
                    },
                  ),
                ),
                
                // 하단 상태 패널 (고정 높이)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: ExplorationPanel(
                    currentCivilization: currentCivAsync.value,
                    onTap: currentCivAsync.value != null
                        ? () => _onCivilizationTap(currentCivAsync.value!)
                        : null,
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (error, stack) => Center(
              child: Text(
                '오류가 발생했습니다: $error',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 포탈 그리드 빌드 (LayoutBuilder constraints 기반)
  Widget _buildPortalGrid(
    List<Civilization> civilizations,
    BoxConstraints constraints,
    Civilization? currentCivilization,
  ) {
    final availableWidth = constraints.maxWidth;
    final availableHeight = constraints.maxHeight;
    
    // 반응형 포탈 크기 (화면 크기에 따라 조정)
    final portalSize = (availableWidth * 0.22).clamp(70.0, 120.0);
    
    // 포탈 위치 정의 (가용 영역 기준 비율)
    // 2-1-2 다이아몬드 패턴
    final portalPositions = {
      'asia': const Offset(0.20, 0.15),        // 좌상단 (조금 더 안쪽으로)
      'europe': const Offset(0.80, 0.15),      // 우상단
      'americas': const Offset(0.50, 0.50),    // 정중앙
      'middle_east': const Offset(0.20, 0.85), // 좌하단
      'africa': const Offset(0.80, 0.85),      // 우하단
    };

    // 포탈 위치 계산 (캐싱하여 painter에도 전달)
    final Map<String, Offset> calculatedPositions = {};
    for (var entry in portalPositions.entries) {
      final left = (entry.value.dx * availableWidth);
      final top = (entry.value.dy * availableHeight);
      calculatedPositions[entry.key] = Offset(left, top);
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 1. 별자리 연결선 (가장 뒤) - RepaintBoundary로 분리
        RepaintBoundary(
          child: CustomPaint(
            size: Size(availableWidth, availableHeight),
            painter: _ConstellationPainter(
              positions: calculatedPositions,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ),

        // 2. 포탈들
        ...civilizations.map((civ) {
          // 해당 문명의 위치 가져오기 (없으면 기본값)
          final centerPos = calculatedPositions[civ.id] ?? Offset(availableWidth/2, availableHeight/2);
          
          // 위젯은 좌상단 기준 좌표가 필요하므로 크기만큼 보정
          final left = centerPos.dx - (portalSize / 2);
          final top = centerPos.dy - (portalSize / 2);
          
          return Positioned(
            left: left.clamp(0, availableWidth - portalSize),
            top: top.clamp(0, availableHeight - portalSize),
            child: CivilizationPortal(
              civilization: civ,
              size: portalSize,
              onTap: () => _onCivilizationTap(civ),
            ),
          );
        }),
      ],
    );
  }
}

/// 별자리 연결선 페인터
class _ConstellationPainter extends CustomPainter {
  final Map<String, Offset> positions;
  final Color color;

  _ConstellationPainter({required this.positions, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 연결 정의 (시작점 id -> 끝점 id)
    final connections = [
      // 중앙(아메리카)에서 4방향으로 방사
      ('americas', 'asia'),
      ('americas', 'europe'),
      ('americas', 'middle_east'),
      ('americas', 'africa'),
      
      // 외곽 연결 (역사적/지리적 흐름)
      ('asia', 'middle_east'),     // 실크로드
      ('middle_east', 'africa'),   // 인접
      ('middle_east', 'europe'),   // 인접/교류
      ('africa', 'europe'),        // 지중해
    ];

    for (var conn in connections) {
      final start = positions[conn.$1];
      final end = positions[conn.$2];

      if (start != null && end != null) {
        // 점선 그리기
        _drawDashedLine(canvas, start, end, paint);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 4.0;
    const double dashSpace = 4.0;
    
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    
    double currentDistance = 0.0;
    
    while (currentDistance < distance) {
      double startX = p1.dx + currentDistance * dx;
      double startY = p1.dy + currentDistance * dy;
      
      // 선 그리기
      canvas.drawLine(
        Offset(startX, startY),
        Offset(
          startX + dashWidth * dx,
          startY + dashWidth * dy,
        ),
        paint,
      );
      
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter oldDelegate) => false;
}
