import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Create an instance of FlutterSecureStorage to handle secure storage operations
  final FlutterSecureStorage _storedToken = const FlutterSecureStorage();

  // Store token securely
  Future<void> saveToken(String token) async {
    // This method stores the token securely using Flutter Secure Storage.
    await _storedToken.write(key: 'token', value: token);
  }

  // Retrieve token asynchronously
  Future<String?> getToken() async {
    // This method retrieves the stored token.
    return await _storedToken.read(key: 'token');
  }

  // Delete token
  Future<void> deleteToken() async {
    // This method deletes the stored token when it's no longer needed.
    await _storedToken.delete(key: 'token');
  }

  // Retrieve  token synchronously (not truly synchronous but simplifies usage)
  Future<String?> getTokenSync() async {
    // This method retrieves the stored  token and handles the Future internally.
    // This is still an async method and returns a Future.
    String? token = await _storedToken.read(key: 'token');
    // Return the retrieved token or null if not found
    return token;
  }

  // Retrieve token synchronously as a direct String
  Future<String> getTokenDirect() async {
    // This method retrieves the stored  token and handles the Future internally.
    String? token = await _storedToken.read(key: 'token');
    // Return the retrieved token or an empty string if not found
    return token ?? '';
  }
}
