import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/preference_service.dart';
import '../../routes/app_routes.dart';
import '../../data/services/database_service.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/custom_toast.dart';

class SettingsController extends GetxController {
  final PreferenceService _prefs = Get.find<PreferenceService>();

  final businessName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBusinessName();
  }

  void _loadBusinessName() {
    businessName.value = _prefs.businessName ?? 'Business';
  }

  Future<void> deleteAccount() async {
    // Show confirmation dialog
    final confirmed = await AppDialogs.showConfirmation(
      title: 'Delete Account',
      message:
          'Are you sure you want to delete your account? This will permanently delete all your data including suppliers, items, purchase orders, and receipts. This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
    );

    if (confirmed) {
      try {
        // Get database service and clear all data
        final dbService = Get.find<DatabaseService>();
        await dbService.nukeAllData();

        await _prefs.clearAllPreferences();

        // Navigate to business setup screen
        Get.offAllNamed(Routes.businessSetup);

        CustomToast.success('All your data has been permanently deleted.');
      } catch (e) {
        CustomToast.error('Couldn’t delete account data. Please try again.');
      }
    }
  }
}
