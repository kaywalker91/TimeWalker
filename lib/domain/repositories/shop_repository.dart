import '../entities/shop_item.dart';

abstract class ShopRepository {
  Future<List<ShopItem>> getShopItems();
  Future<List<ShopItem>> getItemsByType(ShopItemType type);
  Future<ShopItem?> getItemById(String id);
}
