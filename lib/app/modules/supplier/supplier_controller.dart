import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class SupplierController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final suppliers = <Supplier>[].obs;
  final status = DataFetchStatus.initial.obs;
  final currentSupplier = Rxn<Supplier>();
  int? _watchingSupplierIdId;

  //* ----------------------- Initialize Controller ----------------------- //
  @override
  void onInit() {
    super.onInit();
    _watchSuppliers();
  }

  //* ----------------------- Watch Supplier By ID ----------------------- //
  void watchSupplierById(int id) {
    // Prevent duplicate on rebuild
    if (_watchingSupplierIdId == id) return;
    _watchingSupplierIdId = id;

    _db.select(_db.suppliers).watch().listen((allSuppliers) {
      currentSupplier.value = allSuppliers.firstWhereOrNull(
        (supplier) => supplier.id == id,
      );
    });
  }

  //* ----------------------- Watch All Suppliers ----------------------- //
  void _watchSuppliers() {
    status.value = DataFetchStatus.loading;
    _db.select(_db.suppliers).watch().listen((data) {
      suppliers.value = data;
      status.value = data.isEmpty
          ? DataFetchStatus.empty
          : DataFetchStatus.success;
    });
  }

  //* ----------------------- Get Supplier By ID ----------------------- //
  Future<Supplier?> getSupplierById(int id) async {
    return await (_db.select(
      _db.suppliers,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  //* ----------------------- Delete Supplier ----------------------- //
  Future<void> deleteSupplier(int id) async {
    try {
      await (_db.delete(_db.suppliers)..where((tbl) => tbl.id.equals(id))).go();
      CustomToast.success('Supplier has been deleted.');
    } catch (e) {
      CustomToast.error('Couldn’t delete the supplier. Please try again.');
    }
  }
}
