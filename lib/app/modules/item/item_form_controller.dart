import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/utils/code_generator.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class ItemFormController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();

  final status = DataFetchStatus.initial.obs;
  final isEdit = false.obs;
  int? itemId;

  //* ----------------------- Initialize Controller ----------------------- //
  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  //* ----------------------- Dispose Resources ----------------------- //
  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    priceController.dispose();
    stockQuantityController.dispose();
    super.onClose();
  }

  //* ----------------------- Initialize Form Data ----------------------- //
  void _initializeForm() {
    if (Get.arguments != null && Get.arguments is Item) {
      final item = Get.arguments as Item;
      itemId = item.id;
      nameController.text = item.name;
      descriptionController.text = item.description;
      skuController.text = item.sku;
      priceController.text = item.price.toString();
      stockQuantityController.text = item.stockQuantity.toString();
      isEdit.value = true;
    } else {
      isEdit.value = false;
      itemId = null;
    }
  }

  //* ----------------------- Generate SKU Code ----------------------- //
  void generateSku() {
    skuController.text = CodeGenerator.generateItemCode();
  }

  //* ----------------------- Submit Form ----------------------- //
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    // Check for duplicate name
    final duplicateExists = await _checkDuplicateName(
      nameController.text.trim(),
      excludeId: itemId,
    );
    if (duplicateExists) {
      CustomToast.error('An item with this name already exists');
      return;
    }

    status.value = DataFetchStatus.loading;

    try {
      if (isEdit.value && itemId != null) {
        await _updateItem();
      } else {
        await _createItem();
      }
      status.value = DataFetchStatus.success;
      Get.back(result: true);
      CustomToast.success(
        isEdit.value
            ? 'Your changes have been saved!'
            : 'Item created successfully',
      );
    } catch (e) {
      status.value = DataFetchStatus.error;
      CustomToast.error('Couldn’t save the item. Please try again.');
    }
  }

  //* ----------------------- Create Item ----------------------- //
  Future<void> _createItem() async {
    await _db
        .into(_db.items)
        .insert(
          ItemsCompanion.insert(
            name: nameController.text.trim(),
            description: descriptionController.text.trim(),
            sku: skuController.text.trim(),
            price: double.parse(priceController.text.trim()),
            stockQuantity: drift.Value(
              int.parse(stockQuantityController.text.trim()),
            ),
          ),
        );
  }

  //* ----------------------- Update Item ----------------------- //
  Future<void> _updateItem() async {
    await (_db.update(_db.items)..where((tbl) => tbl.id.equals(itemId!))).write(
      ItemsCompanion(
        name: drift.Value(nameController.text.trim()),
        description: drift.Value(descriptionController.text.trim()),
        sku: drift.Value(skuController.text.trim()),
        price: drift.Value(double.parse(priceController.text.trim())),
        stockQuantity: drift.Value(
          int.parse(stockQuantityController.text.trim()),
        ),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  //* ----------------------- Check Duplicate Name ----------------------- //
  Future<bool> _checkDuplicateName(String name, {int? excludeId}) async {
    final lowerName = name.toLowerCase();
    final allItems = await _db.select(_db.items).get();

    return allItems.any(
      (item) =>
          item.name.toLowerCase() == lowerName &&
          (excludeId == null || item.id != excludeId),
    );
  }
}
