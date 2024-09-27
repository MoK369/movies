import 'package:flutter/material.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/movie_credits_model/movie_credits_model.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';

class CastCard extends StatelessWidget {
  final Cast cast;
  final double profileImageWidth, profileImageHeight;

  const CastCard(
      {super.key,
      required this.cast,
      required this.profileImageWidth,
      required this.profileImageHeight});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: CustCachedNetworkImage(
            fit: BoxFit.fill,
            width: profileImageWidth,
            height: profileImageHeight,
            imageUrl: ImageUrl.getFullUrl(cast.profilePath ?? ""),
          ),
        ),
        Container(
          width: profileImageWidth,
          height: (profileImageHeight) / 1.1,
          decoration: const BoxDecoration(
              color: Color(0xFF343534),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    cast.name ?? "",
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "Dept: ${cast.knownForDepartment ?? ""}",
                  style: theme.textTheme.labelMedium!.copyWith(fontSize: 10),
                ),
                Text(
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  "Played Character:\n  ${cast.character ?? ""}",
                  style: theme.textTheme.labelMedium!.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
