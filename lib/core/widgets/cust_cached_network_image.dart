import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/widgets/custom_shimmer.dart';

class CustCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height, width;
  final BoxFit fit;

  const CustCachedNetworkImage(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      fit: fit,
      height: height,
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, progress) =>
          CustomShimmer(width: width, height: height),
      errorWidget: (context, url, error) {
        return const Center(
            child: Icon(
          Icons.error_outline,
          color: Colors.white,
        ));
      },
    );
  }
}
