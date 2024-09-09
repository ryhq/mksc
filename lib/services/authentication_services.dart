import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/view/data_categorization/data_categorization.dart';

class AuthenticationServices {
  static Future<void> authenticate(String categoryTitle, TextEditingController codeController, BuildContext context)async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return; 
    }
    
    Map<String, dynamic> authenticationCredential = {
      "code" : int.parse(codeController.text)
    };
    debugPrint("Authentication Credential $authenticationCredential");
    final Uri uri = Uri.parse("https://nethub.co.tz/demo/api/v2/auth/user");
    try {
      final http.Response response = await http.post(
        uri, 
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authenticationCredential),
      );

      debugPrint("Authentication Credential ${json.encode(authenticationCredential)}");
      debugPrint("Response status code ${response.statusCode}");
      debugPrint("Response body ${response.body}");
      debugPrint("Response bodyBytes ${response.bodyBytes}");
      debugPrint("Response contentLength ${response.contentLength}");
      debugPrint("Response isRedirect ${response.isRedirect}");
      debugPrint("Response persistentConnection ${response.persistentConnection}");
      debugPrint("Response reasonPhrase ${response.reasonPhrase}");
      
      if (response.statusCode == 200) {
        debugPrint("\n\n\nLogin successful...\n\n\n");
        if (!context.mounted) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => DataCategorization(categoryTitle: categoryTitle),));
      } else if(response.statusCode == 302 && context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry, The requested resource has been temporarily moved to a new location"))
        );
        if (!context.mounted) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => DataCategorization(categoryTitle: categoryTitle),));
      } else {
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login, may be invalid code...')),
        );        
      }
    } catch (e) {
      debugPrint("Error making authentication request: $e");
      if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;      
    }
  }
}