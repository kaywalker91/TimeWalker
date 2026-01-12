import 'package:time_walker/domain/entities/shop_item.dart';

class ShopData {
  ShopData._();

  static const List<ShopItem> all = [
    ShopItem(
      id: 'item_hint_01',
      name: '역사 힌트권',
      description: '어려운 퀴즈의 정답 힌트를 얻을 수 있습니다.',
      price: 50,
      type: ShopItemType.consumable,
      iconAsset: 'assets/icons/hint.png', 
    ),
    ShopItem(
      id: 'item_time_freeze_01',
      name: '크로노스 타임 스톱',
      description: '퀴즈 타이머를 10초간 멈춥니다.',
      price: 100,
      type: ShopItemType.consumable,
      iconAsset: 'assets/icons/freeze.png',
    ),
    ShopItem(
      id: 'theme_dark_mode',
      name: '미드나잇 테마',
      description: '앱의 특별한 미드나잇 테마를 잠금 해제합니다.',
      price: 500,
      type: ShopItemType.cosmetic,
      iconAsset: 'assets/icons/theme.png',
    ),
    ShopItem(
      id: 'avatar_frame_gold',
      name: '황금 프레임',
      description: '당신의 아바타를 빛내줄 황금빛 프레임입니다.',
      price: 1000,
      type: ShopItemType.cosmetic,
      iconAsset: 'assets/icons/frame.png',
    ),
  ];
}
