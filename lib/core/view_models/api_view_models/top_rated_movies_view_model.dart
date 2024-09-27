import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class TopRatedMoviesViewModel extends BaseViewModel<List<Result>> {
  TopRatedMoviesViewModel() : super(viewState: LoadingState());

  Future<void> getTopRatedMovies() async {
    var result = await ApiManager.getTopRatedMovies();
    switch (result) {
      case Success<List<Result>>():
        return refreshWithState(SuccessState(data: result.data));
      case ServerError<List<Result>>():
        return refreshWithState(ErrorState(serverError: result));
      case CodeError<List<Result>>():
        return refreshWithState(ErrorState(codeError: result));
    }
  }
}
