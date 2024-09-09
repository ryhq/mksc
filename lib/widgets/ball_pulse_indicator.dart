
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BallPulseIndicator extends StatelessWidget {
  const BallPulseIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [
            Theme.of(context).colorScheme.primary,
            Colors.red,
            Colors.green,
          ],
          backgroundColor: Colors.transparent,
          pathBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}