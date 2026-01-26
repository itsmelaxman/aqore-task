import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class SupplierDetailView extends GetView<SupplierController> {
  const SupplierDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Supplier initialSupplier = Get.arguments as Supplier;
    controller.watchSupplierById(initialSupplier.id);

    return Obx(() {
      final supplier = controller.currentSupplier.value;
      if (supplier == null) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Supplier Details'),
          body: LoadingIndicator(),
        );
      }

      return _buildContent(context, supplier);
    });
  }

  Widget _buildContent(BuildContext context, Supplier supplier) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Supplier Details',
        actions: [
          IconButton(
            icon: SvgHelper.fromSource(
              path: Assets.edit,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Get.toNamed(Routes.supplierForm, arguments: supplier);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            //* -------------------  Header Section ------------------- //
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
                      path: Assets.businessOutlined,
                      height: 48,
                      width: 48,
                      color: context.primaryColor,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  Text(
                    supplier.name,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: .bold,
                    ),
                    textAlign: .center,
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Contact Information Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Contact Information',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.user,
                    label: 'Contact Person',
                    value: supplier.contactPerson,
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.call,
                    label: 'Phone',
                    value: supplier.phone,
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.email,
                    label: 'Email',
                    value: supplier.email ?? 'N/A',
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.location,
                    label: 'Address',
                    value: supplier.address,
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
                    value: Formatters.formatDate(supplier.createdAt),
                  ),
                  const Divider(height: AppDimensions.lg),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.clock,
                    label: 'Last Updated',
                    value: Formatters.formatDate(supplier.updatedAt),
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
  }) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        SvgHelper.fromSource(
          path: iconPath,
          height: 20,
          width: 20,
          color: context.outlineColor,
        ),
        Gaps.horizontalGapOf(AppDimensions.sm),
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
              Gaps.verticalGapOf(4),
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
