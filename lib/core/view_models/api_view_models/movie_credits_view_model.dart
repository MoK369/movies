import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/movie_credits_model/movie_credits_model.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class MovieCreditsViewModel extends BaseViewModel<List<Cast>> {
  MovieCreditsViewModel() : super(viewState: LoadingState());

  Future<void> getMovieMainActors(num movieId) async {
    var result = await ApiManager.getMovieCredits(movieId);
    switch (result) {
      case Success<List<Cast>>():
        refreshWithState(SuccessState(data: result.data));
        break;
      case ServerError<List<Cast>>():
        refreshWithState(ErrorState(serverError: result));
        break;
      case CodeError<List<Cast>>():
        refreshWithState(ErrorState(codeError: result));
        break;
    }
  }
}
