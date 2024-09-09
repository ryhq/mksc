import 'package:intl/intl.dart';

class Utility {
  static String getInitials(String name) {
    if (name.contains(' ')) {
      List<String> nameParts = name.split(' ');
      String initials = nameParts[0][0] + nameParts[1][0];
      return initials;
    }else{
      return name[0];
    }
  }
  static String convertToHourMinute(String timeString) {
    // Parse the input time string to a DateTime object
    DateTime time = DateFormat('HH:mm:ss.SSSSSS').parse(timeString);

    // Format the DateTime object to the desired HH:mm format
    String formattedTime = DateFormat('HH:mm').format(time);

    return formattedTime;
  }
  
  static Duration convertToDuration(String time) {
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    return Duration(hours: hours, minutes: minutes);
  }
  /// Similar to the above

  static Duration convertToHHMMDuration(String timeString) {
    // Parse the input time string to a DateTime object
    DateTime time = DateFormat('HH:mm').parse(timeString);

    // Convert the DateTime object to a Duration
    Duration duration = Duration(hours: time.hour, minutes: time.minute);

    return duration;
  }

  static String sanitizeSecurityPhrase(String securityPhrase){
    securityPhrase = securityPhrase.trim();
    securityPhrase = securityPhrase.replaceAll(RegExp(r'\s+'), ' ');
    return securityPhrase.toLowerCase();
  }  

  static String formatTime(double value) {
    int minutes = value.toInt();
    if (minutes < 60) {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      int hours = minutes ~/ 60;
      minutes = minutes % 60;
      return '$hours hour${hours > 1 ? 's' : ''}${minutes > 0 ? ' $minutes minute${minutes > 1 ? 's' : ''}' : ''}';
    }
  }

  static String formatTimeFromSecond(int totalSeconds) {
    int days = totalSeconds ~/ 86400; // 86400 seconds in a day
    int hours = (totalSeconds % 86400) ~/ 3600; // 3600 seconds in an hour
    int minutes = (totalSeconds % 3600) ~/ 60; // 60 seconds in a minute
    int seconds = totalSeconds % 60;

    String daysStr = days > 0 ? '$days day${days != 1 ? 's' : ''} ' : '';
    String hoursStr = hours > 0 ? '$hours hour${hours != 1 ? 's' : ''} ' : '';
    String minutesStr = minutes > 0 ? '$minutes minute${minutes != 1 ? 's' : ''} ' : '';
    String secondsStr = seconds > 0 ? '$seconds second${seconds != 1 ? 's' : ''}' : '';

    return (daysStr + hoursStr + minutesStr + secondsStr).trim();
  }
  static String formatDurationAsddhhmmss(int totalSeconds) {
    // int days = totalSeconds ~/ 86400; // 86400 seconds in a day
    int hours = (totalSeconds % 86400) ~/ 3600; // 3600 seconds in an hour
    int minutes = (totalSeconds % 3600) ~/ 60; // 60 seconds in a minute
    int seconds = totalSeconds % 60;

    // String daysStr = days.toString().padLeft(2, '0');
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }



  // Method to transform the token
  static String obfuscate(String token, int visibleChars) {
    if (token.isEmpty) return "no data available";
    // int obfuscatedLength = token.length - visibleChars;
    return '(...)*****${token.substring(token.length - visibleChars)}';
    // return '*' * obfuscatedLength + token.substring(obfuscatedLength);
  }

  static String getRecursiveString(Map<String, dynamic> alarmRecursiveDays) {
    List<String> trueDays = alarmRecursiveDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.substring(0, 3))
        .toList();

    // Check for Everyday
    if (trueDays.length == 7) {
      return "Everyday";
    }

    // Check for Weekends
    bool isWeekend = alarmRecursiveDays["Sunday"] == true && alarmRecursiveDays["Saturday"] == true;
    bool isOnlyWeekend = isWeekend && trueDays.length == 2;
    if (isOnlyWeekend) {
      return "Weekends";
    }

    // Check for Weekdays
    bool isWeekdays = alarmRecursiveDays["Monday"] == true &&
        alarmRecursiveDays["Tuesday"] == true &&
        alarmRecursiveDays["Wednesday"] == true &&
        alarmRecursiveDays["Thursday"] == true &&
        alarmRecursiveDays["Friday"] == true;
    bool isOnlyWeekdays = isWeekdays && trueDays.length == 5;
    if (isOnlyWeekdays) {
      return "Weekdays";
    }

    // Otherwise, return the three-letter abbreviations
    return trueDays.join(", ");
  }

  
}

