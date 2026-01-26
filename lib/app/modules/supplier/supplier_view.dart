import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class SupplierView extends GetView<SupplierController> {
  const SupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(title: 'Suppliers'),
      body: Obx(
        () => StatusHandler(
          status: controller.status.value,
          hasData: controller.suppliers.isNotEmpty,
          emptyTitle: 'No suppliers yet',
          emptyMessage: 'Add your first supplier to get started.',
          emptyIllustration: Assets.supplierIllustration,
          actionLabel: 'Add Supplier',
          onAction: () => Get.toNamed(Routes.supplierForm),
          enablePullToRefresh: true,
          onRefresh: () {
            // Stream auto-refreshes
          },
          successBuilder: () => ListView.builder(
            padding: .all(AppDimensions.md),
            itemCount: controller.suppliers.length,
            itemBuilder: (context, index) {
              final supplier = controller.suppliers[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(12),
                  side: .none,
                ),
                margin: .only(bottom: AppDimensions.md),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.supplierDetail, arguments: supplier);
                  },
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
                            path: Assets.businessOutlined,
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
                                supplier.name,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: .w600,
                                ),
                              ),
                              Gaps.verticalGapOf(4),
                              Row(
                                children: [
                                  SvgHelper.fromSource(
                                    path: Assets.call,
                                    height: 14,
                                    width: 14,
                                    color: context.outlineColor,
                                  ),
                                  Gaps.horizontalGapOf(4),
                                  Text(
                                    supplier.phone,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: context.outlineColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final result = await Get.toNamed(
                                Routes.supplierForm,
                                arguments: supplier,
                              );
                              if (result == true) {
                                // List auto-refreshes via stream
                              }
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, supplier.id);
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
        heroTag: 'supplier_fab',
        onPressed: () {
          Get.toNamed(Routes.supplierForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) async {
    final confirmed = await AppDialogs.showConfirmation(
      title: 'Delete Supplier',
      message:
          'Are you sure you want to delete this supplier? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
    );

    if (confirmed) {
      controller.deleteSupplier(id);
    }
  }
}
