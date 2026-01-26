import 'package:get/get.dart';
import 'supplier_controller.dart';
import 'supplier_form_controller.dart';

class SupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupplierController>(SupplierController(), permanent: true);
    Get.lazyPut<SupplierFormController>(() => SupplierFormController());
  }
}
