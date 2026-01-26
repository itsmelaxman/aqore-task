import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class ItemController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final items = <Item>[].obs;
  final status = DataFetchStatus.initial.obs;
  final currentItem = Rxn<Item>();
  int? _watchingItemId;

  //* ----------------------- Initialize Controller ----------------------- //
  @override
  void onInit() {
    super.onInit();
    _watchItems();
  }

  //* ----------------------- Watch Item By ID ----------------------- //
  void watchItemById(int id) {
    // Prevent duplicate on rebuild
    if (_watchingItemId == id) return;
    _watchingItemId = id;

    _db.select(_db.items).watch().listen((allItems) {
      currentItem.value = allItems.firstWhereOrNull((item) => item.id == id);
    });
  }

  //* ----------------------- Watch All Items ----------------------- //
  void _watchItems() {
    status.value = DataFetchStatus.loading;
    _db.select(_db.items).watch().listen((data) {
      items.value = data;
      status.value = data.isEmpty
          ? DataFetchStatus.empty
          : DataFetchStatus.success;
    });
  }

  //* ----------------------- Get Item By ID ----------------------- //
  Future<Item?> getItemById(int id) async {
    return await (_db.select(
      _db.items,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  //* ----------------------- Delete Item ----------------------- //
  Future<void> deleteItem(int id) async {
    try {
      await (_db.delete(_db.items)..where((tbl) => tbl.id.equals(id))).go();
      CustomToast.success('Item has been deleted.');
    } catch (e) {
      CustomToast.error('Couldn’t delete the item. Please try again.');
    }
  }
}
