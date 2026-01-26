import 'package:get/get.dart';
import 'receipt_controller.dart';
import 'receipt_form_controller.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(() => ReceiptController());
    Get.lazyPut<ReceiptFormController>(() => ReceiptFormController());
  }
}
