import 'package:get/get.dart';
import 'main_controller.dart';
import '../supplier/supplier_controller.dart';
import '../item/item_controller.dart';
import '../purchase_order/purchase_order_controller.dart';
import '../receipt/receipt_controller.dart';
import '../settings/settings_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    Get.lazyPut<SupplierController>(() => SupplierController());
    Get.lazyPut<ItemController>(() => ItemController());
    Get.lazyPut<PurchaseOrderController>(
      () => PurchaseOrderController(),
      fenix: true,
    );
    Get.lazyPut<ReceiptController>(() => ReceiptController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
