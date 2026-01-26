import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/data/services/preference_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await InitialBinding.initServices();

  // Check setup status from service
  final prefs = Get.find<PreferenceService>();
  final isSetupDone = prefs.isBusinessSetupDone;

  runApp(MyApp(isSetupDone: isSetupDone));
}

class MyApp extends StatelessWidget {
  final bool isSetupDone;

  const MyApp({super.key, required this.isSetupDone});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aqore Inventory',
      theme: AppTheme.light(),
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: isSetupDone ? Routes.main : Routes.businessSetup,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
