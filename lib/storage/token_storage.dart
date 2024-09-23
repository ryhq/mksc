import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Create an instance of FlutterSecureStorage to handle secure storage operations
  final FlutterSecureStorage _storedToken = const FlutterSecureStorage();

  // Store token securely
  Future<void> saveToken({required String tokenKey, required String token}) async {

    debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Saving Token  with $tokenKey as key : $token\n\n\n");

    // This method stores the token securely using Flutter Secure Storage.
    await _storedToken.write(key: tokenKey, value: token);
  }

  // Retrieve token asynchronously
  Future<String?> getToken({required String tokenKey}) async {
    // This method retrieves the stored token.
    return await _storedToken.read(key: tokenKey);
  }

  // Delete token
  Future<void> deleteToken({required String tokenKey}) async {
    // This method deletes the stored token when it's no longer needed.
    await _storedToken.delete(key: tokenKey);
  }

  // Retrieve  token synchronously (not truly synchronous but simplifies usage)
  Future<String?> getTokenSync({required String tokenKey}) async {
    // This method retrieves the stored  token and handles the Future internally.
    // This is still an async method and returns a Future.
    String? token = await _storedToken.read(key: tokenKey);
    // Return the retrieved token or null if not found
    return token;
  }

  // Retrieve token synchronously as a direct String
  Future<String> getTokenDirect({required String tokenKey}) async {
    // This method retrieves the stored  token and handles the Future internally.
    String? token = await _storedToken.read(key: tokenKey);
    // Return the retrieved token or an empty string if not found
    return token ?? '';
  }
}
