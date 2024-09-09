import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/authentication_services.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class InputDataPage extends StatefulWidget {
  final String categoryTitle;
  const InputDataPage({super.key, required this.categoryTitle});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _continueClicked = false;
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
                const SizedBox(height: 21,),
                Text(
                  "Enter code to Input Data for ${widget.categoryTitle}.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Form(
                  key: _formKey,
                  child: AppTextFormField(
                    hintText: "####", 
                    iconData: Icons.code, 
                    obscureText: false, 
                    textInputType: TextInputType.number,
                    textEditingController: codeController,
                    validator: (value) => ValidatorUtility.validateRequiredField(value, "Code number for ${widget.categoryTitle} is Required!"),
                  ),
                ),
                const SizedBox(height: 21,),
                _continueClicked ? 
                const Center(child: AppCircularProgressIndicator()) : 
                Button(
                  title: "Continue...", 
                  onTap: () => authenticate(),
                ),
                const SizedBox(height: 21,),
                const Center(child: AppCircularProgressIndicator())
              ],
            ),
          ),
        ),
      )
    );
  }
  
  void authenticate() async{
    if (_formKey.currentState!.validate()) {
      setState(() {
        _continueClicked = true;
      });

      await AuthenticationServices.authenticate(codeController, context);

      setState(() {
        _continueClicked = false;
      });
    }
  }
}