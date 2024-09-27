import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/widgets/custom_shimmer.dart';

class CustCachedNetworkImage extends StatelessWidget {
  final String? imagePath;
  final double? height, width;
  final BoxFit fit;

  const CustCachedNetworkImage(
      {super.key,
        required this.imagePath,
      this.height,
      this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        width: width,
        fit: fit,
        height: height,
        imageUrl: ImageUrl.getFullUrl(imagePath ?? ""),
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
    } on Exception {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
            )),
      );
    }
  }
}
