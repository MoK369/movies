import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class MovieDetailsViewModel extends BaseViewModel<MovieDetailsModel> {
  MovieDetailsViewModel() : super(viewState: LoadingState());

  Future<void> getMovieDetails({required num movieId}) async {
    var result = await ApiManager.getMovieDetails(movieId);
    switch (result) {
      case Success<MovieDetailsModel>():
        refreshWithState(SuccessState(data: result.data));
      case ServerError<MovieDetailsModel>():
        refreshWithState(ErrorState(serverError: result));
      case CodeError<MovieDetailsModel>():
        refreshWithState(ErrorState(codeError: result));
    }
  }
}
