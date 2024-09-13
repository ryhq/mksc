import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage('assets/logo/MKSC_Logo.jpg'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "MKSC Data Report",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                DateFormat('EEEE dd, MMMM yyyy').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}