import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/model/token.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/view/chickenHouse/chicken_house_screen.dart';
import 'package:mksc/view/laundry/laundry_screen.dart';
import 'package:mksc/view/vegetables/vegetables_screen.dart';
import 'package:mksc/widgets/custom_alert.dart';

class AuthenticationServices {

  static Future<void> authenticate(String categoryTitle, BuildContext context, {required String email,required String passwordCode}) async {
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternet(context);

    if (!isConnected) {
      return;
    }

    try {
    
      Map<String, dynamic> authenticationCredential = {
        "email": email,
        "password": passwordCode
      };

      final Uri uri = Uri.parse(MKSCUrls.authUrl);
      
      final http.Response response = await http.post(
        uri, 
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authenticationCredential),
      );
      
      if (response.statusCode == 200) {

        if (categoryTitle == "Laundry") {

          final Map<String, dynamic> responseData = json.decode(response.body);

          String token = responseData['token'];

          String camp = responseData['camp'];
        
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received token $token\n\n\n");

          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received camp $camp\n\n\n");
          
          TokenStorage tokenStorage = TokenStorage();
          
          await tokenStorage.saveToken(
            tokenKey: categoryTitle, 
            token: token
          );

          if (!context.mounted) {
            return;
          }

          if (token.isEmpty) {
            return;
          }else{
            _navigate(categoryTitle : categoryTitle, token : token, context, camp: camp);
          }

        } else {

          final Map<String, dynamic> responseData = json.decode(response.body);
          final Token receivedToken = Token.fromJson(responseData);
          
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received Token ${receivedToken.token}\n\n\n");
          
          TokenStorage tokenStorage = TokenStorage();
          
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Saving Token  with $categoryTitle as key : ${receivedToken.token}\n\n\n");

          await tokenStorage.saveToken(
            tokenKey: categoryTitle, 
            token: receivedToken.token
          ); // Saving the token

          if (!context.mounted) {
            return;
          }

          if (receivedToken.token.isEmpty) {
            return;
          }else{
            _navigate(categoryTitle : categoryTitle, token : receivedToken.token, context);
          }

        }

      } else if(response.statusCode == 302 && context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry, The requested resource has been temporarily moved to a new location"))
        );
      } else if(response.statusCode == 401 && context.mounted){
        CustomAlert.showAlert(context, "Failed", "Status code : ${response.statusCode}\nMessage : ${json.decode(response.body)['message']}");
      } else {
        debugPrint('\n\n\n🚨🚨🚨Unexpected status code: ${response.statusCode} with body: ${response.body}\n\n\n🚨🚨🚨');
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login, may be invalid code...'), backgroundColor: Colors.red,),
        );        
      }
    }  on Exception catch (exception) {
      if(!context.mounted) return;
      HandleException.handleExceptions(context: context, exception: exception, location: "");
    }
  }

  

  static void _navigate(BuildContext context, {required String categoryTitle, required String token, String? camp,}){
    if(token.isNotEmpty && context.mounted){
      if (categoryTitle == "Chicken House") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChickenHouseScreen(categoryTitle: categoryTitle, token: token,),));
      }
      if (categoryTitle == "Vegetables") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => VegetablesScreen(categoryTitle: categoryTitle, token: token,),));
      }
      if (categoryTitle == "Laundry") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => LaundryScreen(categoryTitle: categoryTitle, token: token, camp: camp!,),));
      }
    }
  }
}