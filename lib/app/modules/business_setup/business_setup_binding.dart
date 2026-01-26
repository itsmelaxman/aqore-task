import 'package:get/get.dart';
import 'business_setup_controller.dart';

class BusinessSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessSetupController>(() => BusinessSetupController());
  }
}
