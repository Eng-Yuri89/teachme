import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachme/ui/screens/route_screen.dart';
import 'package:teachme/ui/theme.dart';
import 'services/auth_service.dart';
import 'services/auth_service_adapter.dart';
import 'services/db.dart';
import 'services/firebase_storage_service.dart';
import 'services/firestore_service.dart';
import 'services/image_picker_service.dart';

void main() {
  runApp(TeachMeApp());
}

/// Main class in which the application type,
/// theme settings and home screen are declared.
class TeachMeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        /* locale: DevicePreview.of(context).locale,
        builder: DevicePreview.appBuilder, */
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        home: RouteScreen(),
      ),
    );
  }
}
