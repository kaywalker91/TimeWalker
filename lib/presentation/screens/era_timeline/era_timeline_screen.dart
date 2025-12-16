import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

import '../../../domain/entities/user_progress.dart';

class EraTimelineScreen extends ConsumerWidget {
  final String regionId;
  final String countryId;

  const EraTimelineScreen({
    super.key,
    required this.regionId,
    required this.countryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryAsync = ref.watch(countryByIdProvider(countryId));
    final erasAsync = ref.watch(eraListByCountryProvider(countryId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Era Timeline'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRouter.goToRegion(context, regionId),
        ),
      ),
      body: Stack(
        children: [
          // Background - Consumed from Country Data
          countryAsync.when(
            data: (country) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                // image: DecorationImage(
                //   image: AssetImage(country?.backgroundAsset ?? ''),
                //   fit: BoxFit.cover,
                //   colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                // ),
              ),
            ),
            loading: () => Container(color: const Color(0xFF1E1E2C)),
            error: (err, stack) => Container(color: Colors.red),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Country Info)
                countryAsync.when(
                  data: (country) {
                    if (country == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            country.nameKorean,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            country.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (eras) => _buildEraList(context, ref, eras),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEraList(BuildContext context, WidgetRef ref, List<Era> eras) {
    if (eras.isEmpty) {
      return const Center(child: Text('No eras available yet.'));
    }

    // Watch user progress
    final userProgressAsync = ref.watch(userProgressProvider);
    final userProgress = userProgressAsync.valueOrNull;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      scrollDirection: Axis.horizontal,
      itemCount: eras.length,
      itemBuilder: (context, index) {
        return _buildEraCard(context, eras[index], userProgress);
      },
    );
  }

  Widget _buildEraCard(
    BuildContext context,
    Era era,
    UserProgress? userProgress,
  ) {
    // Check both the static status AND the dynamic user progress
    final isUnlocked =
        era.isAccessible ||
        (userProgress?.unlockedEraIds.contains(era.id) ?? false);
    final isLocked = !isUnlocked;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.grey[900]
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLocked ? Colors.grey[700]! : era.theme.primaryColor,
          width: 2,
        ),
        boxShadow: isLocked
            ? []
            : [
                BoxShadow(
                  color: era.theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This era is locked.')),
              );
            } else {
              AppRouter.goToEraExploration(context, era.id);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Era Title
                Text(
                  era.nameKorean,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  era.period,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLocked ? Colors.grey[600] : Colors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // Description
                Text(
                  era.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLocked ? Colors.grey[600] : Colors.white70,
                    height: 1.5,
                  ),
                ),
                const Spacer(),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLocked
                          ? Colors.grey[800]
                          : era.theme.primaryColor,
                      foregroundColor: isLocked ? Colors.grey : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLocked
                        ? null
                        : () {
                            AppRouter.goToEraExploration(context, era.id);
                          },
                    child: Text(
                      isLocked ? 'LOCKED' : 'EXPLORE',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
