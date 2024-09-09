import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationServices {
  static Future<void> authenticate(TextEditingController codeController, BuildContext context)async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return; 
    }
    
    Map<String, dynamic> authenticationCredential = {
      "Code" : int.parse(codeController.text)
    };
    final Uri uri = Uri.parse("https://nethub.co.tz/demo/api/v2/auth/user");
    try {
      final http.Response response = await http.post(
        uri, 
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authenticationCredential),
      );

      if (response.statusCode == 200) {
        debugPrint("\n\n\nLogin successful...\n\n\n");
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login, may be invalid code...')),
        );        
      }
    } catch (e) {
      debugPrint("Error making authentication request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;      
    }
  }
}