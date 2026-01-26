import 'package:aqore_app/core/constants/app_enums.dart';
import 'package:get/get.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class DatabaseViewerController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();

  AppDatabase get _db => _dbService.database;

  final selectedTable = 'Suppliers'.obs;
  final currentIndex = 0.obs;
  final suppliers = <Supplier>[].obs;
  final items = <Item>[].obs;
  final purchaseOrders = <PurchaseOrder>[].obs;
  final purchaseOrderItems = <PurchaseOrderItem>[].obs;
  final receipts = <Receipt>[].obs;

  final status = DataFetchStatus.initial.obs;

  //* ------------------- Cache flags to track which tables have been fetched ------------------- //
  final _suppliersCached = false.obs;
  final _itemsCached = false.obs;
  final _purchaseOrdersCached = false.obs;
  final _purchaseOrderItemsCached = false.obs;
  final _receiptsCached = false.obs;

  final List<String> _tableNames = [
    'Suppliers',
    'Items',
    'Purchase Orders',
    'Purchase Order Items',
    'Receipts',
  ];

  @override
  void onInit() {
    super.onInit();
    loadTableData();
  }

  Future<void> loadTableData({bool forceRefresh = false}) async {
    //* ------------------- Check if data is already cached (unless force refresh) ------------------- //
    if (!forceRefresh && _isTableCached(selectedTable.value)) {
      status.value = DataFetchStatus.success;
      return;
    }

    status.value = DataFetchStatus.loading;
    try {
      await (switch (selectedTable.value) {
        'Suppliers' => _fetchSuppliers(),
        'Items' => _fetchItems(),
        'Purchase Orders' => _fetchPurchaseOrders(),
        'Purchase Order Items' => _fetchPurchaseOrderItems(),
        'Receipts' => _fetchReceipts(),
        _ => Future.value(null),
      });
      status.value = DataFetchStatus.success;
    } catch (e) {
      status.value = DataFetchStatus.error;
    }
  }

  bool _isTableCached(String table) {
    return switch (table) {
      'Suppliers' => _suppliersCached.value,
      'Items' => _itemsCached.value,
      'Purchase Orders' => _purchaseOrdersCached.value,
      'Purchase Order Items' => _purchaseOrderItemsCached.value,
      'Receipts' => _receiptsCached.value,
      _ => false,
    };
  }

  Future<void> _fetchSuppliers() async {
    suppliers.value = await _db.select(_db.suppliers).get();
    _suppliersCached.value = true;
  }

  Future<void> _fetchItems() async {
    items.value = await _db.select(_db.items).get();
    _itemsCached.value = true;
  }

  Future<void> _fetchPurchaseOrders() async {
    purchaseOrders.value = await _db.select(_db.purchaseOrders).get();
    _purchaseOrdersCached.value = true;
  }

  Future<void> _fetchPurchaseOrderItems() async {
    purchaseOrderItems.value = await _db.select(_db.purchaseOrderItems).get();
    _purchaseOrderItemsCached.value = true;
  }

  Future<void> _fetchReceipts() async {
    receipts.value = await _db.select(_db.receipts).get();
    _receiptsCached.value = true;
  }

  void changeTable(String table) {
    selectedTable.value = table;
    currentIndex.value = _tableNames.indexOf(table);
    loadTableData();
  }

  //* ------------------- Force refresh current table data ------------------- //
  void refreshCurrentTable() {
    loadTableData(forceRefresh: true);
  }

  //* ------------------- Clear all caches (useful when data is modified elsewhere) ------------------- //
  void clearCache() {
    _suppliersCached.value = false;
    _itemsCached.value = false;
    _purchaseOrdersCached.value = false;
    _purchaseOrderItemsCached.value = false;
    _receiptsCached.value = false;
  }

  void changeToFirstTable() {
    selectedTable.value = _tableNames[0];
    currentIndex.value = 0;
    loadTableData();
  }
}
