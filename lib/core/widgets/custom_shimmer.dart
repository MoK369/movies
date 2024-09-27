import 'package:flutter/material.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double? width, height;
  final Color baseColor, highlightColor;

  const CustomShimmer(
      {super.key,
      required this.width,
      required this.height,
      this.baseColor = AppThemes.darkSecondaryColor,
      this.highlightColor = const Color(0xFF757575)});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        loop: 5,
        period: const Duration(seconds: 1),
        direction: ShimmerDirection.ttb,
        child: Container(
          color: baseColor.withOpacity(0.6),
          width: width,
          height: height,
        ));
  }
}
