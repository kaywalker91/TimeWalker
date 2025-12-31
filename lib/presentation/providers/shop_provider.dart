import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/presentation/providers/user_progress_provider.dart';

/// ShopController manages the state of shop interactions (e.g. purchasing items).
/// It uses `AsyncValue<void>` to represent the status of the operation (Idle/Loading/Error).
class ShopController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state is idle (data: null)
    return;
  }

  /// Attempts to purchase a shop item.
  /// Throws generic exceptions for UI to handle or returns true/false for success.
  Future<void> purchaseItem(ShopItem item) async {
    final userProgressState = ref.read(userProgressProvider);
    
    // Ensure user progress is loaded
    if (!userProgressState.hasValue) {
      throw Exception('User progress is not loaded.');
    }
    
    final userProgress = userProgressState.value!;

    // 1. Validation Logic
    if (userProgress.coins < item.price) {
      throw const ShopException('shop_purchase_error_coins');
    }

    if (userProgress.inventoryIds.contains(item.id) && 
        item.type != ShopItemType.consumable) {
       /// ShopItemType: `&lt;type&gt;` - 상점 아이템 타입
       throw const ShopException('shop_purchase_error_owned');
    }

    // 2. Execute Purchase
    state = const AsyncLoading();

    try {
      // Use the UserProgressNotifier to update state globally
      await ref.read(userProgressProvider.notifier).updateProgress((current) {
        final newCoins = current.coins - item.price;
        final newInventory = List<String>.from(current.inventoryIds)..add(item.id);
        
        return current.copyWith(
          coins: newCoins,
          inventoryIds: newInventory,
        );
      });
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}

final shopControllerProvider = AsyncNotifierProvider<ShopController, void>(() {
  return ShopController();
});

/// Simple Exception class for Shop errors to be localized in UI
class ShopException implements Exception {
  final String l10nKey;
  const ShopException(this.l10nKey);
  
  @override
  String toString() => 'ShopException: $l10nKey';
}
