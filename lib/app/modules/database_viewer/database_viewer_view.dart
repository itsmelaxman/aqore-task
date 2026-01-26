import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class DatabaseViewerView extends GetView<DatabaseViewerController> {
  const DatabaseViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Database Tables',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshCurrentTable,
            tooltip: 'Refresh current table',
          ),
        ],
      ),
      body: Column(
        children: [
          //* ------------------- Table selector ------------------- //
          Container(
            color: Colors.white,
            padding: .all(AppDimensions.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Suppliers', label: Text('Suppliers')),
                    ButtonSegment(value: 'Items', label: Text('Items')),
                    ButtonSegment(
                      value: 'Purchase Orders',
                      label: Text('Orders'),
                    ),
                    ButtonSegment(
                      value: 'Purchase Order Items',
                      label: Text('PO Items'),
                    ),
                    ButtonSegment(value: 'Receipts', label: Text('Receipts')),
                  ],
                  selected: {controller.selectedTable.value},
                  onSelectionChanged: (Set<String> selected) {
                    controller.changeTable(selected.first);
                  },
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          //* ------------------- Data display ------------------- //
          Expanded(
            child: Obx(
              () => StatusHandler(
                status: controller.status.value,
                hasData: _hasCurrentTableData(),
                emptyTitle: 'No data found',
                emptyMessage: 'This table is currently empty.',
                emptyIllustration: Assets.cancel,
                successBuilder: () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: .all(AppDimensions.md),
                      child: _buildTableContent(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasCurrentTableData() {
    return switch (controller.selectedTable.value) {
      'Suppliers' => controller.suppliers.isNotEmpty,
      'Items' => controller.items.isNotEmpty,
      'Purchase Orders' => controller.purchaseOrders.isNotEmpty,
      'Purchase Order Items' => controller.purchaseOrderItems.isNotEmpty,
      'Receipts' => controller.receipts.isNotEmpty,
      _ => false,
    };
  }

  Widget _buildTableContent(BuildContext context) {
    return switch (controller.selectedTable.value) {
      'Suppliers' => _buildSuppliersTable(context),
      'Items' => _buildItemsTable(context),
      'Purchase Orders' => _buildPurchaseOrdersTable(context),
      'Purchase Order Items' => _buildPurchaseOrderItemsTable(context),
      'Receipts' => _buildReceiptsTable(context),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildSuppliersTable(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(context.primaryContainer),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Contact Person')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Phone')),
        DataColumn(label: Text('Address')),
      ],
      rows: controller.suppliers.map((supplier) {
        return DataRow(
          cells: [
            DataCell(Text(supplier.id.toString())),
            DataCell(Text(supplier.name)),
            DataCell(Text(supplier.contactPerson)),
            DataCell(Text(supplier.email ?? "N/A")),
            DataCell(Text(supplier.phone)),
            DataCell(Text(supplier.address)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildItemsTable(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(context.primaryContainer),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('SKU')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Stock')),
      ],
      rows: controller.items.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(item.id.toString())),
            DataCell(Text(item.name)),
            DataCell(Text(item.description)),
            DataCell(Text(item.sku)),
            DataCell(Text('Rs. ${item.price.toStringAsFixed(2)}')),
            DataCell(Text(item.stockQuantity.toString())),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPurchaseOrdersTable(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(context.primaryContainer),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Order #')),
        DataColumn(label: Text('Supplier ID')),
        DataColumn(label: Text('Order Date')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('Status')),
      ],
      rows: controller.purchaseOrders.map((order) {
        return DataRow(
          cells: [
            DataCell(Text(order.id.toString())),
            DataCell(Text(order.orderNumber)),
            DataCell(Text(order.supplierId.toString())),
            DataCell(Text(Formatters.formatDate(order.orderDate))),
            DataCell(Text('Rs. ${order.totalAmount.toStringAsFixed(2)}')),
            DataCell(
              Container(
                padding: .symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == 'pending'
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: .circular(4),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: .bold,
                    color: order.status == 'pending'
                        ? Colors.orange.shade900
                        : Colors.green.shade900,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPurchaseOrderItemsTable(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(context.primaryContainer),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('PO ID')),
        DataColumn(label: Text('Item ID')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Unit Price')),
        DataColumn(label: Text('Total')),
      ],
      rows: controller.purchaseOrderItems.map((poItem) {
        return DataRow(
          cells: [
            DataCell(Text(poItem.id.toString())),
            DataCell(Text(poItem.purchaseOrderId.toString())),
            DataCell(Text(poItem.itemId.toString())),
            DataCell(Text(poItem.quantity.toString())),
            DataCell(Text('Rs. ${poItem.unitPrice.toStringAsFixed(2)}')),
            DataCell(
              Text(
                'Rs. ${(poItem.quantity * poItem.unitPrice).toStringAsFixed(2)}',
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReceiptsTable(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(context.primaryContainer),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Receipt #')),
        DataColumn(label: Text('Supplier ID')),
        DataColumn(label: Text('Receipt Date')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('PO IDs')),
      ],
      rows: controller.receipts.map((receipt) {
        return DataRow(
          cells: [
            DataCell(Text(receipt.id.toString())),
            DataCell(Text(receipt.receiptNumber)),
            DataCell(Text(receipt.supplierId.toString())),
            DataCell(Text(Formatters.formatDate(receipt.receiptDate))),
            DataCell(Text('Rs. ${receipt.totalAmount.toStringAsFixed(2)}')),
            DataCell(Text(receipt.purchaseOrderIds)),
          ],
        );
      }).toList(),
    );
  }
}
