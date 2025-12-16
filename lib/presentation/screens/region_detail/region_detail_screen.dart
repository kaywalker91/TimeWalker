import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class RegionDetailScreen extends ConsumerWidget {
  final String regionId;

  const RegionDetailScreen({super.key, required this.regionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionAsync = ref.watch(regionByIdProvider(regionId));
    final countriesAsync = ref.watch(countryListByRegionProvider(regionId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Region Exploration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E2C), // Fallback dark background
              // TODO: Use region.thumbnailAsset for background
            ),
          ),

          SafeArea(
            child: regionAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading region: $err')),
              data: (region) {
                if (region == null) {
                  return const Center(child: Text('Region not found'));
                }
                return Column(
                  children: [
                    _buildRegionHeader(context, region),
                    Expanded(
                      child: countriesAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(
                          child: Text('Error loading countries: $err'),
                        ),
                        data: (countries) =>
                            _buildCountryList(context, countries, region),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionHeader(BuildContext context, Region region) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            region.nameKorean,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            region.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          LinearProgressIndicator(
            value: region.progress,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
          const SizedBox(height: 4),
          Text(
            'Exploration Progress: ${region.progressPercent}%',
            style: const TextStyle(fontSize: 12, color: Colors.white54),
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return _buildCountryCard(context, country, region);
      },
    );
  }

  Widget _buildCountryCard(
    BuildContext context,
    Country country,
    Region region,
  ) {
    final isLocked = !country.isAccessible;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isLocked ? Colors.grey : Colors.amber.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This country is not yet available.'),
              ),
            );
          } else {
            // Navigate to Era Timeline
            // We use AppRouter's static helper
            AppRouter.goToEraTimeline(context, region.id, country.id);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                  // image: DecorationImage(image: AssetImage(country.thumbnailAsset)),
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.flag,
                  size: 40,
                  color: isLocked ? Colors.grey : Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.nameKorean,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      country.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isLocked ? Colors.grey[600] : Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow
              if (!isLocked)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
