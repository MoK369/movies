import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/similar_movies_view_model.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class MoreLikeThisSection extends StatefulWidget {
  final num movieId;
  final SimilarMoviesViewModel similarMoviesViewModel;

  const MoreLikeThisSection({
    super.key,
    required this.movieId,
    required this.similarMoviesViewModel,
  });

  @override
  State<MoreLikeThisSection> createState() => _MoreLikeThisSectionState();
}

class _MoreLikeThisSectionState extends BaseView<MoreLikeThisSection> {
  bool showMoreLikeThisSection = true;

  @override
  void initState() {
    super.initState();
    widget.similarMoviesViewModel.getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return !showMoreLikeThisSection
        ? SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: const Color(0xFF282A28).withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("More Like This", style: theme.textTheme.labelMedium),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height * 0.4,
                  child: CustomViewModelConsumer<SimilarMoviesViewModel,
                      List<Result>>(
                    shimmerWidth: size.width,
                    shimmerHeight: size.height * 0.4,
                    successFunction: (successState) {
                      var similarMovies = successState.data;
                      if (similarMovies.isEmpty) {
                        showMoreLikeThisSection = false;
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) {
                            setState(() {});
                          },
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMovies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: PosterCard(
                              showBottomSection: true,
                              posterWidth: size.width * 0.37,
                              posterHeight: (size.width * 0.35) * (127 / 96),
                              shimmerWidth: size.width * 0.05,
                              shimmerHeight: size.height * 0.015,
                              movie: similarMovies[index],
                              onPosterClick: () {
                                MovieDetailsScreen.numOfVisits < 2
                                    ? Navigator.pushNamed(
                                        context, MovieDetailsScreen.routName,
                                        arguments: similarMovies[index])
                                    : Navigator.pushReplacementNamed(
                                        context, MovieDetailsScreen.routName,
                                        arguments: similarMovies[index]);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
