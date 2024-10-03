import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/authentication_services.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/view/chickenHouse/chicken_house_screen.dart';
import 'package:mksc/view/laundry/laundry_screen.dart';
import 'package:mksc/view/vegetables/vegetables_screen.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
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
    widget.title == "Laundry" ? null : checkTokenPresence();
  }

  void checkTokenPresence() async {
    TokenStorage tokenStorage = TokenStorage();

    savedToken = await tokenStorage.getTokenDirect(tokenKey: widget.title);

    if (savedToken.isNotEmpty) {
      debugPrint("\n\n\n🪙🟡💰🥮Fetched Token for ${widget.title} is : $savedToken");
      navigate();
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
              token: savedToken,
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
              token: savedToken,
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

  @override
  Widget build(BuildContext context) {
    if (widget.title == "Chicken House") {
      setState(() {
        email = "chicken@chicken.com";
      });
    }
    if (widget.title == "Vegetables") {
      setState(() {
        email = "vegetable@vegetable.com";
      });
    }
    if (widget.title == "Laundry") {
      setState(() {
        email = "laundry@laundry.com";
      });
    }
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // ColorUtils.calculateSecondaryColor(primaryColor: Theme.of(context).colorScheme.primary),
              // Colors.blue[100]!,
              Colors.grey[50]!,
              Colors.white,
              Colors.grey[50]!,
              // Colors.blue[100]!,
              // ColorUtils.calculateSecondaryColor(primaryColor: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome to MKSC",
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
                      "Enter code to Input Data for ${widget.title}.",
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
                      onChanged: (value) {
                        // Check if the input is a positive integer
                        if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) >= 0) {
                          if (int.parse(value) <= 9999) {
                            setState(() {
                              passwordCodeController.text = value;
                            });
                          }else{
                            // Clear the input if it is invalid
                            passwordCodeController.clear();
                          }
                        } else {
                          // Clear the input if it is invalid
                          passwordCodeController.clear();
                        }
                      },
                      validator: (value) => ValidatorUtility.validateRequiredField(
                        value,
                        "Code number for ${widget.title} is Required!"
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              _continueClicked ? const BallPulseIndicator() : Button(
                title: "Continue...",
                onTap: () => authenticate(),
              ),
              const SizedBox(
                height: 21,
              ),
            ],
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

      await AuthenticationServices.authenticate(
        widget.title, context,
        email: email, 
        passwordCode: passwordCodeController.text
      );

      setState(() {
        _continueClicked = false;
      });
    }
  }
}
