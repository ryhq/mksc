import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/services/initiatial_services.dart';
import 'package:mksc/widgets/custom_alert.dart';

class HandleException {
  static void handleExceptions({required Exception exception, required BuildContext context, required String location}) {
    // Log the exception for debugging purposes
    debugPrint("🚨 Exception caught: $exception");

    // Handle specific types of exceptions
    if (exception is SocketException) {
      debugPrint("\n\n\n🚨🚨🚨Network error: Could not resolve hostname.\n$exception🚨🚨🚨 @$location\n\n\n");
      // No Internet connection or DNS failure
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error: Could not reach the server. Please check your internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (exception is TimeoutException) {
      // Request timed out
      if (context.mounted) {
      debugPrint("\n\n\n🚨🚨🚨Request timeout\n$exception\n🚨🚨🚨 @$location\n\n\n");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request timed out. Please try again later.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else if (exception is HttpException) {
      debugPrint("\n\n\n🚨🚨🚨HTTP error: Failed to retrieve the requested resource.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      // HTTP protocol error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('HTTP error: Failed to retrieve the requested resource.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (exception is FormatException) {
    // Data format or parsing error
    debugPrint("\n\n\n🚨🚨🚨 Format error: Invalid response format.\n$exception\n🚨🚨🚨 @$location\n\n\n");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data error: Invalid response format.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else if (exception is IOException) {
    // Input/Output error (e.g., file read/write)
    debugPrint("\n\n\n🚨🚨🚨 I/O error: File operation failed.\n$exception\n🚨🚨🚨 @$location\n\n\n");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File error: An issue occurred with file operations.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else if (exception is HandshakeException) {
    // Custom exception for handshake-related errors
    debugPrint("\n\n\n🚨🚨🚨 HandShake error: Failed due to .\n$exception\n🚨🚨🚨 @$location\n\n\n");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Handshake failed: Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else if (exception is RangeError) {
    // Handling out-of-range values (e.g., index out of range)
    debugPrint("\n\n\n🚨🚨🚨 Range error: Value out of range.\n$exception\n🚨🚨🚨 @$location\n\n\n");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Range error: A value was out of bounds.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
      debugPrint("\n\n\n🚨🚨🚨Error: $exception\n🚨🚨🚨 @$location\n\n\n");
      // Catch any other general exceptions
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static void handleExceptionsWithToast({required Exception exception, required String location}) {
    // Log the exception for debugging purposes
    debugPrint("🚨 Exception caught: $exception");

    // Handle specific types of exceptions
    if (exception is SocketException) {
      debugPrint("\n\n\n🚨🚨🚨Network error: Could not resolve hostname.\n$exception🚨🚨🚨 @$location\n\n\n");
      // No Internet connection or DNS failure
      _toast(
        msg: "Network error: Could not reach the server. Please check your internet connection.",
        color: Colors.red,
      );
    } else if (exception is TimeoutException) {
      // Request timed out
      debugPrint("\n\n\n🚨🚨🚨Request timeout\n$exception\n🚨🚨🚨 @$location\n\n\n");
      _toast(
        msg: "Request timed out. Please try again later.",
        color: Colors.orange,
      );
    } else if (exception is HttpException) {
      debugPrint("\n\n\n🚨🚨🚨HTTP error: Failed to retrieve the requested resource.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      // HTTP protocol error
      _toast(
        msg: "HTTP error: Failed to retrieve the requested resource.",
        color: Colors.red,
      );
    } else if (exception is FormatException) {
      // Data format or parsing error
      debugPrint("\n\n\n🚨🚨🚨 Format error: Invalid response format.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      _toast(
        msg: "Data error: Invalid response format.",
        color: Colors.red,
      );
    } else if (exception is IOException) {
      // Input/Output error (e.g., file read/write)
      debugPrint("\n\n\n🚨🚨🚨 I/O error: File operation failed.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      _toast(
        msg: "File error: An issue occurred with file operations.",
        color: Colors.red,
      );
    } else if (exception is HandshakeException) {
      // Custom exception for handshake-related errors
      debugPrint("\n\n\n🚨🚨🚨 Handshake error: Failed handshake.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      _toast(
        msg: "Handshake failed: Please try again.",
        color: Colors.red,
      );
    } else if (exception is RangeError) {
      // Handling out-of-range values (e.g., index out of range)
      debugPrint("\n\n\n🚨🚨🚨 Range error: Value out of range.\n$exception\n🚨🚨🚨 @$location\n\n\n");
      _toast(
        msg: "Range error: A value was out of bounds.",
        color: Colors.red,
      );
    } else {
      debugPrint("\n\n\n🚨🚨🚨Error: $exception\n🚨🚨🚨 @$location\n\n\n");
      // Catch any other general exceptions
      _toast(
        msg: "An unexpected error occurred. Please try again later.",
        color: Colors.red,
      );
    }
  }



  static void handleHttpError({
    required BuildContext context,
    required int statusCode,
    required String responseBody,
  }) {
    switch (statusCode) {
      case 400:
        CustomAlert.showAlert(context, "400 Error", "Bad request.");
        break;

      case 401:
        CustomAlert.showAlert(context, "401 Error", "Unauthorized access.\n${json.decode(responseBody)['error']}");
        break;

      case 403:
        CustomAlert.showAlert(context, "403 Error", "Access forbidden.");
        break;

      case 404:
        CustomAlert.showAlert(context, "404 Error", "Sorry, the requested content isn't available right now.");
        break;

      case 408:
        CustomAlert.showAlert(context, "408 Error", "Request timeout. The server took too long to respond.");
        break;

      case 409:
        CustomAlert.showAlert(context, "409 Error", "Conflict error. There is a conflict with the current state of the resource.");
        break;

      case 410:
        CustomAlert.showAlert(context, "410 Error", "The requested resource is no longer available.");
        break;

      case 422:
        CustomAlert.showAlert(context, "422 Error", "The server was unable to process the request because it contains invalid data\n${json.decode(responseBody)['message']}");
        break;

      case 429:
        CustomAlert.showAlert(context, "429 Error", "Too many requests. You have exceeded the rate limit.");
        break;

      case 500:
        CustomAlert.showAlert(context, "500 Error", "Internal server error. Please try again later.");
        break;

      case 502:
        CustomAlert.showAlert(context, "502 Error", "Bad gateway. The server received an invalid response.");
        break;

      case 503:
        CustomAlert.showAlert(context, "503 Error", "Service is unavailable. The server is temporarily unable to handle the request.");
        break;

      case 504:
        CustomAlert.showAlert(context, "504 Error", "Gateway timeout. The server took too long to respond.");
        break;

      case 508:
        CustomAlert.showAlert(context, "508 Error", "Resource limit reached. Please try again later.");
        break;

      default:
        CustomAlert.showAlert(
          context,
          "$statusCode Error",
          "An unexpected error occurred (Status code: $statusCode). $responseBody",
        );
        break;
    }
  }



  static Future<bool> checkConnectionAndInternet(BuildContext context) async {
    
    // Check for network connectivity (WiFi or mobile data)
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No network connection.'), backgroundColor: Colors.red,),
      );
      return false; 
    }

    // Check for internet access
    bool isConnectedToInternet = await InitiatialServices().checkInternetConnectionBool();
    if (!isConnectedToInternet) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet access. Please check your internet connection and try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false; // Return false when there's no internet access
    }

    // Both network connection and internet are available
    return true;
  }

  static Future<bool> checkConnectionAndInternetWithToast() async {
  
    // Check for network connectivity (WiFi or mobile data)
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _toast(msg: "No network connection.", color: Colors.red);
      return false; 
    }

    // Check for internet access
    bool isConnectedToInternet = await InitiatialServices().checkInternetConnectionBool();
    if (!isConnectedToInternet) {
      _toast(msg: "No internet access. Please check your connection and try again.", color: Colors.red);
      return false; // Return false when there's no internet access
    }

    // Both network connection and internet are available
    return true;
  }
  static void _toast({required String msg, required Color color}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } 
}