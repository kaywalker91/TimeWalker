import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 시대 타임라인 화면
/// 
/// "시간의 문" 컨셉 - 시대별 테마 색상이 적용된 카드 UI
class EraTimelineScreen extends ConsumerStatefulWidget {
  final String regionId;
  final String countryId;

  const EraTimelineScreen({
    super.key,
    required this.regionId,
    required this.countryId,
  });

  @override
  ConsumerState<EraTimelineScreen> createState() => _EraTimelineScreenState();
}

class _EraTimelineScreenState extends ConsumerState<EraTimelineScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('[EraTimelineScreen] initState - regionId=${widget.regionId}, countryId=${widget.countryId}');
  }

  @override
  void dispose() {
    debugPrint('[EraTimelineScreen] dispose - regionId=${widget.regionId}, countryId=${widget.countryId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryAsync = ref.watch(countryByIdProvider(widget.countryId));
    final erasAsync = ref.watch(eraListByCountryProvider(widget.countryId));

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.era_timeline_title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          backgroundColor: AppColors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
            onPressed: () => _handleBack(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.timePortal,
          ),
          child: Stack(
            children: [
              // 배경 입자 효과
              const Positioned.fill(
                child: FloatingParticles(
                  particleCount: 20,
                  particleColor: AppColors.starlight,
                  maxSize: 2,
                ),
              ),
              
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Country Info) with animation
                    countryAsync.when(
                      data: (country) {
                        if (country == null) return const SizedBox.shrink();
                        return FadeInWidget(
                          delay: const Duration(milliseconds: 200),
                          slideOffset: const Offset(0, -0.5),
                          child: _buildHeader(country),
                        );
                      },
                      loading: () => const SizedBox(height: 100),
                      error: (err, stack) => const SizedBox(height: 100),
                    ),

                    const Spacer(),

                    // Era List
                    SizedBox(
                      height: 450,
                      child: erasAsync.when(
                        loading: () => _buildLoadingState(),
                        error: (err, stack) => _buildErrorState('Error: $err'),
                        data: (eras) {
                          debugPrint('[EraTimelineScreen] Loaded ${eras.length} eras for ${widget.countryId}');
                          for (final era in eras) {
                            debugPrint('[EraTimelineScreen]   - ${era.id}: ${era.nameKorean}');
                          }
                          return _buildEraList(context, eras);
                        },
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    if (widget.regionId.isNotEmpty) {
      context.goNamed(
        'regionDetail',
        pathParameters: {'regionId': widget.regionId},
      );
      return;
    }

    context.go(AppRouter.worldMap);
  }
  
  Widget _buildHeader(Country country) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Country Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: AppShadows.goldenGlowSm,
                image: DecorationImage(
                  image: AssetImage(country.thumbnailAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppGradients.goldenText.createShader(bounds),
                    child: Text(
                      country.nameKorean, // TODO: Add Country.getNameForContext when Country entity is updated
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    country.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const CommonLoadingState.simple();
  }
  
  Widget _buildErrorState(String message) {
    return CommonErrorState(
      message: message,
      showRetryButton: false,
    );
  }

  Widget _buildEraList(BuildContext context, List<Era> eras) {
    if (eras.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.era_timeline_no_eras,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    // Watch user progress
    final userProgressAsync = ref.watch(userProgressProvider);
    final userProgress = userProgressAsync.valueOrNull;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      scrollDirection: Axis.horizontal,
      cacheExtent: 150.0, // 화면 밖 150px까지 사전 렌더링 (수평 스크롤)
      itemCount: eras.length,
      itemBuilder: (context, index) {
        return TimelineEraCard(
          era: eras[index],
          userProgress: userProgress,
          allEras: eras,
        );
      },
    );
  }
}
