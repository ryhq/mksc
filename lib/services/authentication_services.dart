import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/model/token.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/view/data_categorization/data_categorization.dart';
import 'package:mksc/widgets/custom_alert.dart';

class AuthenticationServices {
  static Future<void> authenticate(
    String categoryTitle, 
    BuildContext context, 
    {
      required String email,
      required String passwordCode
    }
  ) async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return; 
    }
    
    Map<String, dynamic> authenticationCredential = {
      "email": email,
      "password": passwordCode
    };

    debugPrint("Authentication Credential $authenticationCredential");

    final Uri uri = Uri.parse("https://nethub.co.tz/demo/api/v2/auth/user");
    try {
      final http.Response response = await http.post(
        uri, 
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authenticationCredential),
      );

      // debugPrint("Authentication Credential JSON ${json.encode(authenticationCredential)}");
      // debugPrint("Response status code ${response.statusCode}");
      // debugPrint("Response body ${response.body}");
      // debugPrint("Response bodyBytes ${response.bodyBytes}");
      // debugPrint("Response contentLength ${response.contentLength}");
      // debugPrint("Response isRedirect ${response.isRedirect}");
      // debugPrint("Response persistentConnection ${response.persistentConnection}");
      // debugPrint("Response reasonPhrase ${response.reasonPhrase}");
      
      if (response.statusCode == 200) {
        debugPrint("\n\n\nLogin successful...\n\n\n");

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => DataCategorization(categoryTitle: categoryTitle),));

      } else if(response.statusCode == 302 && context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry, The requested resource has been temporarily moved to a new location"))
        );
      } else if(response.statusCode == 401 && context.mounted){
        CustomAlert.showAlert(context, "Failed", "${json.decode(response.body)['message']}");
      } else {
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login, may be invalid code...')),
        );        
      }
    } on SocketException catch (_) {
      // Handle network issues (e.g., no internet, DNS failures)
      debugPrint("Network error: Could not resolve hostname.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error: Could not reach the server. Please check your internet connection.')),
        );
      }
    } on TimeoutException catch (_) {
      // Handle request timeout
      debugPrint("Request timeout");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request timed out. Please try again later.')),
        );
      }
    } on HttpException catch (_) {
      // Handle HTTP protocol errors
      debugPrint("HTTP error: Failed to retrieve the requested resource.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('HTTP error: Unable to connect to the server.')),
        );
      }
    } catch (e) {
      // Handle any other errors
      debugPrint("Error during authentication request: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred during authentication.')),
        );
      }
      rethrow;
    }
  }
}