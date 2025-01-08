

import 'package:flutter/material.dart';
import 'package:mksc/views/home/home_widget/greeting_text.dart';
import 'package:mksc/views/home/home_widget/logo_circle_avatar.dart';

class FlexibleSpaceBarRowContent extends StatelessWidget {
  const FlexibleSpaceBarRowContent({
    super.key,
    required this.greeting,
  });

  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const LogoCircleAvatar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: GreetingText(greeting: greeting),
            ),
          ),
        ],
      ),
    );
  }
}