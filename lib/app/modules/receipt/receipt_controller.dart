import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class ReceiptWithDetails {
  final Receipt receipt;
  final Supplier supplier;

  ReceiptWithDetails({required this.receipt, required this.supplier});
}

class ReceiptController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final receipts = <ReceiptWithDetails>[].obs;
  final status = DataFetchStatus.initial.obs;

  @override
  void onInit() {
    super.onInit();
    _watchReceipts();
  }

  void _watchReceipts() {
    status.value = DataFetchStatus.loading;

    _db.select(_db.receipts).watch().listen((receipts) async {
      if (receipts.isEmpty) {
        this.receipts.value = [];
        status.value = DataFetchStatus.empty;
        return;
      }

      status.value = DataFetchStatus.loading;
      final List<ReceiptWithDetails> result = [];

      for (final receipt in receipts) {
        try {
          final supplier =
              await (_db.select(_db.suppliers)
                    ..where((tbl) => tbl.id.equals(receipt.supplierId)))
                  .getSingleOrNull();

          if (supplier == null) {
            continue;
          }

          result.add(ReceiptWithDetails(receipt: receipt, supplier: supplier));
        } catch (e) {
          //
        }
      }

      this.receipts.value = result;
      status.value = DataFetchStatus.success;
    });
  }
}
