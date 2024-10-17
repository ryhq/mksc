import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class VegetablesSyncScreen extends StatefulWidget {
  const VegetablesSyncScreen({super.key});

  @override
  State<VegetablesSyncScreen> createState() => _VegetablesSyncScreenState();
}

class _VegetablesSyncScreenState extends State<VegetablesSyncScreen> {
  List<String> svgIconUrl = [
    'assets/icons/vegetable_garden/apple.svg',
    'assets/icons/vegetable_garden/carrot.svg',
    'assets/icons/vegetable_garden/cherries.svg',
    'assets/icons/vegetable_garden/pear.svg',
    'assets/icons/vegetable_garden/pineapple.svg',
    'assets/icons/vegetable_garden/watermelon.svg',
  ];

  int _currentIconIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Start a timer to change the icon every 3 second
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIconIndex = (_currentIconIndex + 1) % svgIconUrl.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Image.asset(
                  "assets/logo/logo.png",
                ),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),  // Duration of the fade transition
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: SvgPicture.asset(
                    svgIconUrl[_currentIconIndex],
                    key: ValueKey<String>(svgIconUrl[_currentIconIndex]),  // Key ensures correct transitions
                    height: 80,
                    width: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 21,),
                Text(
                  "Please wait...\n(Syncing with MKSC servers)",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  )
                ),
              ],
            ),
          ),
        ),
      )
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
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }
}