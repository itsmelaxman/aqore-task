import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class PurchaseOrderDetailView extends GetView<PurchaseOrderController> {
  const PurchaseOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    if (arguments is PurchaseOrderWithDetails) {
      controller.watchOrderById(arguments.order.id);

      return Obx(() {
        final orderDetail = controller.currentOrderDetail.value;
        if (orderDetail == null) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Purchase Order Details'),
            body: LoadingIndicator(),
          );
        }

        return _buildDetailView(
          context,
          orderDetail.order,
          orderDetail.supplier,
          orderDetail.items,
          orderDetail,
        );
      });
    }

    if (arguments is PurchaseOrder) {
      return _buildLoadingOrError(
        context,
        'Invalid navigation state. Please go back and try again.',
      );
    }

    // No valid arguments
    return _buildLoadingOrError(context, 'No order data provided');
  }

  Widget _buildLoadingOrError(BuildContext context, String message) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Purchase Order Details'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView(
    BuildContext context,
    PurchaseOrder order,
    Supplier supplier,
    List<PurchaseOrderItem> items,
    PurchaseOrderWithDetails orderDetail,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Purchase Order Details',
        actions: order.status == 'pending'
            ? [
                IconButton(
                  icon: SvgHelper.fromSource(
                    path: Assets.edit,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    Get.toNamed(
                      Routes.purchaseOrderForm,
                      arguments: orderDetail,
                    );
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            //* ------------------- Header Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                children: [
                  Container(
                    padding: .all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: context.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: SvgHelper.fromSource(
                      path: Assets.order,
                      height: 48,
                      width: 48,
                      color: context.primaryColor,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  Text(
                    order.orderNumber,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: .bold,
                    ),
                    textAlign: .center,
                  ),
                  Gaps.verticalGapOf(AppDimensions.xs),
                  Container(
                    padding: .symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: order.status == 'pending'
                          ? context.tertiaryContainer
                          : context.primaryContainer,
                      borderRadius: .circular(20),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: order.status == 'pending'
                            ? context.onTertiaryContainer
                            : context.onPrimaryContainer,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Order Information Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Order Information',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.supplierOutlined,
                    label: 'Supplier',
                    value: supplier.name,
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.calendar,
                    label: 'Order Date',
                    value: Formatters.formatDate(order.orderDate),
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.hashtag,
                    label: 'Total Amount',
                    value: Formatters.formatCurrency(order.totalAmount),
                    valueColor: context.primaryColor,
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Items Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                        color: context.primaryColor,
                      ),
                      Gaps.horizontalGapOf(AppDimensions.sm),
                      Text(
                        'Order Items (${items.length})',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  ...items.map((orderItem) {
                    return FutureBuilder<Item?>(
                      future: _getItemById(orderItem.itemId),
                      builder: (context, snapshot) {
                        final item = snapshot.data;
                        final itemName =
                            item?.name ?? 'Item #${orderItem.itemId}';

                        return Padding(
                          padding: .only(bottom: AppDimensions.md),
                          child: Container(
                            padding: .all(AppDimensions.md),
                            decoration: BoxDecoration(
                              color: context.surfaceColorHighest,
                              borderRadius: .circular(AppDimensions.md),
                            ),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  itemName,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: .bold,
                                  ),
                                ),
                                Gaps.verticalGapOf(AppDimensions.sm),
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Qty: ${orderItem.quantity}',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'Unit: ${Formatters.formatCurrency(orderItem.unitPrice)}',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      Formatters.formatCurrency(
                                        orderItem.totalPrice,
                                      ),
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: .bold,
                                            color: context.primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Timestamps Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Record Information',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.calendar,
                    label: 'Created',
                    value: Formatters.formatDate(order.createdAt),
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.clock,
                    label: 'Last Updated',
                    value: Formatters.formatDate(order.updatedAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String iconPath,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        SvgHelper.fromSource(
          path: iconPath,
          height: 20,
          width: 20,
          color: context.outlineColor,
        ),
        Gaps.horizontalGapOf(AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.outlineColor,
                ),
              ),
              Gaps.verticalGapOf(2),
              Text(
                value,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: .w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Item?> _getItemById(int itemId) async {
    final db = Get.find<DatabaseService>().database;
    return await (db.select(
      db.items,
    )..where((tbl) => tbl.id.equals(itemId))).getSingleOrNull();
  }
}
