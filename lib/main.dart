import 'package:bin_app/features/bin/presentation/pages/bin_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
// import 'package:injectable/injectable.dart' as Environment;
import 'core/di/injection.dart';
import 'core/service/flutter_service.dart';
import 'core/service/local_notificaiton_service.dart';
import 'core/theme/theme.dart';
import 'core/utility/router.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // create a naigator key

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await configureInjection(Environment.prod);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Future.delayed(const Duration(seconds: 2));
  await FirebaseService().initNotifications();
  await LocalNotificationService().initialize();
  final initialRoute = await determineInitialRoute();
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> determineInitialRoute() async {
  final storage = FlutterSecureStorage();
  final authenticated = await storage.containsKey(key: 'accessToken');
  if (authenticated) {
    return BinPage.routeName;
  }
  return LoginScreen.routeName;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      routes: routes,
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
    );
  }
}
