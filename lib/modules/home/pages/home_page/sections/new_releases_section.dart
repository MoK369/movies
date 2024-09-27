import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/popular_movies_view_model.dart';
import 'package:movies/core/view_models/api_view_models/upcoming_dates_view_model.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class NewReleasesSection extends StatefulWidget {
  final UpcomingMoviesViewModel upcomingMoviesViewModel;
  final PopularMoviesViewModel popularMoviesViewModel;

  const NewReleasesSection(
      {super.key,
      required this.upcomingMoviesViewModel,
      required this.popularMoviesViewModel});

  @override
  State<NewReleasesSection> createState() => _NewReleasesSectionState();
}

class _NewReleasesSectionState extends BaseView<NewReleasesSection> {
  @override
  void initState() {
    super.initState();
    widget.upcomingMoviesViewModel.getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomViewModelConsumer<UpcomingMoviesViewModel, List<Result>>(
      shimmerWidth: size.width,
      shimmerHeight: size.height * 0.2,
      successFunction: (successState) {
        var movies = successState.data;
        return Container(
          width: size.width,
          height: (size.width * 0.5) * (125 / 95),
          color: const Color(0xFF282A28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("New Releases", style: theme.textTheme.labelMedium),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: PosterCard(
                          movie: movies[index],
                          posterWidth: size.width * 0.35,
                          posterHeight: (size.width * 0.35) * (125 / 95),
                          onPosterClick: () {
                            Navigator.pushNamed(
                                context, MovieDetailsScreen.routName,
                                arguments: movies[index]);
                          },
                          onBookMarkClick: () {
                            widget.popularMoviesViewModel
                                .refreshDueToBookMarking(movies[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
