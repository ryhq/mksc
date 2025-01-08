import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/providers/vegetable_provider.dart';
import 'package:mksc/services/initiatial_services.dart';
import 'package:mksc/utilities/screen_size_utility.dart';
import 'package:mksc/views/home/mksc_home.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

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
                  fontSize: ScreenSizeUtility.scaleFontSize(context, 84),
                  fontFamily: 'pac_libertas',
                  fontWeight: FontWeight.normal
                ),
              ),
              Text(
                "Bivouac",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: ScreenSizeUtility.scaleFontSize(context, 42),
                  fontFamily: 'caesar',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Image.asset(
                "assets/logo/MKSC_logo.png",
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
    
    await DatabaseHelper.database;
    
    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      log = "Checking Connectivity...";
    });

    InitiatialServices initiatialServices = InitiatialServices();

    // Fetch for the presence of any network connection

    List<ConnectivityResult> connectivityResult = await initiatialServices.checkConnectivity();

    await Future.delayed(const Duration(milliseconds: 1800));

    // If any is available
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

          await Future.delayed(const Duration(milliseconds: 700));

          await _initializeAppPrimaryColory();

          await Future.delayed(const Duration(milliseconds: 700));

          setState(() {
            log = "Primary color : ${Provider.of<ThemeProvider>(context, listen: false).primaryColor}";
          });

          await Future.delayed(const Duration(milliseconds: 3000));

          // Vegetable initialization

          setState(() {
            log = "Initializing Vegetable garden...";
          });
          
          await _initializeVegetableGardern();
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
      log = "Initialization complete!";
    });
    
    await Future.delayed(const Duration(milliseconds: 3000));
    
    _goHome();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const MKSCHome(),), 
      (Route<dynamic> route) => false
    );
  }

  Future<void> _initializeVegetableGardern() async {
    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableBaseData(context);
  }

  Future<void> _initializeAppPrimaryColory() async {
    
    await Provider.of<ThemeProvider>(context, listen: false).setPrimaryColorFromNet();
    
    await Future.delayed(const Duration(milliseconds: 1700));

    _setPrimaryColor();
  }

  void _setPrimaryColor() {
    debugPrint("\n\n\n👉👉👉👉👉${Provider.of<ThemeProvider>(context, listen: false).primaryColor}");
    Provider.of<ThemeProvider>(context, listen: false).setPrimaryColor(
      Provider.of<ThemeProvider>(context, listen: false).primaryColor
    );
    debugPrint("\n\n\n👉👉👉👉👉${Theme.of(context).colorScheme.primary}");
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
