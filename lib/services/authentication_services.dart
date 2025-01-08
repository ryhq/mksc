import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/chickenHouse/chicken_house_screen.dart';
import 'package:mksc/views/laundry/laundry_screen.dart';
import 'package:mksc/views/vegetables/vegetables_screen.dart';

class AuthenticationServices {

  static Future<void> authenticate(
    String categoryTitle, 
    BuildContext context, 
    {
      required String email,
      required String passwordCode
    }
  ) async {
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

          AuthToken authToken = AuthToken.fromJson(responseData);

          String camp = responseData['camp'];
        
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received token ${authToken.token}\n\n\n");

          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received camp $camp\n\n\n");
          
          TokenStorage tokenStorage = TokenStorage();
          
          await tokenStorage.saveToken(
            tokenKey: categoryTitle, 
            authToken: authToken,
          );

          if (!context.mounted) {
            return;
          }

          if (authToken.token.isEmpty) {
            return;
          }else{
            _navigate(categoryTitle : categoryTitle, token : authToken.token, context, camp: camp);
          }

        } else {

          final Map<String, dynamic> responseData = json.decode(response.body);

          final AuthToken receivedToken = AuthToken.fromJson(responseData);
          
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Received Token ${receivedToken.token}\n\n\n");
          
          TokenStorage tokenStorage = TokenStorage();
          
          debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Saving Token  with $categoryTitle as key : ${receivedToken.token}\n\n\n");

          await tokenStorage.saveToken(
            tokenKey: categoryTitle, 
            authToken: receivedToken,
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

      } else {
        debugPrint('\n\n\n🚨🚨🚨Unexpected status code: ${response.statusCode} with body: ${response.body}\n\n\n🚨🚨🚨');
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred during login.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white
              ),
            ), 
            backgroundColor: Colors.red,
          ),
        );        
      }
    }  on Exception catch (exception) {
      if(!context.mounted) return;
      HandleException.handleExceptions(
        context: context, 
        exception: exception, 
        location: "AuthenticationServices.authenticate"
      );
    }
  }

  

  static void _navigate(BuildContext context, {required String categoryTitle, required String token, String? camp,}){
    if(token.isNotEmpty && context.mounted){
      if (categoryTitle == "Chicken House") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChickenHouseScreen(categoryTitle: categoryTitle),));
      }
      if (categoryTitle == "Vegetables") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => VegetablesScreen(categoryTitle: categoryTitle,),));
      }
      if (categoryTitle == "Laundry") {
        Navigator.pop(context); // This ensures the authentication can be removed after navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => LaundryScreen(categoryTitle: categoryTitle, token: token, camp: camp!,),));
      }
    }
  }
}