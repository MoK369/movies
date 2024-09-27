import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class SimilarMoviesViewModel extends BaseViewModel<List<Result>> {
  SimilarMoviesViewModel() : super(viewState: LoadingState());

  Future<void> getSimilarMovies(num movieId) async {
    var result = await ApiManager.getSimilarMovies(movieId);
    switch (result) {
      case Success<List<Result>>():
        refreshWithState(SuccessState(data: result.data));
      case ServerError<List<Result>>():
        refreshWithState(ErrorState(serverError: result));
      case CodeError<List<Result>>():
        refreshWithState(ErrorState(codeError: result));
    }
  }
}
