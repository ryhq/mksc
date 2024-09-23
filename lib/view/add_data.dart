import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/authentication_services.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/view/data_categorization/data_categorization.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class AddData extends StatefulWidget {
  final String title;

  const AddData({super.key, required this.title});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  
  final TextEditingController passwordCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  
  bool _continueClicked = false;

  String email = "";

  int code = 0;

  String savedToken = "";

  @override
  void initState() {
    super.initState();
    checkTokenPresence();
  }

  void checkTokenPresence() async{

    debugPrint("\n\n\n Saved Token.....");

    TokenStorage tokenStorage = TokenStorage();

    savedToken = await tokenStorage.getTokenDirect(tokenKey: widget.title);

    debugPrint("\n\n\n 🔥️‍🔥️‍🔥️‍🔥 Saved Token : $savedToken");

    navigate();

  }

  void navigate(){
    if(savedToken.isNotEmpty && context.mounted){
      Navigator.push(context, MaterialPageRoute(builder: (context) => DataCategorization(categoryTitle: widget.title, token: savedToken,),));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == "Chicken House") {
      setState(() {
        email = "chicken@chicken.com";
        code = 2288;
      });
    }
    if (widget.title == "Laundry") {
      setState(() {
        email = "laundry@laundry.com";
        code = 2288;
      });
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
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
              Colors.blue[100]!,
              Colors.grey[50]!,
              Colors.white,
              Colors.grey[50]!,
              Colors.blue[100]!,
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
                      validator: (value) {
                        if (value != null || value!.isNotEmpty) {
                          if (int.parse(value) != code) {
                            return "Invalid Code for ${widget.title}";
                          }
                        }
                        return ValidatorUtility.validateRequiredField(value, "Code number for ${widget.title} is Required!");
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              _continueClicked ? const BallPulseIndicator() : 
              Button(
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

      await AuthenticationServices.authenticate(widget.title, context, email: email, passwordCode: passwordCodeController.text);

      setState(() {
        _continueClicked = false;
      });
    }
  }
}