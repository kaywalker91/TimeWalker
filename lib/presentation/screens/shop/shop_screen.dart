import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/providers/shop_provider.dart';
import 'package:time_walker/presentation/screens/shop/widgets/shop_item_card.dart';
import 'package:time_walker/presentation/screens/shop/widgets/purchase_confirm_dialog.dart';

import '../../../core/routes/app_router.dart';

/// 상점 화면
/// 
/// "시간의 문" 테마 - 프리미엄 골드 테마
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ShopItemType> _tabs = ShopItemType.values;

  @override
  void initState() {
    super.initState();
    debugPrint('[ShopScreen] initState');
    _tabController = TabController(length: _tabs.length + 1, vsync: this);
  }

  @override
  void dispose() {
    debugPrint('[ShopScreen] dispose');
    _tabController.dispose();
    super.dispose();
  }

  String _getTabLabel(BuildContext context, ShopItemType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case ShopItemType.consumable:
        return l10n.shop_tab_consumable;
      case ShopItemType.cosmetic:
        return l10n.shop_tab_cosmetic;
      case ShopItemType.upgrade:
        return l10n.shop_tab_upgrade;
    }
  }

  Future<void> _handlePurchase(ShopItem item, UserProgress userProgress) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. Pre-check (Optional, for fast feedback)
    if (userProgress.coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.shop_purchase_error_coins),
          backgroundColor: AppColors.error.withValues(alpha: 0.9),
        ),
      );
      return;
    }

    if (userProgress.inventoryIds.contains(item.id) && item.type != ShopItemType.consumable) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.shop_purchase_error_owned),
          backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        ),
      );
      return;
    }

    // 2. Confirm Dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => PurchaseConfirmDialog(item: item),
    );

    if (confirmed != true) return;

    // 3. Delegate to Controller
    try {
      await ref.read(shopControllerProvider.notifier).purchaseItem(item);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shop_purchase_success(item.name)),
            backgroundColor: AppColors.success.withValues(alpha: 0.9),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      String message = e.toString();
      if (e is ShopException) {
        if (e.l10nKey == 'shop_purchase_error_coins') {
          message = l10n.shop_purchase_error_coins;
        } else if (e.l10nKey == 'shop_purchase_error_owned') {
          message = l10n.shop_purchase_error_owned;
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error.withValues(alpha: 0.9),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopItemsAsync = ref.watch(shopItemListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);
    
    // Watch controller state to show loading overlay if needed
    final shopState = ref.watch(shopControllerProvider);
    final isLoading = shopState.isLoading;

    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.timePortal,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 커스텀 앱바
                  _buildAppBar(context, userProgressAsync),
                  
                  // 탭바
                  _buildTabBar(context),
                  
                  // 콘텐츠
                  Expanded(
                    child: shopItemsAsync.when(
                      data: (items) {
                        return userProgressAsync.when(
                          data: (userProgress) {
                            return TabBarView(
                              controller: _tabController,
                              children: [
                                _buildGrid(items, userProgress),
                                ..._tabs.map((type) {
                                  final filtered = items.where((i) => i.type == type).toList();
                                  return _buildGrid(filtered, userProgress);
                                }),
                              ],
                            );
                          },
                          loading: () => _buildLoadingState(),
                          error: (e, s) => _buildErrorState('Error: $e'),
                        );
                      },
                      loading: () => _buildLoadingState(),
                      error: (e, s) => _buildErrorState('Error: $e'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 로딩 오버레이
        if (isLoading)
          Container(
            color: AppColors.background.withValues(alpha: 0.7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '구매 처리 중...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildAppBar(BuildContext context, AsyncValue<UserProgress> userProgressAsync) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 뒤로가기 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          
          // 타이틀
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppGradients.goldenButton,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.goldenGlowSm,
                  ),
                  child: const Icon(Icons.shopping_bag, color: AppColors.background, size: 20),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.shop_title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // 인벤토리 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.inventory_2_outlined, color: AppColors.iconPrimary),
              onPressed: () => context.push(AppRouter.inventory),
            ),
          ),
          const SizedBox(width: 8),
          
          // 코인 표시
          userProgressAsync.when(
            data: (progress) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.monetization_on, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${progress.coins}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        dividerColor: AppColors.transparent,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.shop_tab_all),
          ..._tabs.map((type) => Tab(text: _getTabLabel(context, type))),
        ],
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
  
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<ShopItem> items, UserProgress userProgress) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.shop_empty_list,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final crossAxisCount = responsive.gridColumns(phoneColumns: 2, tabletColumns: 3, desktopColumns: 4);
        final padding = responsive.padding(16);
        final spacing = responsive.spacing(16);
        
        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.isSmallPhone ? 0.7 : 0.75,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isOwned = userProgress.inventoryIds.contains(item.id) && item.type != ShopItemType.consumable;
            
            return ShopItemCard(
              item: item, 
              isOwned: isOwned,
              onTap: isOwned ? null : () => _handlePurchase(item, userProgress),
            );
          },
        );
      },
    );
  }
}
