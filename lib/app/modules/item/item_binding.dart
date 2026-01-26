import 'package:get/get.dart';
import 'item_controller.dart';
import 'item_form_controller.dart';

class ItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemController>(ItemController(), permanent: true);
    Get.lazyPut<ItemFormController>(() => ItemFormController());
  }
}
