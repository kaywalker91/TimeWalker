import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 지역 상세 화면
/// 
/// 지역 내 국가 목록을 표시하고 해당 국가의 시대 타임라인으로 이동
class RegionDetailScreen extends ConsumerStatefulWidget {
  final String regionId;

  const RegionDetailScreen({super.key, required this.regionId});

  @override
  ConsumerState<RegionDetailScreen> createState() => _RegionDetailScreenState();
}

class _RegionDetailScreenState extends ConsumerState<RegionDetailScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('[RegionDetailScreen] initState - regionId=${widget.regionId}');
  }

  @override
  void dispose() {
    debugPrint('[RegionDetailScreen] dispose - regionId=${widget.regionId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionAsync = ref.watch(regionByIdProvider(widget.regionId));
    final countriesAsync = ref.watch(countryListByRegionProvider(widget.regionId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Region Exploration',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: regionAsync.when(
            loading: () => _buildLoadingState(),
            error: (err, stack) => _buildErrorState('Error loading region: $err'),
            data: (region) {
              if (region == null) {
                return _buildErrorState('Region not found');
              }
              return Column(
                children: [
                  _buildRegionHeader(context, region),
                  Expanded(
                    child: countriesAsync.when(
                      loading: () => _buildLoadingState(),
                      error: (err, stack) => _buildErrorState('Error loading countries: $err'),
                      data: (countries) => _buildCountryList(context, countries, region),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const CommonLoadingState(
      message: '지역 정보를 불러오는 중...',
    );
  }

  Widget _buildErrorState(String message) {
    return CommonErrorState(
      message: message,
      showRetryButton: false,
    );
  }

  Widget _buildRegionHeader(BuildContext context, Region region) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            region.nameKorean,
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.textPrimary,
              shadows: AppShadows.textMd,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            region.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: region.progress,
                minHeight: 8,
                backgroundColor: AppColors.surface.withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '탐험 진행도: ${region.progressPercent}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryList(
    BuildContext context,
    List<Country> countries,
    Region region,
  ) {
    if (countries.isEmpty) {
      return Center(
        child: Text(
          '아직 발견된 국가가 없습니다.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return CountryCard(
          country: country,
          region: region,
        );
      },
    );
  }
}
