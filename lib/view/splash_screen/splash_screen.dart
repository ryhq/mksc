import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/home/mksc_home.dart';
import 'package:mksc/services/initiatial_services.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String log = "";

  bool initializationComplete = false;

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    initializeApp();
  }

  @override
  void dispose() {
    // Reset orientation preferences when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "MKSC",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 84,
                  fontFamily: 'pac_libertas',
                  fontWeight: FontWeight.normal
                ),
              ),
              Text(
                "Bivoua",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  fontFamily: 'caesar',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Image.asset(
                "assets/logo/logo.png",
              ),
              Text(
                log,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                )
              ),
              const SizedBox(height: 21,),
              const AppCircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void initializeApp() async{
    setState(() {
      log = "Initializing MKSC database...";
    });
    
    await Future.delayed(const Duration(milliseconds: 700));
    
    Database mksc = await DatabaseHelper.database;
    
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      log = "Database MKSC : Is Open ${mksc.isOpen} : Path ${mksc.path} : Run time Type ${mksc.runtimeType}";
    });
    

    debugPrint("\n\n\n🌐🌐🌐 Check  🛜🛜🛜 Connectivity : 📶📶📶");
    
    setState(() {
      log = "Checking Connectivity...";
    });
    InitiatialServices initiatialServices = InitiatialServices();
    List<ConnectivityResult> connectivityResult = await initiatialServices.checkConnectivity();
    

    await Future.delayed(const Duration(milliseconds: 1700));

    if (
      connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.bluetooth) ||
      connectivityResult.contains(ConnectivityResult.ethernet) ||
      connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.other) ||
      connectivityResult.contains(ConnectivityResult.wifi) ||
      connectivityResult.contains(ConnectivityResult.vpn)
    ) {
      try {
        final List<InternetAddress> lookupResults = await initiatialServices.checkInternetConnection();

        if (lookupResults.isNotEmpty && lookupResults[0].address.isNotEmpty) {
          setState(() {
            log = "Fetching Theme...";
          });
          ThemeProvider themeProvider = ThemeProvider();
          await themeProvider.setPrimaryColorFromNet().then(
            (_){
              debugPrint("\n\n\n👉👉👉Primary color : ${Provider.of<ThemeProvider>(context, listen: false).primaryColor}");
              setState(() {
                log = "Primary color : ${Provider.of<ThemeProvider>(context, listen: false).primaryColor}";
              });
            }
          );
        }

      } catch (e) {
        Fluttertoast.showToast(
          msg: "An error occured while fetching theme. Please check you connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }      
    }


    setState(() {
      log = "Done...";
    });
    
    await Future.delayed(const Duration(milliseconds: 3000));

    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const MKSCHome(),), 
      (Route<dynamic> route) => false
    );
  }
}
