import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/database/hive/boxes/genre_images_box.dart';
import 'package:movies/core/models/movie_genres_model/movie_genres_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/discover_movies_view_model.dart';
import 'package:movies/core/widgets/search_result_card.dart';
import 'package:movies/modules/home/pages/browse_page/view_models/browse_page_view_model.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  static const String routeName = "DiscoverScreen";
  final DiscoverScreenWantedData data;

  const DiscoverScreen({super.key, required this.data});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends BaseView<DiscoverScreen> {
  late DiscoverMoviesViewModel discoverMoviesViewModel;

  bool newPathsHasBeenSaved = false;
  int cachePathsCounter = 0;

  @override
  void initState() {
    super.initState();
    discoverMoviesViewModel =
        DiscoverMoviesViewModel(genreId: widget.data.movieGenre.id ?? 0);
    discoverMoviesViewModel.viewState = LoadingState();
    discoverMoviesViewModel.getMoviesByGenreId();
    discoverMoviesViewModel.initReachingEndOfScrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => discoverMoviesViewModel,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.white,
                )),
            centerTitle: true,
            title: Text(
              widget.data.movieGenre.name ?? "",
              style: theme.textTheme.labelMedium,
            ),
          ),
          body: CustomViewModelConsumer<DiscoverMoviesViewModel, List<Result>>(
            shimmerWidth: size.width,
            shimmerHeight: size.height * 0.9,
            successFunction: (successState) {
              var movies = successState.data;
              if (cachePathsCounter == 0) {
                cacheImagePaths(movies);
              }

              return ListView.builder(
                controller: discoverMoviesViewModel.discoverListViewController,
                cacheExtent: 500,
                itemCount: discoverMoviesViewModel.didReachLastPage()
                    ? movies.length
                    : movies.length + 1,
                itemBuilder: (context, index) {
                  if (index == movies.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return SearchResultCard(movie: movies[index]);
                  }
                },
              );
            },
          )),
    );
  }

  void cacheImagePaths(List<Result> movies) {
    List<String> imagePathsToSave = [
      movies[0].posterPath ?? "",
      movies[1].posterPath ?? ""
    ];
    List<String> cachedPaths =
        GenreImagesBox.readGenreImagePaths(widget.data.movieGenre.id ?? 0) ??
            ["", ""];

    if ((imagePathsToSave[0] != cachedPaths[0]) &&
        (imagePathsToSave[1] != cachedPaths[1])) {
      GenreImagesBox.writeGenreImagePaths(
          widget.data.movieGenre.id ?? 0, imagePathsToSave);
      newPathsHasBeenSaved = true;
    } else {
      newPathsHasBeenSaved = false;
    }
    cachePathsCounter += 1;
  }

  @override
  void dispose() {
    if (newPathsHasBeenSaved) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          widget.data.browsePageViewModel.refreshForChanges();
        },
      );
    }
    super.dispose();
  }
}

class DiscoverScreenWantedData {
  final BrowsePageViewModel browsePageViewModel;
  final MovieGenre movieGenre;

  DiscoverScreenWantedData(
      {required this.browsePageViewModel, required this.movieGenre});
}
