import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class PurchaseOrderFormView extends GetView<PurchaseOrderFormController> {
  const PurchaseOrderFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEdit.value
              ? 'Edit Purchase Order'
              : 'Create Purchase Order',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .all(AppDimensions.md),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                CustomTextField(
                  title: 'Order Number',
                  hint: 'Auto-generated order number',
                  isRequired: true,
                  controller: controller.orderNumberController,
                  prefixIcon: Assets.receipt,
                  readOnly: true,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Order number'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a supplier';
                      }
                      return null;
                    },
                  ),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Order Date',
                  hint: 'Select order date',
                  isRequired: true,
                  controller: TextEditingController(
                    text: Formatters.formatDate(controller.selectedDate.value),
                  ),
                  prefixIcon: Assets.calendar,
                  readOnly: true,
                  textInputAction: .done,
                  onTap: () => _selectDate(context),
                ),
                Gaps.verticalGapOf(AppDimensions.lg),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'Order Items',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showAddItemDialog(context),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Item'),
                    ),
                  ],
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                Obx(() {
                  if (controller.orderItems.isEmpty) {
                    return Card.filled(
                      child: Padding(
                        padding: .all(AppDimensions.lg),
                        child: Column(
                          children: [
                            SvgHelper.fromSource(
                              path: Assets.inventoryOutlined,
                              height: 48,
                              width: 48,
                              color: context.outlineColor,
                            ),
                            Gaps.verticalGapOf(AppDimensions.sm),
                            Text(
                              'No items added yet',
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
                      ...List.generate(controller.orderItems.length, (index) {
                        final orderItem = controller.orderItems[index];
                        return Card.filled(
                          margin: .only(bottom: AppDimensions.sm),
                          child: Padding(
                            padding: .all(AppDimensions.md),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        orderItem.item.name,
                                        style: context.textTheme.titleSmall
                                            ?.copyWith(fontWeight: .bold),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeItem(index),
                                      icon: const Icon(Icons.close),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                                Gaps.verticalGapOf(AppDimensions.sm),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: orderItem.quantity.value
                                            .toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Quantity',
                                          isDense: true,
                                        ),
                                        keyboardType: .number,
                                        onChanged: (value) {
                                          final qty = int.tryParse(value);
                                          if (qty != null) {
                                            controller.updateItemQuantity(
                                              index,
                                              qty,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Gaps.horizontalGapOf(AppDimensions.md),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: orderItem.unitPrice.value
                                            .toStringAsFixed(2),
                                        decoration: const InputDecoration(
                                          labelText: 'Unit Price',
                                          isDense: true,
                                        ),
                                        keyboardType: .number,
                                        onChanged: (value) {
                                          final price = double.tryParse(value);
                                          if (price != null) {
                                            controller.updateItemUnitPrice(
                                              index,
                                              price,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.verticalGapOf(AppDimensions.sm),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: context.textTheme.bodySmall,
                                      ),
                                      Text(
                                        Formatters.formatCurrency(
                                          orderItem.totalPrice,
                                        ),
                                        style: context.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: .bold,
                                              color: context.primaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Gaps.verticalGapOf(AppDimensions.md),
                      Card.filled(
                        color: context.primaryContainer,
                        child: Padding(
                          padding: .all(AppDimensions.md),
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Grand Total',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(fontWeight: .bold),
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
                        ),
                      ),
                    ],
                  );
                }),
                Gaps.verticalGapOf(100), // Space for bottom bar
              ],
            ),
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
              label: controller.status.value == .loading
                  ? controller.isEdit.value
                        ? 'Updating...'
                        : 'Creating...'
                  : controller.isEdit.value
                  ? 'Update Purchase Order'
                  : 'Create Purchase Order',
              isLoading: controller.status.value == .loading,
              customIcon: controller.status.value == .loading
                  ? null
                  : SvgHelper.fromSource(
                      path: Assets.tick,
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
              onTap: controller.status.value == .loading
                  ? null
                  : controller.submitForm,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.onDateSelected(picked);
    }
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final selectedItem = await ItemSelectionSheet.show(
      context,
      controller.items,
    );

    if (selectedItem != null) {
      controller.addItem(selectedItem);
    }
  }
}
