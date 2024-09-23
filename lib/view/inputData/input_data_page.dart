import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/authentication_services.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class InputDataPage extends StatefulWidget {
  final String categoryTitle;
  const InputDataPage({super.key, required this.categoryTitle});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  final TextEditingController passwordCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _continueClicked = false;
  IconData networkStatus = Icons.signal_cellular_nodata_sharp;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.primary,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                ),
              ),
            );
          },
        ),
        title: Text(
          widget.categoryTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome to MKSC - ${widget.categoryTitle} category",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 21,
                    ),
                    Text(
                      "Email for authentication.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    AppTextFormField(
                      hintText: "chicken@chicken.com",
                      iconData: Icons.email,
                      obscureText: false,
                      textInputType: TextInputType.emailAddress,
                      textEditingController: emailController,
                      validator: (value) =>
                          ValidatorUtility.validateEmail(value),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Text(
                      "Enter code to Input Data for ${widget.categoryTitle}.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    AppTextFormField(
                      hintText: "####",
                      iconData: Icons.code,
                      obscureText: false,
                      textInputType: TextInputType.number,
                      textEditingController: passwordCodeController,
                      validator: (value) => ValidatorUtility.validateRequiredField(
                          value,
                          "Code number for ${widget.categoryTitle} is Required!"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              _continueClicked
                  ? const BallPulseIndicator()
                  : Button(
                      title: "Continue...",
                      onTap: () => authenticate(),
                    ),
              const SizedBox(
                height: 21,
              ),
              Center(
                child: Icon(
                  networkStatus,
                  size: Provider.of<ThemeProvider>(context).fontSize + 84,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void checkConnectivity() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // StreamSubscription<List<ConnectivityResult>> subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
    //   // Received changes in available connectivity types!
    //   setState(() {
    //     if (result.contains(ConnectivityResult.none)) {
    //       networkStatus = Icons.signal_cellular_nodata_sharp;
    //     } else if (result.contains(ConnectivityResult.bluetooth)) {
    //       networkStatus = Icons.bluetooth;
    //     } else if (result.contains(ConnectivityResult.ethernet)) {
    //       networkStatus = Icons.settings_ethernet;
    //     } else if (result.contains(ConnectivityResult.mobile)) {
    //       networkStatus = Icons.signal_cellular_alt;
    //     } else if (result.contains(ConnectivityResult.vpn)) {
    //       networkStatus = Icons.vpn_lock;
    //     } else if (result.contains(ConnectivityResult.wifi)) {
    //       networkStatus = Icons.wifi;
    //     }
    //   });
    //  });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.signal_cellular_nodata_sharp;
        });
      } else if (connectivityResult.contains(ConnectivityResult.bluetooth) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.bluetooth;
        });
      } else if (connectivityResult.contains(ConnectivityResult.ethernet) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.settings_ethernet;
        });
      } else if (connectivityResult.contains(ConnectivityResult.mobile) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.signal_cellular_alt;
        });
      } else if (connectivityResult.contains(ConnectivityResult.vpn) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.vpn_lock;
        });
      } else if (connectivityResult.contains(ConnectivityResult.wifi) &&
          context.mounted) {
        setState(() {
          networkStatus = Icons.wifi;
        });
      }
    });
  }

  void authenticate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _continueClicked = true;
      });

      // await AuthenticationServices.authenticate(widget.categoryTitle, context,
      //     emailController: emailController,
      //     passwordCodeController: passwordCodeController);

      setState(() {
        _continueClicked = false;
      });
    }
  }
}
