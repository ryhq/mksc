import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GreetingProvider with ChangeNotifier {
  final _random = Random();
  String _currentGreeting = '';
  Timer? _timer;

  GreetingProvider() {
    // Initialize the greeting based on current time when provider is created
    _currentGreeting = _getGreetingForCurrentTime();
    _startTimer();
  }

  // List of greetings for different times of the day
  final List<String> morningGreetings = [
    "Good Morning! Start your day with a smile.",
    "Rise and shine! It's a beautiful morning.",
    "Morning! Hope you have a fantastic day ahead.",
    "Top of the morning to you!",
    "Wishing you a refreshing morning.",
    "Good morning! Time to conquer the day.",
    "Wake up and smell the coffee, it's morning!"
  ];

  final List<String> afternoonGreetings = [
    "Good Afternoon! Keep pushing through.",
    "Hope your afternoon is as awesome as you are!",
    "Good Afternoon! Don't forget to take a break.",
    "Wishing you a productive afternoon.",
    "Keep going strong, it's afternoon!",
    "Good Afternoon! Hope you're having a fantastic day.",
    "Afternoon! A little more to go before the day is done."
  ];

  final List<String> eveningGreetings = [
    "Good Evening! Relax and unwind, you've earned it.",
    "Evening! Time to reflect on a great day.",
    "Good Evening! Hope you had a productive day.",
    "Wishing you a peaceful and restful evening.",
    "Good Evening! Time to relax and enjoy your evening.",
    "The evening is here, take it easy!",
    "Good Evening! Hope you're ready to wind down."
  ];

  final List<String> lateNightGreetings = [
    "Good Night! Sleep well.",
    "It's late, get some rest!",
    "Night! Time to recharge.",
    "Good Night! Tomorrow is another day.",
    "The night is young, but so are you!",
    "Sweet dreams and restful sleep.",
    "Rest well, it's midnight!"
  ];

  // Method to get current time's greeting based on the hour
  String _getGreetingForCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return morningGreetings[_random.nextInt(morningGreetings.length)];
    } else if (hour >= 12 && hour < 17) {
      return afternoonGreetings[_random.nextInt(afternoonGreetings.length)];
    } else if (hour >= 17 && hour < 24) {
      return eveningGreetings[_random.nextInt(eveningGreetings.length)];
    } else {
      return lateNightGreetings[_random.nextInt(lateNightGreetings.length)];
    }
  }
  
  // Timer to update the greeting every second
  void _startTimer() {
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      _currentGreeting = _getGreetingForCurrentTime();
      notifyListeners();  // Notify listeners so the UI updates
    });
  }

  // Method to fetch the current greeting (called in the UI)
  // String get currentGreeting {
  //   final now = DateTime.now();
  //   final minutesPastHour = now.minute;

  //   // Change greeting only at the start of a new hour
  //   if (minutesPastHour == 0) {
  //     _currentGreeting = _getGreetingForCurrentTime();
  //     notifyListeners();
  //   }

  //   return _currentGreeting;
  // }

  String get currentGreeting => _currentGreeting;

  // Dispose the timer when no longer needed
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
