import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class SupplierFormView extends GetView<SupplierFormController> {
  const SupplierFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: controller.isEdit.value ? 'Edit Supplier' : 'Add Supplier',
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
                  title: 'Supplier Name',
                  hint: 'Enter supplier name',
                  isRequired: true,
                  controller: controller.nameController,
                  prefixIcon: Assets.businessOutlined,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Supplier name'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Contact Person',
                  hint: 'Enter contact person name',
                  isRequired: true,
                  controller: controller.contactPersonController,
                  prefixIcon: Assets.user,
                  textInputAction: .next,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Contact person'),
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Email',
                  hint: 'Enter email address',
                  isRequired: false,
                  controller: controller.emailController,
                  keyboardType: .emailAddress,
                  prefixIcon: Assets.email,
                  textInputAction: .next,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      return Validators.email(value);
                    }
                    return null;
                  },
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Phone',
                  hint: 'Enter phone number',
                  isRequired: true,
                  controller: controller.phoneController,
                  keyboardType: .phone,
                  prefixIcon: Assets.call,
                  textInputAction: .next,
                  validator: Validators.phone,
                ),
                Gaps.verticalGapOf(AppDimensions.md),
                CustomTextField(
                  title: 'Address',
                  hint: 'Enter supplier address',
                  isRequired: true,
                  controller: controller.addressController,
                  prefixIcon: Assets.location,
                  textInputAction: .done,
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Address'),
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
              label: controller.status.value == .loading
                  ? controller.isEdit.value
                        ? 'Updating...'
                        : 'Creating...'
                  : controller.isEdit.value
                  ? 'Update Supplier'
                  : 'Create Supplier',
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
            );
          }),
        ),
      ),
    );
  }
}
