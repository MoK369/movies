import 'package:flutter/cupertino.dart';
import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/popular_and_top_rated_movies/popular_and_top_rated_movies_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class DiscoverMoviesViewModel extends BaseViewModel<List<Result>> {
  num genreId;

  DiscoverMoviesViewModel({required this.genreId})
      : super(viewState: LoadingState());
  int currentPageNumber = 1;
  final List<Result> _discoverMoviesList = [];
  int? totalPagesNumber;
  ScrollController discoverListViewController = ScrollController();

  Future<void> getMoviesByGenreId() async {
    var result = await ApiManager.getMoviesByGenreId(
        genreId: genreId, pageNumber: currentPageNumber);
    switch (result) {
      case Success<PopularAndTopRatedMoviesModel>():
        totalPagesNumber ??= (result.data.totalPages?.toInt()) ?? 0;
        _discoverMoviesList.addAll(result.data.results ?? []);
        refreshWithState(SuccessState(data: _discoverMoviesList));
        break;
      case ServerError<PopularAndTopRatedMoviesModel>():
        refreshWithState(ErrorState(serverError: result));
        break;
      case CodeError<PopularAndTopRatedMoviesModel>():
        refreshWithState(ErrorState(codeError: result));
        break;
    }
  }

  void initReachingEndOfScrollListener() {
    discoverListViewController.addListener(_listOnScroll);
  }

  void _listOnScroll() {
    if (discoverListViewController.position.pixels ==
        discoverListViewController.position.maxScrollExtent) {
      if (!didReachLastPage()) {
        currentPageNumber++;
        getMoviesByGenreId();
      }
    }
  }

  bool didReachLastPage() {
    return currentPageNumber >= (totalPagesNumber ?? 0);
  }
}
