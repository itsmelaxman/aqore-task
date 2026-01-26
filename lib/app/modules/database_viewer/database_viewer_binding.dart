import 'package:get/get.dart';
import 'database_viewer_controller.dart';

class DatabaseViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseViewerController>(() => DatabaseViewerController());
  }
}
