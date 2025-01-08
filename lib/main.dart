import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mksc/navigator_key.dart';
import 'package:mksc/providers/camp_provider.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/providers/greeting_provider.dart';
import 'package:mksc/providers/internet_connection_provider.dart';
import 'package:mksc/providers/laundry_machine_provider.dart';
import 'package:mksc/providers/menu_provider.dart';
import 'package:mksc/providers/menu_type_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/providers/vegetable_provider.dart';
import 'package:mksc/views/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Check if the platform is Android or iOS (use native SQLite) or desktop (use FFI SQLite)
  if (
    kIsWeb || defaultTargetPlatform == TargetPlatform.linux || 
    defaultTargetPlatform == TargetPlatform.macOS || 
    defaultTargetPlatform == TargetPlatform.windows
  ) {
    sqfliteFfiInit(); // Initialize FFI for Linux/macOS/Windows
    databaseFactory = databaseFactoryFfi; // Set the FFI database factory
  } else {
    // Use the default SQLite database factory for Android/iOS
  }
  
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove(); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GreetingProvider()),
        ChangeNotifierProvider(create: (_) => InternetConnectionProvider()),
        ChangeNotifierProvider(create: (_) => ChickenHouseProvider()),
        ChangeNotifierProvider(create: (_) => VegetableProvider()),
        ChangeNotifierProvider(create: (_) => CampProvider()),
        ChangeNotifierProvider(create: (_) => MenuTypeProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => LaundryMachineProvider()),
      ],
      child: const MKSC(),
    )
  );

}

class MKSC extends StatelessWidget {
  const MKSC({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MKSC',
      navigatorKey: navigatorKey,
      theme: themeProvider.getThemeData(context),
      home: const SplashScreen(),
    );
  }
}