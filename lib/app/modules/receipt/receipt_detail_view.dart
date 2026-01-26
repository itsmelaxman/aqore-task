import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class ReceiptDetailView extends GetView<ReceiptController> {
  const ReceiptDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final receiptDetail = Get.arguments;
    final receipt = receiptDetail.receipt;
    final supplier = receiptDetail.supplier;
    final poIds = receipt.purchaseOrderIds.split(',');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Receipt Details'),
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
                      path: Assets.receipt,
                      height: 48,
                      width: 48,
                      color: context.primaryColor,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  Text(
                    receipt.receiptNumber,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: .bold,
                    ),
                    textAlign: .center,
                  ),
                  Gaps.verticalGapOf(AppDimensions.xs),
                  Text(
                    supplier.name,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.onSurfaceColor,
                    ),
                    textAlign: .center,
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* ------------------- Receipt Information Section ------------------- //
            Container(
              width: .infinity,
              color: Colors.white,
              padding: .all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Receipt Information',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.calendar,
                    label: 'Receipt Date',
                    value: Formatters.formatDate(receipt.receiptDate),
                  ),
                  const Divider(height: AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.hashtag,
                    label: 'Total Amount',
                    value: Formatters.formatCurrency(receipt.totalAmount),
                    valueColor: context.primaryColor,
                  ),
                  const Divider(height: AppDimensions.md),
                  _buildDetailRow(
                    context,
                    iconPath: Assets.order,
                    label: 'Purchase Orders',
                    value: '${poIds.length} order(s)',
                  ),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* -------------------  Purchase Order IDs Section ------------------- //
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
                        Icons.list_alt,
                        size: 20,
                        color: context.primaryColor,
                      ),
                      Gaps.horizontalGapOf(AppDimensions.sm),
                      Text(
                        'Related Purchase Orders',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                  Gaps.verticalGapOf(AppDimensions.md),
                  ...poIds.asMap().entries.map((entry) {
                    final index = entry.key;
                    final poId = entry.value;
                    return Padding(
                      padding: .only(bottom: AppDimensions.sm),
                      child: Container(
                        padding: .all(AppDimensions.md),
                        decoration: BoxDecoration(
                          color: context.surfaceColorHighest,
                          borderRadius: .circular(AppDimensions.md),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: context.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: .bold,
                                    color: context.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            Gaps.horizontalGapOf(AppDimensions.md),
                            Expanded(
                              child: Text(
                                'PO #$poId',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: .w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Gaps.verticalGapOf(1),

            //* -------------------  Timestamps Section ------------------- //
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
                    value: Formatters.formatDate(receipt.createdAt),
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
}
