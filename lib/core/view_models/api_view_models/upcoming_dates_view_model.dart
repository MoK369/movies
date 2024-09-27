import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class UpcomingMoviesViewModel extends BaseViewModel<List<Result>> {
  UpcomingMoviesViewModel() : super(viewState: LoadingState());

  Future<void> getUpcomingMovies() async {
    var result = await ApiManager.getUpcomingMovies();
    switch (result) {
      case Success<List<Result>>():
        refreshWithState(SuccessState(data: result.data));
      case ServerError<List<Result>>():
        refreshWithState(ErrorState(serverError: result));
      case CodeError<List<Result>>():
        refreshWithState(ErrorState(codeError: result));
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
