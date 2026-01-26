import 'package:get/get.dart';
import '../../data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

class DatabaseService extends GetxService {
  late final AppDatabase _db;

  AppDatabase get database => _db;

  @override
  void onInit() {
    super.onInit();
    _db = AppDatabase();
  }

  @override
  void onClose() {
    _db.close();
    super.onClose();
  }

  //* ------------------- [Receipt] Generation ------------------- //
  Future<Receipt> generateReceiptFromOrders({
    required int supplierId,
    required List<int> purchaseOrderIds,
    required String receiptNumber,
  }) async {
    return await _db.transaction(() async {
      double totalAmount = 0;
      final allItems = <PurchaseOrderItem>[];

      for (final poId in purchaseOrderIds) {
        final po = await (_db.select(
          _db.purchaseOrders,
        )..where((tbl) => tbl.id.equals(poId))).getSingle();
        totalAmount += po.totalAmount;

        final items = await (_db.select(
          _db.purchaseOrderItems,
        )..where((tbl) => tbl.purchaseOrderId.equals(poId))).get();
        allItems.addAll(items);
      }

      //* ------------------- [Create] receipt ------------------- //
      final receiptId = await _db
          .into(_db.receipts)
          .insert(
            ReceiptsCompanion.insert(
              supplierId: supplierId,
              receiptNumber: receiptNumber,
              receiptDate: DateTime.now(),
              totalAmount: totalAmount,
              purchaseOrderIds: purchaseOrderIds.join(','),
            ),
          );

      //* ------------------- [Update] purchase orders to processed ------------------- //
      for (final poId in purchaseOrderIds) {
        await (_db.update(
          _db.purchaseOrders,
        )..where((tbl) => tbl.id.equals(poId))).write(
          PurchaseOrdersCompanion(
            status: const drift.Value('processed'),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      }

      //* ------------------- [Update] inventory for each item ------------------- //
      for (final poItem in allItems) {
        final item = await (_db.select(
          _db.items,
        )..where((tbl) => tbl.id.equals(poItem.itemId))).getSingle();

        await (_db.update(
          _db.items,
        )..where((tbl) => tbl.id.equals(poItem.itemId))).write(
          ItemsCompanion(
            stockQuantity: drift.Value(item.stockQuantity + poItem.quantity),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      }

      //* ------------------- [Return] the created receipt ------------------- //
      return await (_db.select(
        _db.receipts,
      )..where((tbl) => tbl.id.equals(receiptId))).getSingle();
    });
  }

  //* ------------------- [Clear] all data from database ------------------- //
  Future<void> nukeAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.receipts).go();
      await _db.delete(_db.purchaseOrderItems).go();
      await _db.delete(_db.purchaseOrders).go();
      await _db.delete(_db.items).go();
      await _db.delete(_db.suppliers).go();
    });
  }
}
