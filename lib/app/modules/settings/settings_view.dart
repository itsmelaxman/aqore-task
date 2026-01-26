import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_library.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(title: 'Settings', showBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildHeader(),
            Gaps.verticalGapOf(AppDimensions.md),
            _buildSettingsSection(),
            Gaps.verticalGapOf(AppDimensions.lg),
            _buildLogoutButton(),
            Gaps.verticalGapOf(AppDimensions.lg),
            _buildVersionInfo(),
            Gaps.verticalGapOf(AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: .infinity,
      color: AppColors.surface,
      padding: .all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Hello 👋',
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: .w600),
          ),
          Gaps.verticalGapOf(AppDimensions.sm),
          Obx(
            () => Text(
              controller.businessName.value.isNotEmpty
                  ? controller.businessName.value
                  : 'Business',
              style: Get.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          _buildSettingsItem(
            iconPath: Assets.businessOutlined,
            title: 'Business information',
            onTap: () => Get.toNamed(Routes.businessSetup),
          ),
          const Divider(height: 1, indent: 72),
          _buildSettingsItem(
            iconPath: Assets.inventoryOutlined,
            title: 'View Database Tables',
            onTap: () => Get.toNamed(Routes.databaseViewer),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: .symmetric(horizontal: AppDimensions.lg),
      child: OutlinedButton(
        onPressed: controller.deleteAccount,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(AppDimensions.md),
          ),
          side: const BorderSide(color: Colors.red),
          foregroundColor: Colors.red,
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            SvgHelper.fromSource(
              path: Assets.cancel,
              height: 20,
              width: 20,
              color: Colors.red,
            ),
            Gaps.horizontalGapOf(AppDimensions.sm),
            const Text('Delete Account'),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Text(
        AppConstants.appVersion,
        style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        child: Row(
          children: [
            Container(
              padding: .all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: .circular(AppDimensions.sm),
              ),
              child: SvgHelper.fromSource(
                path: iconPath,
                height: 24,
                width: 24,
              ),
            ),
            Gaps.horizontalGapOf(AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: Get.textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
