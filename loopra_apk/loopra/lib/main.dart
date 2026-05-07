import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/waste_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/marketplace_provider.dart';
import 'providers/role_provider.dart';
import 'services/demo_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
  }

  final app = const LoopraApp();

  if (kDebugMode) {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => app,
      ),
    );
  } else {
    runApp(app);
  }
}

class LoopraApp extends StatelessWidget {
  const LoopraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WasteProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => DemoState()),
      ],
      child: const App(),
    );
  }
}
