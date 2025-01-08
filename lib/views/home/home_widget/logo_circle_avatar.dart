
import 'package:flutter/material.dart';

class LogoCircleAvatar extends StatelessWidget {
  const LogoCircleAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.05;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: MediaQuery.of(context).size.width * 0.001,
        )
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: isPortrait ? (radius <= 28 ? 28 : radius >= 56 ? 56 : radius) : 14,
        backgroundImage: const AssetImage('assets/logo/MKSC_logo.png'),
      ),
    );
  }
}
