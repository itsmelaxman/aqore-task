export 'app_enums.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Aqore App';
  static const String appVersion = 'v26.1.0';

  // SharedPreferences Keys
  static const String keyBusinessName = 'business_name';
  static const String keyBusinessSetupDone = 'business_setup_done';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
}
