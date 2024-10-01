import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mksc/utils/color_utility.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidgets extends StatelessWidget {
  final int totalShimmers;
  const ShimmerWidgets({super.key, required this.totalShimmers});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final double maxHeight = MediaQuery.of(context).size.height * 0.3;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: List.generate(totalShimmers, (index) {
            // Generate a random height between 50% and 100% of maxHeight
            double randomHeight = maxHeight * (0.5 + random.nextDouble() * 0.5);

            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: randomHeight, // Apply the random height here
                    child: Shimmer.fromColors(
                      baseColor: ColorUtils.calculateSecondaryColor(primaryColor: Theme.of(context).colorScheme.primary),
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
              ],
            );
          }),
        ),
      ),
    );
  }
}
