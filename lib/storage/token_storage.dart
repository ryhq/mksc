import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mksc/model/auth_token.dart';

class TokenStorage {
  // Create an instance of FlutterSecureStorage to handle secure storage operations
  final FlutterSecureStorage _storedToken = const FlutterSecureStorage();

  // Store token securely
  Future<void> saveToken({
    required String tokenKey, 
    required AuthToken authToken,
  }) async {

    debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Saving Token  with $tokenKey as key : ${authToken.token}\n\n\n");

    debugPrint("\n\n\n ️‍🔥️‍🔥️‍🔥️‍🔥 Expires on ${authToken.expireAt}\n\n\n");

    // Combine token and expiry into a single JSON string
    String tokenData = jsonEncode({
      'token': authToken.token,
      'expires_at': authToken.expireAt.toIso8601String(),
    });

    // This method stores the token securely using Flutter Secure Storage.
    await _storedToken.write(key: tokenKey, value: tokenData);
  }

  // Retrieve token asynchronously
  Future<AuthToken> getToken({required String tokenKey}) async {

    String authTokenString = await _storedToken.read(key: tokenKey) ?? "";

    // This method retrieves the stored token.
    AuthToken authToken = authTokenString.isEmpty ? AuthToken.empty() : AuthToken.fromJson(jsonDecode(authTokenString));

    return authToken;
  }

  // Delete token
  Future<void> deleteToken({required String tokenKey}) async {
    // This method deletes the stored token when it's no longer needed.
    await _storedToken.delete(key: tokenKey);
  }

  // Retrieve  token synchronously (not truly synchronous but simplifies usage)
  Future<AuthToken> getTokenSync({required String tokenKey}) async {
    // This method retrieves the stored  token and handles the Future internally.
    // This is still an async method and returns a Future.

    String authTokenString = await _storedToken.read(key: tokenKey) ?? "";

    // This method retrieves the stored token.
    AuthToken authToken = authTokenString.isEmpty ? AuthToken.empty() : AuthToken.fromJson(jsonDecode(authTokenString));
    // Return the retrieved token or null if not found
    return authToken;
  }

  // Retrieve token synchronously as a direct String
  Future<AuthToken> getTokenDirect({required String tokenKey}) async {
    // This method retrieves the stored  token and handles the Future internally.
    // Return the retrieved token or an empty string if not found

    String authTokenString = await _storedToken.read(key: tokenKey) ?? "";

    // This method retrieves the stored token.
    AuthToken authToken = authTokenString.isEmpty ? AuthToken.empty() : AuthToken.fromJson(jsonDecode(authTokenString));

    return authToken;
  }
}
