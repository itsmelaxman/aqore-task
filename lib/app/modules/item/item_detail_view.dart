import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ItemDetailView extends GetView<ItemController> {
  const ItemDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Item initialItem = Get.arguments as Item;
    controller.watchItemById(initialItem.id);

    return Obx(() {
      final item = controller.currentItem.value;
      if (item == null) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Item Details'),
          body: LoadingIndicator(),
        );
      }

      return _buildContent(context, item);
    });
  }

  Widget _buildContent(BuildContext context, Item item) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Item Details',
        actions: [
          IconButton(
            icon: SvgHelper.fromSource(
              path: Assets.edit,
              height: 24,
              width: 24,
            ),
            onPressed: () async {
              final result = await Get.toNamed(
                Routes.itemForm,
                arguments: item,
              );
              if (result == true) {
                Get.back(result: true);
              }
            },
          ),
        ],
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
                      path: Assets.inventoryOutlined,
                      height: 48,
                      width: 48,
                      color: context.primaryColor,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  Text(
                    item.name,
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
                      color: context.secondaryContainer,
                      borderRadius: .circular(20),
                    ),
                    child: Text(
                      'SKU: ${item.sku}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.onSecondaryContainer,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Pricing & Stock Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Pricing & Inventory',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.hashtag,
                    label: 'Price',
                    value: Formatters.formatCurrency(item.price),
                    valueColor: context.primaryColor,
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.inventoryOutlined,
                    label: 'Stock Quantity',
                    value: '${item.stockQuantity} units',
                    valueColor: item.stockQuantity > 10
                        ? Colors.green
                        : Colors.orange,
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Description Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      SvgHelper.fromSource(
                        path: Assets.desc,
                        height: 20,
                        width: 20,
                        color: context.outlineColor,
                      ),
                      Gaps.horizontalGapOf(AppDimensions.sm),
                      Text(
                        'Description',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  Text(
                    item.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.onSurfaceColor,
                      height: 1.5,
                    ),
                  ),
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
                    value: Formatters.formatDate(item.createdAt),
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.clock,
                    label: 'Last Updated',
                    value: Formatters.formatDate(item.updatedAt),
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
        Gaps.horizontalGapOf(AppDimensions.sm),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.outlineColor,
            ),
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: .w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
