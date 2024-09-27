import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/popular_and_top_rated_movies/popular_and_top_rated_movies_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class MoviesSearchViewModel extends BaseViewModel<List<Result>> {
  MoviesSearchViewModel() : super(viewState: LoadingState());

  String currentQuery = "";
  ScrollController searchedMoviesListViewController = ScrollController();
  final List<Result> _searchedMoviesList = [];
  int currentPageNumber = 1;
  int? totalPagesNumber, totalResults;

  Future<void> searchForMovies(String query) async {
    if (currentQuery == "") {
      currentQuery = query;
    }
    if (currentQuery != query) {
      clearAllSearchData();
      currentQuery = query;
    }
    var result = await ApiManager.searchForMovies(
        query: currentQuery, pageNumber: currentPageNumber);
    switch (result) {
      case Success<PopularAndTopRatedMoviesModel>():
        totalPagesNumber ??= (result.data.totalPages?.toInt()) ?? 0;
        totalResults ??= (result.data.totalResults?.toInt()) ?? 0;

        _searchedMoviesList.addAll(result.data.results ?? []);
        refreshWithState(SuccessState(data: _searchedMoviesList));
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
    searchedMoviesListViewController.addListener(_listenOnScroll);
  }

  void _listenOnScroll() {
    if (searchedMoviesListViewController.position.pixels ==
        searchedMoviesListViewController.position.maxScrollExtent) {
      if (!didReachLastPage()) {
        currentPageNumber++;
        searchForMovies(currentQuery);
      }
    }
  }

  bool didReachLastPage() {
    return currentPageNumber >= (totalPagesNumber ?? 0);
  }

  void clearAllSearchData() {
    viewState = LoadingState();
    currentQuery = "";
    _searchedMoviesList.clear();
    currentPageNumber = 1;
    totalResults = totalPagesNumber = null;
  }
}
