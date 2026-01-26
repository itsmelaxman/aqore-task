import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends GetxService {
  late final SharedPreferences _prefs;

  Future<PreferenceService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get businessName => _prefs.getString('business_name');
  Future<bool> setBusinessName(String value) =>
      _prefs.setString('business_name', value);

  bool get isBusinessSetupDone =>
      _prefs.getBool('business_setup_done') ?? false;
  Future<bool> setBusinessSetupDone(bool value) =>
      _prefs.setBool('business_setup_done', value);

  // clear all
  Future<void> clearAllPreferences() async {
    await _prefs.clear();
  }
}
