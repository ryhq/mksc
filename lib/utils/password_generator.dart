import 'dart:math';

class PasswordGenerator {
  static String generate(){
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%^&*()_}{';
    String password = String.fromCharCodes(Iterable.generate(12, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    // Check if the password meets the criteria
    while (
      !_isLengthValid(password) ||
      !_containsUppercase(password) ||
      !_containsLowercase(password) ||
      !_containsDigit(password) ||
      !_containsSpecialCharacter(password)
    ) {
      password = String.fromCharCodes(Iterable.generate(12, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    }
    return password;
  }



  static bool _isLengthValid(String value) {
    return value.length >= 12;
  }

  static bool _containsUppercase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  static bool _containsLowercase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  static bool _containsDigit(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  static bool _containsSpecialCharacter(String value) {
    return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}