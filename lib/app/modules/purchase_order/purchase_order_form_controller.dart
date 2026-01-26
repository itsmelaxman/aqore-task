import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/utils/code_generator.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';
import 'purchase_order_controller.dart';

class PurchaseOrderFormController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final formKey = GlobalKey<FormState>();
  final orderNumberController = TextEditingController();

  final suppliers = <Supplier>[].obs;
  final items = <Item>[].obs;
  final selectedSupplier = Rxn<Supplier>();
  final selectedDate = DateTime.now().obs;
  final orderItems = <OrderItem>[].obs;

  final status = DataFetchStatus.initial.obs;
  final isEdit = false.obs;
  int? orderId;

  //* ----------------------- Initialize Controller ----------------------- //
  @override
  void onInit() {
    super.onInit();
    _watchSuppliers();
    _watchItems();
  }

  //* ----------------------- Controller Ready ----------------------- //
  @override
  void onReady() {
    super.onReady();
    _initializeForm();
  }

  //* ----------------------- Dispose Resources ----------------------- //
  @override
  void onClose() {
    orderNumberController.dispose();
    super.onClose();
  }

  //* ----------------------- Watch Suppliers ----------------------- //
  void _watchSuppliers() {
    _db.select(_db.suppliers).watch().listen((data) {
      suppliers.value = data;
    });
  }

  //* ----------------------- Watch Items ----------------------- //
  void _watchItems() {
    _db.select(_db.items).watch().listen((data) {
      items.value = data;
    });
  }

  //* ----------------------- Initialize Form Data ----------------------- //
  Future<void> _initializeForm() async {
    if (Get.arguments != null && Get.arguments is PurchaseOrderWithDetails) {
      final orderDetail = Get.arguments as PurchaseOrderWithDetails;

      // Prevent editing processed orders
      if (orderDetail.order.status == 'processed') {
        CustomToast.error('Cannot edit a processed purchase order');
        Get.back();
        return;
      }

      isEdit.value = true;
      orderId = orderDetail.order.id;
      orderNumberController.text = orderDetail.order.orderNumber;
      selectedDate.value = orderDetail.order.orderDate;
      selectedSupplier.value = orderDetail.supplier;

      final allItems = await _db.select(_db.items).get();

      orderItems.clear();
      for (final poItem in orderDetail.items) {
        final item = allItems.firstWhereOrNull((i) => i.id == poItem.itemId);
        if (item != null) {
          final orderItem = OrderItem(item: item, quantity: poItem.quantity);
          orderItem.unitPrice.value = poItem.unitPrice;
          orderItems.add(orderItem);
        }
      }
    } else {
      _generateOrderNumber();
    }
  }

  //* ----------------------- Generate Order Number ----------------------- //
  void _generateOrderNumber() {
    orderNumberController.text = CodeGenerator.generatePurchaseOrderNumber();
  }

  //* ----------------------- Handle Supplier Selection ----------------------- //
  void onSupplierSelected(Supplier? supplier) {
    selectedSupplier.value = supplier;
  }

  //* ----------------------- Handle Date Selection ----------------------- //
  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  //* ----------------------- Add Item to Order ----------------------- //
  void addItem(Item item) {
    // Check if item already exists
    final existingItem = orderItems.firstWhereOrNull(
      (orderItem) => orderItem.item.id == item.id,
    );

    if (existingItem != null) {
      existingItem.quantity.value++;
    } else {
      orderItems.add(OrderItem(item: item));
    }
  }

  //* ----------------------- Remove Item from Order ----------------------- //
  void removeItem(int index) {
    orderItems.removeAt(index);
  }

  //* ----------------------- Update Item Quantity ----------------------- //
  void updateItemQuantity(int index, int quantity) {
    if (quantity > 0) {
      orderItems[index].quantity.value = quantity;
    }
  }

  //* ----------------------- Update Item Unit Price ----------------------- //
  void updateItemUnitPrice(int index, double price) {
    if (price > 0) {
      orderItems[index].unitPrice.value = price;
    }
  }

  //* ----------------------- Calculate Total Amount ----------------------- //
  double get totalAmount {
    return orderItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  //* ----------------------- Submit Form ----------------------- //
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSupplier.value == null) {
      CustomToast.error('Please select a supplier');
      return;
    }

    if (orderItems.isEmpty) {
      CustomToast.error('Please add at least one item');
      return;
    }

    status.value = DataFetchStatus.loading;

    try {
      if (isEdit.value && orderId != null) {
        await _updatePurchaseOrder();
      } else {
        await _createPurchaseOrder();
      }
      status.value = DataFetchStatus.success;
      Get.back(result: true);
      CustomToast.success(
        isEdit.value
            ? 'Your changes have been saved!'
            : 'Purchase order created successfully',
      );
    } catch (e) {
      status.value = DataFetchStatus.error;
      CustomToast.error('Couldn’t save the purchase order. Please try again.');
    }
  }

  //* ----------------------- Create Purchase Order ----------------------- //
  Future<void> _createPurchaseOrder() async {
    await _db.transaction(() async {
      // Create purchase order
      final poId = await _db
          .into(_db.purchaseOrders)
          .insert(
            PurchaseOrdersCompanion.insert(
              supplierId: selectedSupplier.value!.id,
              orderNumber: orderNumberController.text.trim(),
              orderDate: selectedDate.value,
              totalAmount: totalAmount,
              status: 'pending',
            ),
          );

      // Create purchase order items
      for (final orderItem in orderItems) {
        await _db
            .into(_db.purchaseOrderItems)
            .insert(
              PurchaseOrderItemsCompanion.insert(
                purchaseOrderId: poId,
                itemId: orderItem.item.id,
                quantity: orderItem.quantity.value,
                unitPrice: orderItem.unitPrice.value,
                totalPrice: orderItem.totalPrice,
              ),
            );
      }
    });
  }

  //* ----------------------- Update Purchase Order ----------------------- //
  Future<void> _updatePurchaseOrder() async {
    await _db.transaction(() async {
      // Update the existing PO
      await (_db.update(
        _db.purchaseOrders,
      )..where((tbl) => tbl.id.equals(orderId!))).write(
        PurchaseOrdersCompanion(
          supplierId: drift.Value(selectedSupplier.value!.id),
          orderNumber: drift.Value(orderNumberController.text.trim()),
          orderDate: drift.Value(selectedDate.value),
          totalAmount: drift.Value(totalAmount),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      // Delete existing PO items
      await (_db.delete(
        _db.purchaseOrderItems,
      )..where((tbl) => tbl.purchaseOrderId.equals(orderId!))).go();

      // Insert updated items linked to the same purchase order ID
      for (final orderItem in orderItems) {
        await _db
            .into(_db.purchaseOrderItems)
            .insert(
              PurchaseOrderItemsCompanion.insert(
                purchaseOrderId: orderId!,
                itemId: orderItem.item.id,
                quantity: orderItem.quantity.value,
                unitPrice: orderItem.unitPrice.value,
                totalPrice: orderItem.totalPrice,
              ),
            );
      }
    });
  }
}
