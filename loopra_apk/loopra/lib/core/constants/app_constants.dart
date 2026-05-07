class AppConstants {
  static const String appName = 'LOOPRA';
  static const String appTagline = 'Waste to Energy Revolution';

  // Waste Categories
  static const String categoryBioethanol = 'Bioethanol';
  static const String categoryBiogas = 'Biogas';

  // Waste Conditions
  static const String conditionOverripe = 'Overripe';
  static const String conditionLightRot = 'Light Rot';
  static const String conditionHeavyRot = 'Heavy Rot';

  // Collection Point Types
  static const String collectionPointMarket = 'Market Hub';
  static const String collectionPointFarm = 'Farm Collection';
  static const String collectionPointMobile = 'Mobile Unit';

  // Demo Data
  static const double demoWalletBalance = 1250000;
  static const double demoCarbonSaved = 45.5;

  // API / Service Constants
  static const int imageMaxSize = 5 * 1024 * 1024; // 5MB
  static const Duration apiTimeout = Duration(seconds: 30);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
}

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String wasteUpload = '/waste-upload';
  static const String wallet = '/wallet';
  static const String marketplace = '/marketplace';
  static const String map = '/map';
  static const String carbonTracker = '/carbon-tracker';
  static const String schedule = '/schedule';
}
