import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/database/hive/boxes/watch_list_box.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/widgets/search_result_card.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends BaseView<WatchListPage> {
  List<Result> savedMovies = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    savedMovies = WatchListBox.readAllSavedMovie();
  }

  @override
  Widget build(BuildContext context) {
    return savedMovies.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 2.5,
                  child: Lottie.asset(
                      "assets/animations/empty_list_animation.json",
                      height: size.height * 0.33),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    textAlign: TextAlign.center,
                    "No Movies Saved In Watchlist",
                    style: theme.textTheme.labelMedium,
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListView.builder(
              itemCount: savedMovies.length,
              itemBuilder: (context, index) {
                return SearchResultCard(
                    onBookMarkClick: () {
                      setState(() {
                        savedMovies = WatchListBox.readAllSavedMovie();
                      });
                    },
                    movie: savedMovies[index]);
              },
            ),
          );
  }
}
