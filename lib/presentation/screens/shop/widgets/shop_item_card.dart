import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

class ShopItemCard extends ConsumerWidget {
  final ShopItem item;
  final bool isOwned;
  final VoidCallback? onTap;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.isOwned,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final iconSize = responsive.iconSize(48);
    final nameFontSize = responsive.fontSize(16);
    final descFontSize = responsive.fontSize(10);
    final priceFontSize = responsive.fontSize(12);
    final itemPadding = responsive.padding(12);

    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: AppColors.shopCardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Icon(
                  Icons.shopping_bag, // Ideally use item.iconAsset if it were an IconData or Image widget
                  size: iconSize,
                  color: isOwned ? Colors.grey : AppColors.gold,
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isOwned ? Colors.grey : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: nameFontSize,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    Flexible( // Use Flexible for description
                      child: Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isOwned ? Colors.grey : Colors.white60,
                              fontSize: descFontSize,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    FittedBox( // Use FittedBox for price/status container
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.padding(12),
                          vertical: responsive.padding(4),
                        ),
                        decoration: BoxDecoration(
                          color: isOwned
                              ? Colors.grey.withValues(alpha: 0.2)
                              : AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOwned
                              ? l10n.shop_item_owned
                              : l10n.shop_item_price(item.price),
                          style: TextStyle(
                            color: isOwned ? Colors.grey : AppColors.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: priceFontSize,
                          ),
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
  }
}
