import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../data/local/app_database.dart';
import '../../data/services/database_service.dart';

class SupplierFormController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();
  AppDatabase get _db => _dbService.database;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final status = DataFetchStatus.initial.obs;
  final isEdit = false.obs;
  int? supplierId;

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
    contactPersonController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  //* ----------------------- Initialize Form Data ----------------------- //
  void _initializeForm() {
    if (Get.arguments != null && Get.arguments is Supplier) {
      final supplier = Get.arguments as Supplier;
      supplierId = supplier.id;
      nameController.text = supplier.name;
      contactPersonController.text = supplier.contactPerson;
      emailController.text = supplier.email ?? '';
      phoneController.text = supplier.phone;
      addressController.text = supplier.address;
      isEdit.value = true;
    } else {
      isEdit.value = false;
      supplierId = null;
    }
  }

  //* ----------------------- Submit Form ----------------------- //
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    // Check for duplicate name
    final duplicateExists = await _checkDuplicateName(
      nameController.text.trim(),
      excludeId: supplierId,
    );
    if (duplicateExists) {
      CustomToast.error('A supplier with this name already exists');
      return;
    }

    status.value = DataFetchStatus.loading;

    try {
      if (isEdit.value && supplierId != null) {
        await _updateSupplier();
      } else {
        await _createSupplier();
      }
      status.value = DataFetchStatus.success;
      Get.back(result: true);
      CustomToast.success(
        isEdit.value
            ? 'Your changes have been saved!'
            : 'Supplier created successfully',
      );
    } catch (e) {
      status.value = DataFetchStatus.error;
      CustomToast.error('Couldn’t save the supplier. Please try again.');
    }
  }

  //* ----------------------- Create Supplier ----------------------- //
  Future<void> _createSupplier() async {
    await _db
        .into(_db.suppliers)
        .insert(
          SuppliersCompanion.insert(
            name: nameController.text.trim(),
            contactPerson: contactPersonController.text.trim(),
            email: drift.Value(
              emailController.text.trim().isEmpty
                  ? null
                  : emailController.text.trim(),
            ),
            phone: phoneController.text.trim(),
            address: addressController.text.trim(),
          ),
        );
  }

  //* ----------------------- Update Supplier ----------------------- //
  Future<void> _updateSupplier() async {
    await (_db.update(
      _db.suppliers,
    )..where((tbl) => tbl.id.equals(supplierId!))).write(
      SuppliersCompanion(
        name: drift.Value(nameController.text.trim()),
        contactPerson: drift.Value(contactPersonController.text.trim()),
        email: drift.Value(
          emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
        ),
        phone: drift.Value(phoneController.text.trim()),
        address: drift.Value(addressController.text.trim()),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  //* ----------------------- Check Duplicate Name ----------------------- //
  Future<bool> _checkDuplicateName(String name, {int? excludeId}) async {
    final lowerName = name.toLowerCase();
    final allSuppliers = await _db.select(_db.suppliers).get();

    return allSuppliers.any(
      (supplier) =>
          supplier.name.toLowerCase() == lowerName &&
          (excludeId == null || supplier.id != excludeId),
    );
  }
}
