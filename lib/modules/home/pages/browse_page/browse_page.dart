import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/database/hive/boxes/genre_images_box.dart';
import 'package:movies/core/models/movie_genres_model/movie_genres_model.dart';
import 'package:movies/core/view_models/api_view_models/movie_genres_view_model.dart';
import 'package:movies/modules/discover_screen/discover_screen.dart';
import 'package:movies/modules/home/pages/browse_page/view_models/browse_page_view_model.dart';
import 'package:movies/modules/home/pages/browse_page/widgets/genre_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:provider/provider.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({
    super.key,
  });

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends BaseView<BrowsePage> {
  MovieGenresViewModel movieGenresViewModel = MovieGenresViewModel();
  BrowsePageViewModel browsePageViewModel = BrowsePageViewModel();

  @override
  void initState() {
    super.initState();
    movieGenresViewModel.getMovieGenres();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => movieGenresViewModel),
        ChangeNotifierProvider(create: (context) => browsePageViewModel),
      ],
      child: CustomViewModelConsumer<MovieGenresViewModel, List<MovieGenre>>(
        shimmerWidth: size.width,
        shimmerHeight: size.height * 0.9,
        successFunction: (successState) {
          var genres = successState.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Browse Category",
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                Consumer<BrowsePageViewModel>(
                  builder: (context, browsePageViewModel, child) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: genres.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 125 / 175,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 40),
                        itemBuilder: (context, index) {
                          return GenreCard(
                              imageUrl: GenreImagesBox.readGenreImagePaths(
                                  genres[index].id ?? 0),
                              onGenreCardClick: () {
                                whenGenreCardClicked(genres[index]);
                              },
                              movieGenre: genres[index]);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void whenGenreCardClicked(MovieGenre movieGenre) {
    Navigator.pushNamed(context, DiscoverScreen.routeName,
        arguments: DiscoverScreenWantedData(
            browsePageViewModel: browsePageViewModel, movieGenre: movieGenre));
  }
}
