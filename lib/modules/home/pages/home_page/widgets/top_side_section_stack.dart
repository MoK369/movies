import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/extension_methods/string_extension_methods/string_extension_methods.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/movie_vote/movie_vote.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class TopSideSectionStack extends StatefulWidget {
  final Result movie;
  final VoidCallback? onBookMarkClick;

  const TopSideSectionStack({
    super.key,
    required this.movie,
    this.onBookMarkClick,
  });

  @override
  State<TopSideSectionStack> createState() => _TopSideSectionStackState();
}

class _TopSideSectionStackState extends BaseView<TopSideSectionStack> {
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(context, MovieDetailsScreen.routName,
            arguments: widget.movie);
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Hero(
            tag: widget.movie.id ?? 0,
            child: CustCachedNetworkImage(
                width: double.infinity,
                height: size.height * 0.27,
                imageUrl: ImageUrl.getFullUrl(widget.movie.backdropPath ?? "")),
          ),
          Positioned(
              top: (size.height * 0.25) / 2.5,
              child: Image.asset(
                "assets/icons/play-button_icon.png",
                scale: 4,
                color: Colors.white.withOpacity(0.8),
              )),
          Positioned(
            bottom: 15,
            left: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PosterCard(
                  posterWidth: size.width * 0.35,
                  posterHeight: (size.width * 0.33) * (195 / 125),
                  movie: widget.movie,
                  onBookMarkClick: widget.onBookMarkClick,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.movie.title ?? "",
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.movie.releaseDate?.getUsDateFormat() ?? "",
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Image.asset(
                              "assets/icons/star_icon.png",
                              scale: 2.2,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            MovieVote.getVoteAverage(
                                widget.movie.voteAverage ?? 0),
                            style: theme.textTheme.labelMedium!
                                .copyWith(fontSize: 13),
                          ),
                        ])
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
