import 'package:flutter/material.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Provider.of<ThemeProvider>(context).fontSize + 7,
      height: Provider.of<ThemeProvider>(context).fontSize + 7,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}