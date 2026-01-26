import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ReceiptView extends GetView<ReceiptController> {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(
        () => StatusHandler(
          status: controller.status.value,
          hasData: controller.receipts.isNotEmpty,
          emptyTitle: 'No receipts yet',
          emptyMessage: 'Generate your first receipt from purchase orders.',
          emptyIllustration: Assets.receiptIllustration,
          actionLabel: 'Generate Receipt',
          onAction: () => Get.toNamed(Routes.receiptGenerate),
          successBuilder: () => ListView.builder(
            padding: .all(AppDimensions.md),
            itemCount: controller.receipts.length,
            itemBuilder: (context, index) {
              final receiptDetail = controller.receipts[index];
              final receipt = receiptDetail.receipt;
              final supplier = receiptDetail.supplier;
              final poIds = receipt.purchaseOrderIds.split(',');

              return Card.filled(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(12),
                  side: .none,
                ),
                margin: .only(bottom: AppDimensions.md),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.receiptDetail, arguments: receiptDetail);
                  },
                  borderRadius: .circular(AppDimensions.md),
                  child: Padding(
                    padding: .all(AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: .all(AppDimensions.sm),
                              decoration: BoxDecoration(
                                color: context.primaryContainer,
                                borderRadius: .circular(AppDimensions.sm),
                              ),
                              child: SvgHelper.fromSource(
                                path: Assets.receipt,
                                height: 24,
                                width: 24,
                                color: context.onPrimaryContainer,
                              ),
                            ),
                            Gaps.horizontalGapOf(AppDimensions.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    receipt.receiptNumber,
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
                              Formatters.formatDate(receipt.receiptDate),
                              style: context.textTheme.bodySmall,
                            ),
                            Gaps.horizontalGapOf(AppDimensions.md),
                            SvgHelper.fromSource(
                              path: Assets.order,
                              height: 16,
                              width: 16,
                              color: context.outlineColor,
                            ),
                            Gaps.horizontalGapOf(AppDimensions.xs),
                            Text(
                              '${poIds.length} orders',
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
                              Formatters.formatCurrency(receipt.totalAmount),
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: .bold,
                                color: context.primaryColor,
                              ),
                            ),
                          ],
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
        heroTag: 'receipt_fab',
        onPressed: () => Get.toNamed(Routes.receiptGenerate),
        child: const Icon(Icons.add),
      ),
    );
  }
}
