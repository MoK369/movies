import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/movie_release_dates/release_dates_model.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class ReleaseDateViewModel extends BaseViewModel<ReleaseDateResult> {
  ReleaseDateViewModel() : super(viewState: LoadingState());

  Future<void> getMovieReleaseDates({required num movieId}) async {
    var result = await ApiManager.getMovieReleaseDates(movieId);
    switch (result) {
      case Success<List<ReleaseDateResult>>():
        var usReleaseDate = result.data.where(
          (element) {
            return element.iso31661 == "US";
          },
        ).toList();
        refreshWithState(SuccessState(
            data: usReleaseDate.isNotEmpty
                ? usReleaseDate[0]
                : ReleaseDateResult()));
        break;
      case ServerError<List<ReleaseDateResult>>():
        refreshWithState(ErrorState(serverError: result));
      case CodeError<List<ReleaseDateResult>>():
        refreshWithState(ErrorState(codeError: result));
    }
  }
}
