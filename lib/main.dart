import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/home/mksc_home.dart';
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
        // Data Provider
        ChangeNotifierProvider(create: (_) => DataProvider()),
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
      home: const MKSCHome(),
    );
  }
}