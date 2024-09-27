import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/extension_methods/string_extension_methods/string_extension_methods.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/movie_credits_view_model.dart';
import 'package:movies/core/widgets/movie_vote_number_row.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class SearchResultCard extends StatefulWidget {
  final VoidCallback? onBookMarkClick;
  final Result movie;

  const SearchResultCard(
      {super.key, required this.movie, this.onBookMarkClick});

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends BaseView<SearchResultCard> {
  final MovieCreditsViewModel movieCreditsViewModel = MovieCreditsViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieCreditsViewModel.getMovieMainActors(widget.movie.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(context, MovieDetailsScreen.routName,
            arguments: widget.movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PosterCard(
                      onBookMarkClick: widget.onBookMarkClick,
                      posterWidth: size.width * 0.35,
                      posterHeight: (size.width * 0.33) * (110 / 70),
                      movie: widget.movie),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title ?? "",
                          style: theme.textTheme.labelSmall!
                              .copyWith(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (widget.movie.releaseDate?.getUsDateFormat()) ?? "",
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MovieVoteNumberRow(
                            movieVoteNumber: widget.movie.voteAverage)
                      ]),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
