import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ItemView extends GetView<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(title: 'Items'),
      body: Obx(
        () => StatusHandler(
          status: controller.status.value,
          hasData: controller.items.isNotEmpty,
          emptyTitle: 'No items yet',
          emptyMessage: 'Add your first item to get started.',
          emptyIllustration: Assets.inventoryIllustration,
          actionLabel: 'Add Item',
          onAction: () => Get.toNamed(Routes.itemForm),
          enablePullToRefresh: true,
          onRefresh: () {},
          successBuilder: () => ListView.builder(
            padding: .all(AppDimensions.md),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(12),
                  side: .none,
                ),
                margin: .only(bottom: AppDimensions.md),
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.itemDetail, arguments: item),
                  borderRadius: .circular(12),
                  child: Padding(
                    padding: .all(AppDimensions.md),
                    child: Row(
                      children: [
                        Container(
                          padding: .all(AppDimensions.md),
                          decoration: BoxDecoration(
                            color: context.primaryContainer,
                            borderRadius: .circular(AppDimensions.md),
                          ),
                          child: SvgHelper.fromSource(
                            path: Assets.inventoryOutlined,
                            height: 24,
                            width: 24,
                            color: context.primaryColor,
                          ),
                        ),
                        Gaps.horizontalGapOf(AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                item.name,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: .w600,
                                ),
                              ),
                              Gaps.verticalGapOf(4),
                              Text(
                                Formatters.formatCurrency(item.price),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.primaryColor,
                                  fontWeight: .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: .symmetric(
                            horizontal: AppDimensions.sm,
                            vertical: AppDimensions.xs,
                          ),
                          decoration: BoxDecoration(
                            color: item.stockQuantity > 10
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: .circular(20),
                          ),
                          child: Text(
                            '${item.stockQuantity}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: item.stockQuantity > 10
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                        Gaps.horizontalGapOf(AppDimensions.sm),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  SvgHelper.fromSource(
                                    path: Assets.edit,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Gaps.horizontalGapOf(AppDimensions.sm),
                                  const Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  SvgHelper.fromSource(
                                    path: Assets.delete,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Gaps.horizontalGapOf(AppDimensions.sm),
                                  const Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.toNamed(Routes.itemForm, arguments: item);
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, item.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'item_fab',
        onPressed: () => Get.toNamed(Routes.itemForm),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) async {
    final confirmed = await AppDialogs.showConfirmation(
      title: 'Delete Item',
      message:
          'Are you sure you want to delete this item? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
    );

    if (confirmed) {
      controller.deleteItem(id);
    }
  }
}
