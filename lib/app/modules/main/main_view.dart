import '../../../app_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'entity_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        controller.currentIndex.value != 0
            ? controller.changePage(0)
            : await doubleTapTrigger();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          ),
        ),
        bottomNavigationBar: Obx(
          () => CustomBottomNav(
            currentIndex: controller.currentIndex.value,
            items: [
              BottomNavItem(icon: Assets.supplier, label: 'Suppliers'),
              BottomNavItem(icon: Assets.inventory, label: 'Inventory'),
              BottomNavItem(icon: Assets.entity, label: 'Entity'),
              BottomNavItem(icon: Assets.setting, label: 'Settings'),
            ],
            onTap: controller.changePage,
          ),
        ),
      ),
    );
  }

  List<Widget> get _pages => [
    const SupplierView(),
    const ItemView(),
    const EntityView(),
    const SettingsView(),
  ];
}
