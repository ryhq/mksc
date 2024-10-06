import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mksc/provider/camp_provider.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/provider/greeting_provider.dart';
import 'package:mksc/provider/internet_connection_provider.dart';
import 'package:mksc/provider/laundry_machine_provider.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:mksc/provider/menu_type_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove(); 
  runApp(
    MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Chicken House Data Provider 
        ChangeNotifierProvider(create: (_) => ChickenHouseDataProvider()),
        // Greeting Provider
        ChangeNotifierProvider(create: (_) => GreetingProvider()),
        // Camp Provider
        ChangeNotifierProvider(create: (_) => CampProvider()),
        // Menu Type Provider
        ChangeNotifierProvider(create: (_) => MenuTypeProvider()),
        // Menu Provider
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        // Vegetable Provider
        ChangeNotifierProvider(create: (_) => VegetableProvider()),
        // Laundry Machine Provider
        ChangeNotifierProvider(create: (_) => LaundryMachineProvider()),
        // Internet Connection Provider
        ChangeNotifierProvider(create: (_) => InternetConnectionProvider()),
      ],
      child: const MKSC(),
    )
  );
}

class MKSC extends StatelessWidget {
  const MKSC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MKSC',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
    );
  }
}