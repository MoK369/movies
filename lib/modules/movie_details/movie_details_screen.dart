import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/view_models/api_view_models/movie_credits_view_model.dart';
import 'package:movies/modules/movie_details/sections/date_rate_runtime_section.dart';
import 'package:movies/modules/movie_details/sections/more_like_this_section.dart';
import 'package:movies/modules/movie_details/sections/movie_description_section.dart';
import 'package:movies/modules/movie_details/sections/movies_cast_section.dart';
import 'package:movies/modules/movie_details/sections/production_companies_section.dart';
import 'package:movies/modules/movie_details/sections/title_and_link_section.dart';
import 'package:movies/modules/movie_details/sections/trailer_video_section.dart';
import 'package:provider/provider.dart';

import 'manager/details_screen_provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  static int numOfVisits = 0;
  static const routName = "MovieDetailsScreen";
  final Result movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends BaseView<MovieDetailsScreen> {
  DetailsScreenProvider detailsScreenProvider = DetailsScreenProvider();
  MovieCreditsViewModel movieCreditsViewModel = MovieCreditsViewModel();

  @override
  void initState() {
    super.initState();
    detailsScreenProvider.getPalettes(
        widget.movie.id ?? 0, widget.movie.posterPath ?? "");
    if (MovieDetailsScreen.numOfVisits < 2) {
      MovieDetailsScreen.numOfVisits++;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailsScreenProvider.releaseDateViewModel
        .getMovieReleaseDates(movieId: widget.movie.id ?? 0);
    detailsScreenProvider.movieDetailsViewModel
        .getMovieDetails(movieId: widget.movie.id ?? 0);
    movieCreditsViewModel.getMovieMainActors(widget.movie.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => detailsScreenProvider.releaseDateViewModel,
          ),
          ChangeNotifierProvider(
            create: (context) => detailsScreenProvider.movieDetailsViewModel,
          ),
          ChangeNotifierProvider(
            create: (context) => detailsScreenProvider.similarMoviesViewModel,
          ),
          ChangeNotifierProvider(
            create: (context) => detailsScreenProvider.movieTrailerViewModel,
          ),
          ChangeNotifierProvider(
            create: (context) => detailsScreenProvider,
          ),
          ChangeNotifierProvider(
            create: (context) => movieCreditsViewModel,
          ),
        ],
        child: Selector<DetailsScreenProvider, bool>(
          selector: (context, detailsScreenProvider) {
            return detailsScreenProvider.isFullScreen;
          },
          builder: (context, isFullScreen, child) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Selector<DetailsScreenProvider, BaseViewState<List<Color>>>(
                  selector: (context, detailsScreenProvider) =>
                      detailsScreenProvider.paletteGeneratorState,
                  builder: (context, paletteGeneratorState, child) {
                    List<Color> colorsToDisplay = [];
                    switch (paletteGeneratorState) {
                      case LoadingState():
                        colorsToDisplay = [
                          AppThemes.darkPrimaryColor,
                          AppThemes.darkPrimaryColor
                        ];
                        break;
                      case ErrorState():
                        colorsToDisplay = [
                          AppThemes.darkPrimaryColor,
                          AppThemes.darkPrimaryColor
                        ];
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) {
                            showInfoAlertDialog(
                                titleText: "Failed Extracting Colors",
                                durationInSeconds: 3);
                          },
                        );
                        break;
                      case SuccessState():
                        var extractedColors = paletteGeneratorState.data;
                        colorsToDisplay = extractedColors;
                    }
                    return Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: colorsToDisplay)));
                  },
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: isFullScreen
                      ? null
                      : AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                              onPressed: () {
                                MovieDetailsScreen.numOfVisits--;
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.white,
                              )),
                          title: Text(widget.movie.title ?? ""),
                          centerTitle: true,
                        ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        TrailerVideoSection(
                          movieTrailerViewModel:
                              detailsScreenProvider.movieTrailerViewModel,
                          detailsScreenProvider: detailsScreenProvider,
                          movie: widget.movie,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          child: Column(
                            children: [
                              TitleAndLinkSection(
                                movieTitle: widget.movie.title,
                                onTitleLongPress: (videoResult) {
                                  detailsScreenProvider.openYoutubeVideoLink(
                                      videoResult.key ?? "");
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DateRateRuntimeSection(
                                movieReleaseDate: widget.movie.releaseDate,
                                movieVote: widget.movie.voteAverage,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 30),
                                child: MovieDescriptionSection(
                                    movie: widget.movie),
                              ),
                              MoviesCastSection(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: ProductionCompaniesSection(),
                              ),
                              MoreLikeThisSection(
                                  movieId: widget.movie.id ?? 0,
                                  similarMoviesViewModel: detailsScreenProvider
                                      .similarMoviesViewModel),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  @override
  void dispose() {
    detailsScreenProvider.paletteGeneratorState = LoadingState();
    super.dispose();
  }
}
