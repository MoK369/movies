import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/movie_genres_model/movie_genres_model.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class MovieGenresViewModel extends BaseViewModel<List<MovieGenre>> {
  MovieGenresViewModel() : super(viewState: LoadingState());

  Future<void> getMovieGenres() async {
    var result = await ApiManager.getMovieGenres();
    switch (result) {
      case Success<List<MovieGenre>>():
        refreshWithState(SuccessState(data: result.data));
        break;
      case ServerError<List<MovieGenre>>():
        refreshWithState(ErrorState(serverError: result));
        break;
      case CodeError<List<MovieGenre>>():
        refreshWithState(ErrorState(codeError: result));
        break;
    }
  }
}
