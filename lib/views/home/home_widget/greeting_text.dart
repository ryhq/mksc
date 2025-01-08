
import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({
    super.key,
    required this.greeting,
  });

  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Text(
      greeting,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),
    );
  }
}