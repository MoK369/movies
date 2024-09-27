import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/top_rated_movies_view_model.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class RecommendedSection extends StatefulWidget {
  final TopRatedMoviesViewModel topRatedMoviesViewModel;

  const RecommendedSection({
    super.key,
    required this.topRatedMoviesViewModel,
  });

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends BaseView<RecommendedSection> {
  @override
  void initState() {
    super.initState();
    widget.topRatedMoviesViewModel.getTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: (size.width * 0.67) * (127 / 96),
      color: const Color(0xFF282A28),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended", style: theme.textTheme.labelMedium),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: (size.width * 0.54) * (127 / 96),
            child:
            CustomViewModelConsumer<TopRatedMoviesViewModel, List<Result>>(
              shimmerWidth: size.width,
              shimmerHeight: size.height * 0.2,
              successFunction: (successState) {
                var movies = successState.data;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: PosterCard(
                        showBottomSection: true,
                        posterWidth: size.width * 0.35,
                        posterHeight: (size.width * 0.35) * (127 / 96),
                        shimmerWidth: size.width * 0.05,
                        shimmerHeight: size.height * 0.015,
                        movie: movies[index],
                        onPosterClick: () {
                          Navigator.pushNamed(
                              context, MovieDetailsScreen.routName,
                              arguments: movies[index]);
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
