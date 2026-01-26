import 'package:get/get.dart';
import '../data/services/database_service.dart';
import '../data/services/preference_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DatabaseService(), permanent: true);
  }

  /// Initialize [services]
  static Future<void> initServices() async {
    await Get.putAsync(() => PreferenceService().init(), permanent: true);
  }
}
