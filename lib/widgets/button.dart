import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Button extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool? vibrate;
  final bool? danger;

  const Button({
    super.key, 
    required this.title, 
    required this.onTap, 
    this.vibrate = true, 
    this.danger = false,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _vibrationTimer;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);

    _startVibrationTimer();
  }
  
  // A method to set up a timer to stop and restart the animation every 7 seconds

  
  void _startVibrationTimer() {
    _vibrationTimer = Timer(const Duration(seconds: 7), () {
      if (mounted) {  // Check if the widget is still mounted before running the animation
        _controller.forward(from: 0.0);
        _startVibrationTimer();
      }
    });
  }
  @override
  void dispose() {
    _vibrationTimer?.cancel();  // Cancel the timer if the widget is disposed
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap:widget.onTap,
      child: widget.danger! || !widget.vibrate! ?
      Container(
        decoration: BoxDecoration(
          color: widget.danger! ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(21)
        ),
        padding:  EdgeInsets.all( Provider.of<ThemeProvider>(context).fontSize),
        child: Center(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)
          ),
        ),
      ):
      AnimatedBuilder(
        animation:  _animation, 
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(21)
              ),
              padding:  EdgeInsets.all( Provider.of<ThemeProvider>(context).fontSize),
              child: Center(
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)
                ),
              ),
            ),
          );
        },
      )
    );
  }
}