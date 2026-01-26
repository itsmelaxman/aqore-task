import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class PurchaseOrderView extends GetView<PurchaseOrderController> {
  const PurchaseOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(
        () => StatusHandler(
          status: controller.status.value,
          hasData: controller.orders.isNotEmpty,
          emptyTitle: 'No purchase orders yet',
          emptyMessage: 'Create your first order to get started.',
          emptyIllustration: Assets.pOrderIllustration,
          actionLabel: 'Create Order',
          onAction: () => Get.toNamed(Routes.purchaseOrderForm),
          successBuilder: () => ListView.builder(
            padding: .all(AppDimensions.md),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final orderDetail = controller.orders[index];
              final order = orderDetail.order;
              final supplier = orderDetail.supplier;
              final items = orderDetail.items;

              return Card.filled(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(AppDimensions.md),
                  side: .none,
                ),
                margin: .only(bottom: AppDimensions.md),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      Routes.purchaseOrderDetail,
                      arguments: orderDetail,
                    );
                  },
                  borderRadius: .circular(AppDimensions.md),
                  child: Padding(
                    padding: .all(AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    order.orderNumber,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(fontWeight: .bold),
                                  ),
                                  Gaps.verticalGapOf(AppDimensions.xs),
                                  Text(
                                    supplier.name,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                order.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: .w600,
                                  color: order.status == 'pending'
                                      ? context.onTertiaryContainer
                                      : context.onPrimaryContainer,
                                ),
                              ),
                              backgroundColor: order.status == 'pending'
                                  ? context.tertiaryContainer
                                  : context.primaryContainer,
                              side: .none,
                              padding: .symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        const Divider(height: AppDimensions.lg),
                        Row(
                          children: [
                            SvgHelper.fromSource(
                              path: Assets.calendar,
                              height: 16,
                              width: 16,
                              color: context.outlineColor,
                            ),
                            Gaps.horizontalGapOf(AppDimensions.xs),
                            Text(
                              Formatters.formatDate(order.orderDate),
                              style: context.textTheme.bodySmall,
                            ),
                            Gaps.horizontalGapOf(AppDimensions.md),
                            SvgHelper.fromSource(
                              path: Assets.inventoryOutlined,
                              height: 16,
                              width: 16,
                              color: context.outlineColor,
                            ),
                            Gaps.horizontalGapOf(AppDimensions.xs),
                            Text(
                              '${items.length} items',
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Gaps.verticalGapOf(AppDimensions.sm),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.outlineColor,
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(order.totalAmount),
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: .bold,
                                color: context.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        if (order.status == 'pending') ...[
                          Gaps.verticalGapOf(AppDimensions.md),
                          FilledButton.icon(
                            onPressed: () =>
                                _showDeleteDialog(context, order.id),
                            icon: SvgHelper.fromSource(
                              path: Assets.delete,
                              height: 16,
                              width: 16,
                              color: context.onErrorContainer,
                            ),
                            label: const Text('Delete Order'),
                            style: FilledButton.styleFrom(
                              backgroundColor: context.errorColorContainer,
                              foregroundColor: context.onErrorContainer,
                            ),
                          ),
                        ],
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
        heroTag: 'purchase_order_fab',
        onPressed: () {
          Get.toNamed(Routes.purchaseOrderForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) async {
    final confirmed = await AppDialogs.showConfirmation(
      title: 'Delete Purchase Order',
      message:
          'Are you sure you want to delete this purchase order? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
    );

    if (confirmed) {
      controller.deletePurchaseOrder(id);
    }
  }
}
