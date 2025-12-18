import 'package:equatable/equatable.dart';

enum ShopItemType {
  consumable, // e.g., Hint, Time Skip
  cosmetic,   // e.g., Avatar Frame, Theme
  upgrade,    // e.g., Multiplier
}

extension ShopItemTypeExtension on ShopItemType {
  String get displayName {
    switch (this) {
      case ShopItemType.consumable:
        return 'Consumable';
      case ShopItemType.cosmetic:
        return 'Cosmetic';
      case ShopItemType.upgrade:
        return 'Upgrade';
    }
  }
}

class ShopItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final ShopItemType type;
  final String iconAsset;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.iconAsset,
  });

  @override
  List<Object?> get props => [id, name, description, price, type, iconAsset];
}

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
