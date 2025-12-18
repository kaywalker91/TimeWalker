import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgressAsync = ref.watch(userProgressProvider);
    final allShopItemsAsync = ref.watch(shopItemListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('My Inventory'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: userProgressAsync.when(
        data: (userProgress) {
          return allShopItemsAsync.when(
            data: (allItems) {
              final inventoryIds = userProgress.inventoryIds;
              if (inventoryIds.isEmpty) {
                return _buildEmptyState();
              }

              // Resolve IDs to Item objects
              // Note: This logic assumes ID uniqueness and existence.
              final myItems = inventoryIds
                  .map((id) => allItems.firstWhere(
                        (item) => item.id == id,
                        // Handle cases where item might have been removed from shop data but exists in inventory
                        orElse: () => ShopItem(
                          id: id,
                          name: 'Unknown Item',
                          description: 'Item data not found',
                          price: 0,
                          type: ShopItemType.consumable,
                          iconAsset: 'assets/icons/unknown.png',
                        ),
                      ))
                  .toList();
                  
              // Group by type or just list? Let's just list with a nice card.
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  final item = myItems[index];
                  return _buildInventoryItemCard(context, item);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error loading items: $e', style: const TextStyle(color: Colors.white))),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading inventory: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Your inventory is empty.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItemCard(BuildContext context, ShopItem item) {
    return Card(
      color: const Color(0xFF2C2C3E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(Icons.shopping_bag, color: Colors.amber), // Placeholder icon
        ),
        title: Text(
          item.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item.type.displayName,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: item.type == ShopItemType.consumable 
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // Future integration: Consume item logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Used ${item.name}! (Mock)')),
                );
              },
              child: const Text('Use'),
            )
          : const Chip(
              label: Text('Equipped', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.green,
            ),
      ),
    );
  }
}
