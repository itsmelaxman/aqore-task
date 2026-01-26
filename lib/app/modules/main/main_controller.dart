import 'package:get/get.dart';
import '../../data/services/preference_service.dart';

class MainController extends GetxController {
  final PreferenceService _prefs = Get.find<PreferenceService>();

  final currentIndex = 0.obs;
  final businessName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBusinessName();
  }

  void _loadBusinessName() {
    businessName.value = _prefs.businessName ?? 'Business';
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
