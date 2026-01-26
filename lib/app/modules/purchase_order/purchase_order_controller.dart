import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class PurchaseOrderWithDetails {
  final PurchaseOrder order;
  final Supplier supplier;
  final List<PurchaseOrderItem> items;

  PurchaseOrderWithDetails({
    required this.order,
    required this.supplier,
    required this.items,
  });
}

class OrderItem {
  final Item item;
  final RxInt quantity;
  final RxDouble unitPrice;

  OrderItem({required this.item, int quantity = 1})
    : quantity = quantity.obs,
      unitPrice = item.price.obs;

  double get totalPrice => quantity.value * unitPrice.value;
}

class PurchaseOrderController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final orders = <PurchaseOrderWithDetails>[].obs;
  final status = DataFetchStatus.initial.obs;
  final currentOrderDetail = Rxn<PurchaseOrderWithDetails>();
  int? _watchingOrderId;

  //* ----------------------- Initialize Controller ----------------------- //
  @override
  void onInit() {
    super.onInit();
    _watchOrders();
  }

  //* ----------------------- Watch Order By ID ----------------------- //
  void watchOrderById(int id) {
    // Prevent duplicate on rebuild
    if (_watchingOrderId == id) return;
    _watchingOrderId = id;

    _db.select(_db.purchaseOrders).watch().listen((allOrders) async {
      final order = allOrders.firstWhereOrNull((o) => o.id == id);
      if (order == null) {
        currentOrderDetail.value = null;
        return;
      }

      try {
        final supplier = await (_db.select(
          _db.suppliers,
        )..where((tbl) => tbl.id.equals(order.supplierId))).getSingleOrNull();

        if (supplier == null) {
          currentOrderDetail.value = null;
          return;
        }

        final items = await (_db.select(
          _db.purchaseOrderItems,
        )..where((tbl) => tbl.purchaseOrderId.equals(order.id))).get();

        currentOrderDetail.value = PurchaseOrderWithDetails(
          order: order,
          supplier: supplier,
          items: items,
        );
      } catch (e) {
        currentOrderDetail.value = null;
      }
    });
  }

  //* ----------------------- Watch All Orders ----------------------- //
  void _watchOrders() {
    status.value = DataFetchStatus.loading;

    _db.select(_db.purchaseOrders).watch().listen((purchaseOrders) async {
      if (purchaseOrders.isEmpty) {
        orders.value = [];
        status.value = DataFetchStatus.empty;
        return;
      }

      status.value = DataFetchStatus.loading;
      final List<PurchaseOrderWithDetails> result = [];

      for (final order in purchaseOrders) {
        try {
          final supplier = await (_db.select(
            _db.suppliers,
          )..where((tbl) => tbl.id.equals(order.supplierId))).getSingleOrNull();

          if (supplier == null) {
            continue;
          }

          final items = await (_db.select(
            _db.purchaseOrderItems,
          )..where((tbl) => tbl.purchaseOrderId.equals(order.id))).get();
          result.add(
            PurchaseOrderWithDetails(
              order: order,
              supplier: supplier,
              items: items,
            ),
          );
        } catch (e) {
          //
        }
      }

      orders.value = result;
      status.value = DataFetchStatus.success;
    });
  }

  //* ----------------------- Get Pending Orders ----------------------- //
  Future<List<PurchaseOrder>> getPendingOrdersBySupplier(int supplierId) async {
    return await (_db.select(_db.purchaseOrders)
          ..where((tbl) => tbl.supplierId.equals(supplierId))
          ..where((tbl) => tbl.status.equals('pending')))
        .get();
  }

  //* ----------------------- Delete Purchase Order ----------------------- //
  Future<void> deletePurchaseOrder(int id) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(
          _db.purchaseOrderItems,
        )..where((tbl) => tbl.purchaseOrderId.equals(id))).go();
        await (_db.delete(
          _db.purchaseOrders,
        )..where((tbl) => tbl.id.equals(id))).go();
      });
      CustomToast.success('Purchase order has been deleted');
    } catch (e) {
      CustomToast.error(
        'Couldn’t delete the purchase order. Please try again.',
      );
    }
  }
}
