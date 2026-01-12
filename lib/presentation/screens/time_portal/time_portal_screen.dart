import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/civilization_provider.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/civilization_portal.dart';
import 'package:time_walker/presentation/screens/time_portal/widgets/exploration_panel.dart';
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

  void _showLockedDialog(Civilization civilization) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: civilization.portalColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.lock, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(
              civilization.name,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              civilization.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '탐험가 레벨 ${civilization.unlockLevel} 필요',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: TextStyle(color: civilization.portalColor),
            ),
          ),
        ],
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go(AppRouter.mainMenu);
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
      'asia': Offset(0.25, 0.12),        // 좌상단
      'europe': Offset(0.75, 0.12),      // 우상단
      'americas': Offset(0.50, 0.48),    // 정중앙
      'middle_east': Offset(0.25, 0.82), // 좌하단
      'africa': Offset(0.75, 0.82),      // 우하단
    };

    return Stack(
      clipBehavior: Clip.none,
      children: civilizations.map((civ) {
        // 해당 문명의 위치 가져오기 (없으면 기본값)
        final position = portalPositions[civ.id] ?? Offset(0.5, 0.5);
        
        // 가용 영역 내에서 실제 좌표 계산
        final left = (position.dx * availableWidth) - (portalSize / 2);
        final top = (position.dy * availableHeight) - (portalSize / 2);
        
        return Positioned(
          left: left.clamp(0, availableWidth - portalSize),
          top: top.clamp(0, availableHeight - portalSize),
          child: CivilizationPortal(
            civilization: civ,
            size: portalSize,
            onTap: () => _onCivilizationTap(civ),
          ),
        );
      }).toList(),
    );
  }
}

