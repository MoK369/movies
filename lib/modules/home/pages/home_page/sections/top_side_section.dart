import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/popular_movies_view_model.dart';
import 'package:movies/core/view_models/api_view_models/upcoming_dates_view_model.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/home/pages/home_page/widgets/top_side_section_stack.dart';

class TopSideSection extends StatefulWidget {
  final PopularMoviesViewModel popularMoviesViewModel;
  final UpcomingMoviesViewModel upcomingMoviesViewModel;

  const TopSideSection({
    super.key,
    required this.popularMoviesViewModel,
    required this.upcomingMoviesViewModel,
  });

  @override
  State<TopSideSection> createState() => _TopSideSectionState();
}

class _TopSideSectionState extends BaseView<TopSideSection> {
  @override
  void initState() {
    super.initState();
    widget.popularMoviesViewModel.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.42,
      child: CustomViewModelConsumer<PopularMoviesViewModel, List<Result>>(
        shimmerWidth: double.infinity,
        shimmerHeight: size.height * 0.36,
        showTextErrorInsteadOfIconError: false,
        errorIconSize: 35,
        successFunction: (successState) {
          var movies = successState.data;
          precacheMoviesImages(movies);
          return Column(
            children: [
              CarouselSlider.builder(
                  itemCount: successState.data.length,
                  itemBuilder: (context, index, realIndex) {
                    return TopSideSectionStack(
                      movie: movies[index],
                      onBookMarkClick: () {
                        widget.upcomingMoviesViewModel
                            .refreshDueToBookMarking(movies[index]);
                      },
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: true,
                      pauseAutoPlayOnManualNavigate: true,
                      autoPlayInterval: const Duration(seconds: 15),
                      autoPlayAnimationDuration: const Duration(seconds: 3),
                      autoPlayCurve: Curves.easeInOut,
                      height: size.height * 0.4,
                      viewportFraction: 1,
                      initialPage: 0)),
              // Todo: try to use ListView instead of CarouselSlider to get the benefits of cacheExtent
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: movies.length,
              //     itemExtent: size.width,
              //     scrollDirection: Axis.horizontal,
              //     cacheExtent: size.width * 6,
              //     physics: PageScrollPhysics(),
              //     itemBuilder: (context, index) {
              //             return TopSideSectionStack(
              //               movie: movies[index],
              //               onBookMarkClick: () {
              //                 widget.upcomingMoviesViewModel
              //                     .refreshDueToBookMarking(movies[index]);
              //               },
              //             );
              //     },
              //   ),
              // )
            ],
          );
        },
      ),
    );
  }

  void precacheMoviesImages(List<Result> movies) {
    for (var movie in movies) {
      if (movie.posterPath != null && movie.posterPath != "") {
        precacheImage(
            CachedNetworkImageProvider(ImageUrl.getFullUrl(movie.posterPath!)),
            context);
      }
      if (movie.backdropPath != null && movie.backdropPath != "") {
        precacheImage(
            CachedNetworkImageProvider(
                ImageUrl.getFullUrl(movie.backdropPath!)),
            context);
      }
    }
  }
}
