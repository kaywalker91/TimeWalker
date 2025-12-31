import 'package:time_walker/domain/entities/shop_item.dart';

class ShopData {
  ShopData._();

  static const List<ShopItem> all = [
    ShopItem(
      id: 'item_hint_01',
      name: 'History Hint',
      description: 'Get a hint for a difficult quiz.',
      price: 50,
      type: ShopItemType.consumable,
      iconAsset: 'assets/icons/hint.png', 
    ),
    ShopItem(
      id: 'item_time_freeze_01',
      name: 'Chronos Freeze',
      description: 'Freeze the timer for 10 seconds during a quiz.',
      price: 100,
      type: ShopItemType.consumable,
      iconAsset: 'assets/icons/freeze.png',
    ),
    ShopItem(
      id: 'theme_dark_mode',
      name: 'Midnight Theme',
      description: 'Unlock a special midnight theme for the app.',
      price: 500,
      type: ShopItemType.cosmetic,
      iconAsset: 'assets/icons/theme.png',
    ),
    ShopItem(
      id: 'avatar_frame_gold',
      name: 'Golden Frame',
      description: 'A shiny golden frame for your avatar.',
      price: 1000,
      type: ShopItemType.cosmetic,
      iconAsset: 'assets/icons/frame.png',
    ),
  ];
}
