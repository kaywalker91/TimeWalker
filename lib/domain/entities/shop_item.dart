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


