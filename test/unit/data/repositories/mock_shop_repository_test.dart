import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/data/datasources/static/shop_data.dart';
import 'package:time_walker/data/repositories/mock_shop_repository.dart';
import 'package:time_walker/domain/entities/shop_item.dart';

void main() {
  group('MockShopRepository', () {
    late MockShopRepository repository;

    setUp(() {
      repository = MockShopRepository();
    });

    test('getShopItems returns all items from static data', () async {
      final items = await repository.getShopItems();
      expect(items.length, equals(ShopData.all.length));
    });

    test('getItemsByType filters items correctly', () async {
      final consumableItems = await repository.getItemsByType(ShopItemType.consumable);
      
      expect(consumableItems, isNotEmpty);
      for (final item in consumableItems) {
        expect(item.type, equals(ShopItemType.consumable));
      }

      final cosmeticItems = await repository.getItemsByType(ShopItemType.cosmetic);
      expect(cosmeticItems, isNotEmpty);
      for (final item in cosmeticItems) {
        expect(item.type, equals(ShopItemType.cosmetic));
      }
    });

    test('getItemById returns correct item', () async {
      final targetItem = ShopData.all.first;
      final item = await repository.getItemById(targetItem.id);
      
      expect(item, isNotNull);
      expect(item!.id, equals(targetItem.id));
      expect(item.name, equals(targetItem.name));
    });

    test('getItemById returns null for non-existent id', () async {
      final item = await repository.getItemById('non_existent_item_id');
      expect(item, isNull);
    });

    test('ShopItem entity check', () {
      final item = ShopItem(
        id: 'test_item',
        name: 'Test Item',
        description: 'Description',
        price: 100,
        type: ShopItemType.upgrade,
        iconAsset: 'assets/icon.png',
      );

      expect(item.id, equals('test_item'));
      expect(item.price, equals(100));
      expect(item.type, equals(ShopItemType.upgrade));
    });
  });
}
