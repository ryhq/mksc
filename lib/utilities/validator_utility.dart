import 'package:intl_phone_field/phone_number.dart';

class ValidatorUtility {
  static String? validateRequiredField(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }


  // Validate email with custom message
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email";
    }
    // Email regular expression pattern
    final RegExp emailRegExp = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    if (!emailRegExp.hasMatch(value)) {
      return "Invalid Email";
    }
    return null;
  }

  // Validate URL
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a URL";
    }
    
    // URL regular expression pattern
    final RegExp urlRegExp = RegExp(
      r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})(\/\S*)?$',
    );
    
    if (!urlRegExp.hasMatch(value)) {
      return "Invalid URL";
    }
    
    return null;
  }


  // Validate full name with at least two words
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Name";
    }
    // Check if the input contains at least two words
    final RegExp fullNameRegExp = RegExp(r'^\s*\S+\s+\S+.*$');
    if (!fullNameRegExp.hasMatch(value)) {
      return "Please enter your full Name";
    }
    return null;
  }
  
  static String? validateRealPhoneNumber(PhoneNumber? phoneNumber) {
    if (
      phoneNumber == null || 
      phoneNumber.number.isEmpty || 
      phoneNumber.countryISOCode.isEmpty || 
      phoneNumber.completeNumber.isEmpty || 
      phoneNumber.countryCode.isEmpty
    ) {
      return 'Phone number is required';
    }

    // Remove all non-numeric characters
    String cleanedPhone = phoneNumber.number.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the cleaned phone number is exactly 9 digits long
    if (cleanedPhone.length != 9) {
      return 'Phone number must be exactly 9 digits';
    }

    return null; // Validation passed
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-numeric characters
    String cleanedPhone = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the cleaned phone number is exactly 10 digits long
    if (cleanedPhone.length != 9) {
      return 'Phone number must be exactly 9 digits\nDo not start with 0';
    }

    // Check if the phone number starts with '07', '06', or '08'
    if (!(cleanedPhone.startsWith('7') ||
          cleanedPhone.startsWith('6') ||
          cleanedPhone.startsWith('8'))) {
      return 'Phone number must start with 7, 6, or 8';
    }

    return null;
  }
  
  static String? validateTIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'TIN number is required';
    }

    // Remove all non-numeric characters
    String cleanedTIN = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the cleaned phone number is exactly 10 digits long
    if (cleanedTIN.length != 9) {
      return 'TIN number must be exactly 9 digits';
    }

    return null;
  }
  
  // Validate VRN number with custom message
  static String? validateVRN(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter VRN number";
    }
    // VRN regular expression pattern for both formats
    final RegExp vrnRegExp = RegExp(
      r'^(\d{8}[A-Z])$',
    );
    // final RegExp vrnRegExp = RegExp(
    //   r'^(\d{2}-\d{6}-[A-Z]|\d{8}[A-Z])$',
    // );

    if (!vrnRegExp.hasMatch(value)) {
      return "Invalid VRN number";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check if the password meets the criteria
    if (!_isLengthValid(value) ||
        !_containsUppercase(value) ||
        !_containsLowercase(value) ||
        !_containsDigit(value) ||
        !_containsSpecialCharacter(value)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
    }

    return null;
  }
  
  static String? validateComfirmPassword(String? value, String? password) {
    if (value != password) {
      return 'Password Mismatched';
    }
    return null;
  }

  static bool _isLengthValid(String value) {
    return value.length >= 8;
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

  static String? validatePortNumber(String? value){
    // Check if the input string is not empty and not a number 
    if(value!.isEmpty || int.tryParse(value) == null){
      return "Please enter the server's port number";
    }

    // Convert the input string to an integer

    int portNumber = int.parse(value);

    // Check if the port number is within the valid range 0 - 65535

    if (portNumber < 0 || portNumber > 65535) {
      return "Port number must always range from 0 to 65535";
    }

    return null;
    // If all checks are pass, the port number is valid
  }

  static String? validateIPv4(String? ip) {
    // Regular expression to match a valid IPv4 address
    final regExp = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'
    );

    // Check if the IP address matches the regular expression
    if (!regExp.hasMatch(ip!)) {
      return "Invalid IPv4 (IP Address) Format";
    }

    // Split the IP address into its octets
    final octets = ip.split('.');

    // Check for leading zeros
    for (var octet in octets) {
      if (octet.length > 1 && octet.startsWith('0')) {
        return "Invalid IPv4 (IP Address) Format";
      }
    }

    // Parse each octet to an integer and check range (0-255)
    for (var octet in octets) {
      final value = int.parse(octet);
      if (value < 0 || value > 255) {
        return "Invalid IPv4 (IP Address) Format, octets must range from 0 to 255";
      }
    }

    // Check for reserved addresses
    final firstOctet = int.parse(octets[0]);
    // final secondOctet = int.parse(octets[1]);

    // Check if it's a loopback address (127.0.0.0/8)
    if (firstOctet == 127) {
      return "Loopback Address are not accepted";
    }

    // Check if it's a private address
    // if ((firstOctet == 10) ||
    //     (firstOctet == 172 && (secondOctet >= 16 && secondOctet <= 31)) ||
    //     (firstOctet == 192 && secondOctet == 168)) {
    //   return false;
    // }

    // If all checks passed, the IP address is valid
    return null;
  }
}