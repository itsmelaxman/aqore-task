import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ReceiptGenerateView extends GetView<ReceiptFormController> {
  const ReceiptGenerateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Receipt')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Obx(
                () => DropdownButtonFormField<Supplier>(
                  decoration: InputDecoration(
                    labelText: 'Select Supplier',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: .circular(AppDimensions.md),
                    ),
                  ),
                  initialValue: controller.selectedSupplier.value,
                  items: controller.suppliers
                      .map(
                        (supplier) => DropdownMenuItem(
                          value: supplier,
                          child: Text(supplier.name),
                        ),
                      )
                      .toList(),
                  onChanged: controller.onSupplierSelected,
                ),
              ),
              Gaps.verticalGapOf(AppDimensions.lg),
              Text(
                'Select Purchase Orders',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: .bold,
                ),
              ),
              Gaps.verticalGapOf(AppDimensions.md),
              Obx(() {
                if (controller.selectedSupplier.value == null) {
                  return Card.filled(
                    child: Padding(
                      padding: .all(AppDimensions.lg),
                      child: Column(
                        children: [
                          SvgHelper.fromSource(
                            path: Assets.cancel,
                            height: 48,
                            width: 48,
                            color: context.outlineColor,
                          ),
                          Gaps.verticalGapOf(AppDimensions.sm),
                          Text(
                            'Please select a supplier first',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.outlineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.isLoading) {
                  return const LoadingIndicator();
                }

                if (controller.availableOrders.isEmpty) {
                  return Card.filled(
                    child: Padding(
                      padding: .all(AppDimensions.lg),
                      child: Column(
                        children: [
                          SvgHelper.fromSource(
                            path: Assets.cancel,
                            height: 48,
                            width: 48,
                            color: context.outlineColor,
                          ),
                          Gaps.verticalGapOf(AppDimensions.sm),
                          Text(
                            'No pending orders for this supplier',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.outlineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ...controller.availableOrders.map((order) {
                      return Obx(
                        () => Card.filled(
                          margin: .only(bottom: AppDimensions.sm),
                          child: CheckboxListTile(
                            value: controller.selectedOrderIds.contains(
                              order.id,
                            ),
                            onChanged: (checked) {
                              controller.toggleOrderSelection(order.id);
                            },
                            title: Text(
                              order.orderNumber,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Gaps.verticalGapOf(AppDimensions.xs),
                                Text(Formatters.formatDate(order.orderDate)),
                                Text(
                                  Formatters.formatCurrency(order.totalAmount),
                                  style: TextStyle(
                                    color: context.primaryColor,
                                    fontWeight: .bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    Gaps.verticalGapOf(AppDimensions.md),
                    Obx(() {
                      if (controller.selectedOrderIds.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Card.filled(
                        color: context.primaryContainer,
                        child: Padding(
                          padding: .all(AppDimensions.md),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(fontWeight: .bold),
                                  ),
                                  Text(
                                    '${controller.selectedOrderIds.length} orders selected',
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Text(
                                Formatters.formatCurrency(
                                  controller.totalAmount,
                                ),
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: .bold,
                                  color: context.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
              Gaps.verticalGapOf(100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: context.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        padding: .all(AppDimensions.md),
        child: SafeArea(
          child: Obx(
            () => CustomMaterialButton(
              label: controller.isLoading
                  ? 'Generating...'
                  : 'Generate Receipt',
              isLoading: controller.isLoading,
              customIcon: controller.isLoading
                  ? null
                  : SvgHelper.fromSource(
                      path: Assets.tick,
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
              onTap: controller.isLoading ? null : controller.generateReceipt,
            ),
          ),
        ),
      ),
    );
  }
}
