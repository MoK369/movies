import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class PopularMoviesViewModel extends BaseViewModel<List<Result>> {
  PopularMoviesViewModel() : super(viewState: LoadingState());

  Future<void> getPopularMovies() async {
    var apiResult = await ApiManager.getPopularMovies();

    switch (apiResult) {
      case Success<List<Result>>():
        refreshWithState(SuccessState(data: apiResult.data));
        break;
      case ServerError<List<Result>>():
        refreshWithState(ErrorState(serverError: apiResult));
        break;
      case CodeError<List<Result>>():
        refreshWithState(ErrorState(codeError: apiResult));
        break;
    }
  }

  void refreshDueToBookMarking(Result bookMarkedMovie) {
    var movieResults = (viewState as SuccessState<List<Result>>).data;
    if (doesMovieIdExist(movieResults, bookMarkedMovie)) {
      notifyListeners();
    }
  }

  bool doesMovieIdExist(List<Result> movieResults, Result bookMarkedMovie) {
    for (var movie in movieResults) {
      if (movie.id == bookMarkedMovie.id) {
        return true;
      }
    }
    return false;
  }
}
