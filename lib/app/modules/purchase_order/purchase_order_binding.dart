import 'package:get/get.dart';
import 'purchase_order_controller.dart';
import 'purchase_order_form_controller.dart';

class PurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseOrderController>(() => PurchaseOrderController());
    Get.lazyPut<PurchaseOrderFormController>(
      () => PurchaseOrderFormController(),
    );
  }
}
