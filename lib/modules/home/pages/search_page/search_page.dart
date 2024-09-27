import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/movies_search_view_model.dart';
import 'package:movies/core/widgets/search_result_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BaseView<SearchPage> {
  TextEditingController searchController = TextEditingController();
  MoviesSearchViewModel moviesSearchViewModel = MoviesSearchViewModel();
  String oldSearchQuery = "";
  bool isSearchClicked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesSearchViewModel.initReachingEndOfScrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => moviesSearchViewModel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: TextField(
              controller: searchController,
              autocorrect: true,
              cursorColor: Colors.white,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              onSubmitted: (value) {
                whenSearchClick(searchController.text);
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: IconButton(
                    onPressed: () {
                      whenSearchClick(searchController.text);
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 25,
                    )),
              ),
            ),
          ),
          Visibility(
            visible: !isSearchClicked,
            child: Expanded(
              child: Center(
                  child: Lottie.asset("assets/animations/movie_animation2.json",
                      width: size.width * 0.55)),
            ),
          ),
          Visibility(
              visible: isSearchClicked,
              child: Expanded(
                child: CustomViewModelConsumer<MoviesSearchViewModel,
                    List<Result>>(
                  showAnimationWhenLoading: true,
                  animationPath: "assets/animations/searching_animation.json",
                  animationWidth: size.width * 0.55,
                  successFunction: (successState) {
                    var movies = successState.data;
                    return movies.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Lottie.asset(
                                      "assets/animations/no_search_result.json",
                                      width: size.width * 0.55)),
                              Text(
                                "No Movies Found",
                                style: theme.textTheme.labelSmall!
                                    .copyWith(fontSize: 20),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Results: ${moviesSearchViewModel.totalResults}",
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: ListTile(
                                      onTap: () {
                                        whenClearResultsClicked();
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      title: Text(
                                        "Clear Results",
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      trailing: const Icon(
                                        Icons.clear_all,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: moviesSearchViewModel
                                      .searchedMoviesListViewController,
                                  itemCount:
                                      moviesSearchViewModel.didReachLastPage()
                                          ? movies.length
                                          : movies.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == movies.length) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else {
                                      return SearchResultCard(
                                          movie: movies[index]);
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ))
        ],
      ),
    );
  }

  void whenSearchClick(String query) {
    if (searchController.text.trim().isNotEmpty) {
      if (oldSearchQuery != searchController.text) {
        setState(() {
          oldSearchQuery = searchController.text;
          moviesSearchViewModel.viewState = LoadingState();
          isSearchClicked = true;
          moviesSearchViewModel.searchForMovies(query);
          FocusManager.instance.primaryFocus?.unfocus();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Search Field is Empty",
        style: theme.textTheme.labelSmall!.copyWith(fontSize: 20),
      )));
    }
  }

  void whenClearResultsClicked() {
    setState(() {
      moviesSearchViewModel.clearAllSearchData();
      isSearchClicked = false;
      searchController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
