import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
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
                "Bivouac",
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
      log = "Database initialization state : ${mksc.isOpen}";
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
        final bool isInternetConnected = await initiatialServices.checkInternetConnectionBool();

        if (isInternetConnected) {
          // Theme Initialization
          setState(() {
            log = "Fetching Theme...";
          });
          await Provider.of<ThemeProvider>(context, listen: false).setPrimaryColorFromNet();
          await Future.delayed(const Duration(milliseconds: 1700));
          debugPrint("\n\n\nTheme.of(context).colorScheme.primary\n👉👉👉Primary color : ${Theme.of(context).colorScheme.primary}");
          debugPrint("\n\n\nProvider.of<ThemeProvider>(context, listen: false).primaryColor\n👉👉👉Primary color : ${Provider.of<ThemeProvider>(context, listen: false).primaryColor}");
          Provider.of<ThemeProvider>(context, listen: false).setPrimaryColor(Theme.of(context).colorScheme.primary);
          setState(() {
            log = "Primary color : ${Provider.of<ThemeProvider>(context, listen: false).primaryColor}";
          });

          // Vegetable initialization

          setState(() {
            log = "Initializing Vegetable garden...";
          });
          
          await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableBaseData(context);
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
    
    await Future.delayed(const Duration(milliseconds: 3000));

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

}
