import '../../domain/entities/shop_item.dart';
import '../../domain/repositories/shop_repository.dart';

class MockShopRepository implements ShopRepository {
  @override
  Future<List<ShopItem>> getShopItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ShopData.all;
  }

  @override
  Future<List<ShopItem>> getItemsByType(ShopItemType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ShopData.all.where((item) => item.type == type).toList();
  }

  @override
  Future<ShopItem?> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return ShopData.all.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
