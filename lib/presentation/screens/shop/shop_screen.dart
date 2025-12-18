import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

import '../../../core/routes/app_router.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ShopItemType> _tabs = ShopItemType.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _purchaseItem(ShopItem item, UserProgress userProgress) async {
    if (userProgress.coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins!')),
      );
      return;
    }

    if (userProgress.inventoryIds.contains(item.id) && item.type != ShopItemType.consumable) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already own this item!')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C3E),
        title: const Text('Confirm Purchase', style: TextStyle(color: Colors.white)),
        content: Text(
          'Buy ${item.name} for ${item.price} coins?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buy'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final newCoins = userProgress.coins - item.price;
      final newInventory = List<String>.from(userProgress.inventoryIds)..add(item.id);

      final newProgress = userProgress.copyWith(
        coins: newCoins,
        inventoryIds: newInventory,
      );

      final repository = ref.read(userProgressRepositoryProvider);
      await repository.saveUserProgress(newProgress);
      // Invalidate provider to refresh UI
      ref.invalidate(userProgressProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchased ${item.name}!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopItemsAsync = ref.watch(shopItemListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Item Shop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Inventory Button
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Colors.white),
            onPressed: () => context.push(AppRouter.inventory),
          ),
          userProgressAsync.when(
            data: (progress) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${progress.coins}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: [
            const Tab(text: 'All'),
            ..._tabs.map((type) => Tab(text: type.displayName)),
          ],
        ),
      ),
      body: shopItemsAsync.when(
        data: (items) {
          return userProgressAsync.when(
            data: (userProgress) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildGrid(items, userProgress),
                  ..._tabs.map((type) {
                    final filtered = items.where((i) => i.type == type).toList();
                    return _buildGrid(filtered, userProgress);
                  }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildGrid(List<ShopItem> items, UserProgress userProgress) {
    if (items.isEmpty) {
      return const Center(child: Text('No items available.', style: TextStyle(color: Colors.white54)));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final crossAxisCount = responsive.gridColumns(phoneColumns: 2, tabletColumns: 3, desktopColumns: 4);
        final padding = responsive.padding(16);
        final spacing = responsive.spacing(16);
        final iconSize = responsive.iconSize(48);
        final nameFontSize = responsive.fontSize(16);
        final descFontSize = responsive.fontSize(10);
        final priceFontSize = responsive.fontSize(12);
        final itemPadding = responsive.padding(12);
        
        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.isSmallPhone ? 0.7 : 0.75,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isOwned = userProgress.inventoryIds.contains(item.id) && item.type != ShopItemType.consumable;
            
            return Card(
              color: const Color(0xFF2C2C3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: isOwned ? null : () => _purchaseItem(item, userProgress),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: iconSize,
                          color: isOwned ? Colors.grey : Colors.amber,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: itemPadding),
                        child: Column(
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                color: isOwned ? Colors.grey : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: nameFontSize,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: responsive.spacing(4)),
                            Text(
                              item.description,
                              style: TextStyle(
                                color: isOwned ? Colors.grey : Colors.white60,
                                fontSize: descFontSize,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.padding(12),
                                vertical: responsive.padding(4),
                              ),
                              decoration: BoxDecoration(
                                color: isOwned ? Colors.grey.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isOwned ? 'Owned' : '${item.price} Coins',
                                style: TextStyle(
                                  color: isOwned ? Colors.grey : Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: priceFontSize,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
