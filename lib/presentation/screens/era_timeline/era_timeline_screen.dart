import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/era.dart';
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
      onPopInvoked: (didPop) {
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
          backgroundColor: Colors.transparent,
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
                          child: _buildHeader(country.nameKorean, country.description),
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
                        data: (eras) => _buildEraList(context, eras),
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
  
  Widget _buildHeader(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.textPrimary,
              shadows: AppShadows.textMd,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              shadows: AppShadows.textSm,
            ),
          ),
        ],
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
