class AuthToken {
  final String token;
  final DateTime expireAt;

  AuthToken({
    required this.token,
    required this.expireAt,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    try {
      return AuthToken(
        token: json['token'] ?? "", // Fallback to an empty string if 'token' is null
        expireAt: json['expires_at'] != null 
            ? DateTime.parse(json['expires_at']) // Parse ISO string to DateTime
            : DateTime.now().add(const Duration(days: 1)), // Fallback to a default expiry
      );
    } catch (e) {
      // Handle parsing errors and return a default AuthToken
      return AuthToken(
        token: "", // Default token value
        expireAt: DateTime.now().add(const Duration(days: 1)), // Default expiry
      );
    }
  }
  
  factory AuthToken.fromJson2(Map<String, dynamic> json) {
    try {
      // Check if the 'expires_at' field is already a DateTime or a string
      final expireAt = json['expires_at'] is DateTime
          ? json['expires_at'] as DateTime // If it's already DateTime, use it directly
          : json['expires_at'] != null
              ? DateTime.parse(json['expires_at']) // If it's a string, parse it
              : DateTime.now().add(const Duration(days: 1)); // Default expiration if null

      return AuthToken(
        token: json['token'] ?? "", // Fallback to an empty string if 'token' is null
        expireAt: expireAt, // Set the expiration time
      );
    } catch (e) {
      // Handle parsing errors and return a default AuthToken
      return AuthToken(
        token: "", // Default token value
        expireAt: DateTime.now().add(const Duration(days: 1)), // Default expiry
      );
    }
  }


  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "expires_at": expireAt.toIso8601String(), // Convert DateTime to ISO string
    };
  }

  AuthToken copyWith({
    String? token,
    DateTime? expireAt,
  }) {
    return AuthToken(
      token: token ?? this.token,
      expireAt: expireAt ?? this.expireAt,
    );
  }

  static AuthToken empty() {
    return AuthToken(
      token: '',
      expireAt: DateTime.now().add(const Duration(days: 1)),
    );
  }
}
