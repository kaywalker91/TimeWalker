import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class EncyclopediaDetailScreen extends ConsumerWidget {
  final String entryId;

  const EncyclopediaDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(encyclopediaEntryByIdProvider(entryId));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: entryAsync.when(
        data: (entry) {
          if (entry == null) {
            return _buildError(context, 'Entry not found');
          }
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, entry),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type & Tags
                      Row(
                        children: [
                          _buildTag(entry.type.displayName, Colors.amber),
                          const SizedBox(width: 8),
                          ...entry.tags.map((tag) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildTag('#$tag', Colors.white30),
                              )),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        entry.titleKorean,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Summary Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          entry.summary,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.amber,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Main Content
                      const Text(
                        'Detailed Story',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        entry.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.8,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Related entries (optional expansion)
                      if (entry.relatedCount > 0) ...[
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 16),
                        const Text(
                          'Related',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Horizontal list could go here
                        Text(
                          '${entry.relatedCount} related entries available.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => _buildError(context, e.toString()),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, EncyclopediaEntry entry) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF1E1E2C),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              entry.imageAsset ?? entry.thumbnailAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black26),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    const Color(0xFF1E1E2C).withValues(alpha: 0.8),
                    const Color(0xFF1E1E2C),
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
