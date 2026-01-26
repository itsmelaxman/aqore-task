import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/preference_service.dart';
import '../../routes/app_routes.dart';

class BusinessSetupController extends GetxController {
  final PreferenceService _prefs = Get.find<PreferenceService>();

  final formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadBusinessName();
  }

  void _loadBusinessName() {
    final businessName = _prefs.businessName;
    if (businessName != null && businessName.isNotEmpty) {
      businessNameController.text = businessName;
    }
  }

  Future<void> saveBusiness() async {
    if (!formKey.currentState!.validate()) return;

    await _prefs.setBusinessName(businessNameController.text.trim());
    await _prefs.setBusinessSetupDone(true);

    Get.offAllNamed(Routes.main);
  }

  @override
  void onClose() {
    businessNameController.dispose();
    super.onClose();
  }
}
