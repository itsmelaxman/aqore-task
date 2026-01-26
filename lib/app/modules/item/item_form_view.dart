import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ItemFormView extends GetView<ItemFormController> {
  const ItemFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: controller.isEdit.value ? 'Edit Item' : 'Add Item',
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
                  title: 'Item Name',
                  hint: 'Enter item name',
                  isRequired: true,
                  controller: controller.nameController,
                  prefixIcon: Assets.archive,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Item name'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Description',
                  hint: 'Enter item description',
                  isRequired: true,
                  controller: controller.descriptionController,
                  maxLines: 3,
                  prefixIcon: Assets.desc,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Description'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'SKU',
                  hint: 'Enter or generate SKU',
                  isRequired: true,
                  controller: controller.skuController,
                  prefixIcon: Assets.scan,
                  suffixIcon: Icons.autorenew_outlined,
                  onSuffixTap: controller.generateSku,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'SKU'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Price (Rs.)',
                  hint: 'Enter price',
                  isRequired: true,
                  controller: controller.priceController,
                  keyboardType: .number,
                  prefixIcon: Icons.toll_outlined,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.positiveNumber(value, fieldName: 'Price'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Stock Quantity',
                  hint: 'Enter stock quantity',
                  isRequired: true,
                  controller: controller.stockQuantityController,
                  keyboardType: .number,
                  prefixIcon: Assets.hashtag,
                  textInputAction: .done,
                  validator: (value) =>
                      Validators.number(value, fieldName: 'Stock quantity'),
                ),
                Gaps.verticalGapOf(100),
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
          child: Obx(() {
            return CustomMaterialButton(
              label: controller.status.value == DataFetchStatus.loading
                  ? controller.isEdit.value
                        ? 'Updating...'
                        : 'Creating...'
                  : controller.isEdit.value
                  ? 'Update Item'
                  : 'Create Item',
              isLoading: controller.status.value == DataFetchStatus.loading,
              customIcon: controller.status.value == DataFetchStatus.loading
                  ? null
                  : SvgHelper.fromSource(
                      path: Assets.tick,
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
              onTap: controller.status.value == DataFetchStatus.loading
                  ? null
                  : controller.submitForm,
            );
          }),
        ),
      ),
    );
  }
}
