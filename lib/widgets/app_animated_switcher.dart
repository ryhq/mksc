import 'package:flutter/material.dart';

class AppAnimatedSwitcher extends StatefulWidget {
  const AppAnimatedSwitcher({
    super.key, 
    required this.show,
    required this.child, 
  });
  final Widget child;
  final bool show;

  @override
  State<AppAnimatedSwitcher> createState() => _AppAnimatedSwitcherState();
}

class _AppAnimatedSwitcherState extends State<AppAnimatedSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      reverseDuration: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: widget.show ? widget.child : const SizedBox.shrink(),
    );
  }
}