import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/providers/internet_connection_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/services/authentication_services.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/chickenHouse/chicken_house_screen.dart';
import 'package:mksc/views/laundry/laundry_screen.dart';
import 'package:mksc/views/vegetables/vegetables_screen.dart';
import 'package:mksc/widgets/app_animated_switcher.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  final String title;
  const AuthenticationPage({super.key, required this.title});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  final TextEditingController passwordCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _continueClicked = false;

  String email = "";

  String savedToken = "";

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (widget.title == "Chicken House") {
      email = "chicken@chicken.com";
    } else if (widget.title == "Vegetables") {
      email = "vegetable@vegetable.com";
    } else if (widget.title == "Laundry") {
      email = "laundry@laundry.com";
    }
    if (widget.title != "Laundry") {
      checkTokenPresence();
    }
  }

  @override
  void dispose() {;
    // Reset orientation preferences when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void checkTokenPresence() async {

    TokenStorage tokenStorage = TokenStorage();

    AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: widget.title);
    
    savedToken = authToken.token;

    if (savedToken.isNotEmpty) {

      debugPrint("\n\n\n🪙🟡💰🥮Fetched Token for ${widget.title} is : $savedToken");

      bool expired = authToken.expireAt.isBefore(DateTime.now());
      if (expired) {
        debugPrint("\n\n\nDeleting token");
        tokenStorage.deleteToken(tokenKey: widget.title);
      } else {
        navigate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool internetConnection = Provider.of<InternetConnectionProvider>(context).isConnected;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: Provider.of<ThemeProvider>(context).fontSize + 7,
                  ),
                ),
              ),
            );
          },
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          internetConnection ? const SizedBox() : 
          IconButton(
            onPressed: () => _navigateNoToken(), 
            icon: Icon(
              Icons.hdr_weak,
              color: Colors.white,
              size: Provider.of<ThemeProvider>(context).fontSize + 7,
            )
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome to MKSC's, ${widget.title} module",
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
                      "Enter code for ${widget.title}.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    // AppTextFormField(
                    //   hintText: "####",
                    //   iconData: Icons.code,
                    //   obscureText: false,
                    //   textInputType: TextInputType.number,
                    //   textEditingController: passwordCodeController,
                    //   onChanged: (value) {
                    //     // Check if the input is a positive integer
                    //     if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) >= 0) {
                    //       if (int.parse(value) <= 9999) {
                    //         setState(() {
                    //           passwordCodeController.text = value;
                    //         });
                    //       }else{
                    //         // Clear the input if it is invalid
                    //         passwordCodeController.clear();
                    //       }
                    //     } else {
                    //       // Clear the input if it is invalid
                    //       passwordCodeController.clear();
                    //     }
                    //   },
                    //   validator: (value) {
                    //     return ValidatorUtility.validateRequiredField(
                    //       value,
                    //       "Code number for ${widget.title} is required!"
                    //     );
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        readOnly: true,
                        obscureText: true,
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
                        onChanged: (value) {
                          setState(() {
                            passwordCodeController.text = value;
                          });
                        },
                        onCompleted: (value) => authenticate(),
                        autoFocus: true,
                        blinkDuration: const Duration(milliseconds: 700),
                        blinkWhenObscuring: true,
                        controller: passwordCodeController,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          borderRadius: BorderRadius.circular(5),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        useHapticFeedback: true,
                        showCursor: false,
                      ),
                    ),

                    Opacity(
                      opacity: passwordCodeController.text.length != 4 ? 1.0 : 0.3,
                      child: AbsorbPointer(
                        absorbing: passwordCodeController.text.length == 4,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: GridView.count(
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              crossAxisCount: 3,
                              children: List.generate(12, (index) {
                                // return numberKeyButton(context: context, index: index);
                                // Conditionally show "0" below the 8 key
                                if (index == 10) {
                                  return numberKeyButton(context: context, label: "0");
                                } else if (index == 11) {
                                  // Conditionally show delete button next to "0"
                                  return passwordCodeController.text.isNotEmpty
                                    ? deleteKeyButton(context: context)
                                    : const SizedBox.shrink();
                                } else {
                                  // Skip numbers for 10 and 11 to balance the layout
                                  return index == 9 || index == 11 ? 
                                  const SizedBox.shrink() : numberKeyButton(context: context, label: "${index + 1}");
                                }
                              },),
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              AppAnimatedSwitcher(
                show: _continueClicked, 
                child: const BallPulseIndicator()
              ),
              // _continueClicked ? const BallPulseIndicator() : Button(
              //   title: "Continue...",
              //   onTap: () => authenticate(),
              // ),
              const SizedBox(
                height: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget numberKeyButton({required BuildContext context, required String label}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Append the number directly to the text
          passwordCodeController.text += label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 21,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteKeyButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (passwordCodeController.text.isNotEmpty) {
            // Remove the last character from the text
            passwordCodeController.text = passwordCodeController.text.substring(0, passwordCodeController.text.length - 1);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 21,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Icon(
                Icons.backspace, // Backspace icon
                size: Theme.of(context).textTheme.headlineLarge?.fontSize,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }
  void authenticate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _continueClicked = true;
      });
    
      try {
      await AuthenticationServices.authenticate(
        widget.title, context,
        email: email,
        passwordCode: passwordCodeController.text,
      );

      passwordCodeController.clear();
    } catch (e) {
      debugPrint('Authentication failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed. Please try again.'), backgroundColor: Colors.red,),
      );
    } finally {
      if (context.mounted) {
        setState(() {
          _continueClicked = false;
        });
      }
    }
    }
  }

  void navigate() {
    if (savedToken.isNotEmpty && context.mounted) {
      Navigator.pop(context);
      if (widget.title == "Chicken House") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChickenHouseScreen(
              categoryTitle: widget.title,
            ),
          )
        );
      }
      if (widget.title == "Vegetables") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VegetablesScreen(
              categoryTitle: widget.title,
            ),
          )
        );
      }
      if (widget.title == "Laundry") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaundryScreen(
              categoryTitle: widget.title,
              token: savedToken,
              camp: "",
            ),
          )
        );
      }
    }
  }


  void _navigateNoToken() {
    Navigator.pop(context);
    if (widget.title == "Chicken House") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChickenHouseScreen(
            categoryTitle: widget.title,
          ),
        )
      );
    }
    if (widget.title == "Vegetables") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VegetablesScreen(
            categoryTitle: widget.title,
          ),
        )
      );
    }
    if (widget.title == "Laundry") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaundryScreen(
            categoryTitle: widget.title,
            token: savedToken,
            camp: "",
          ),
        )
      );
    }
  }
}
