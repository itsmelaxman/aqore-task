import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/utils/code_generator.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class ReceiptFormController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final suppliers = <Supplier>[].obs;
  final selectedSupplier = Rxn<Supplier>();
  final availableOrders = <PurchaseOrder>[].obs;
  final selectedOrderIds = <int>[].obs;

  final status = DataFetchStatus.initial.obs;

  bool get isLoading => status.value == DataFetchStatus.loading;

  @override
  void onInit() {
    super.onInit();
    _watchSuppliers();
  }

  void _watchSuppliers() {
    _db.select(_db.suppliers).watch().listen((data) {
      suppliers.value = data;
    });
  }

  Future<void> onSupplierSelected(Supplier? supplier) async {
    selectedSupplier.value = supplier;
    selectedOrderIds.clear();

    if (supplier != null) {
      await _loadAvailableOrders(supplier.id);
    } else {
      availableOrders.clear();
    }
  }

  Future<void> _loadAvailableOrders(int supplierId) async {
    status.value = DataFetchStatus.loading;
    try {
      final orders =
          await (_db.select(_db.purchaseOrders)
                ..where((tbl) => tbl.supplierId.equals(supplierId))
                ..where((tbl) => tbl.status.equals('pending')))
              .get();

      availableOrders.value = orders;
      status.value = DataFetchStatus.success;
    } catch (e) {
      status.value = DataFetchStatus.error;
      CustomToast.error('Couldn’t load purchase orders. Please try again.');
    }
  }

  void toggleOrderSelection(int orderId) {
    if (selectedOrderIds.contains(orderId)) {
      selectedOrderIds.remove(orderId);
    } else {
      selectedOrderIds.add(orderId);
    }
  }

  bool isOrderSelected(int orderId) {
    return selectedOrderIds.contains(orderId);
  }

  double get totalAmount {
    return availableOrders
        .where((order) => selectedOrderIds.contains(order.id))
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  double getTotalAmount() {
    return totalAmount;
  }

  Future<void> generateReceipt() async {
    if (selectedSupplier.value == null) {
      CustomToast.error('Please select a supplier');
      return;
    }

    if (selectedOrderIds.isEmpty) {
      CustomToast.error('Please select at least one purchase order');
      return;
    }

    status.value = DataFetchStatus.loading;

    try {
      final receiptNumber = CodeGenerator.generateReceiptNumber();

      await _dbService.generateReceiptFromOrders(
        supplierId: selectedSupplier.value!.id,
        purchaseOrderIds: selectedOrderIds,
        receiptNumber: receiptNumber,
      );

      status.value = DataFetchStatus.success;
      Get.back(result: true);
      CustomToast.success('Receipt generated successfully');
    } catch (e) {
      status.value = DataFetchStatus.error;
      CustomToast.error('Couldn’t generate the receipt. Please try again.');
    }
  }
}
