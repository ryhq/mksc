import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: Theme.of(context).colorScheme.primary,);
  }
}