import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/models/movie_trailer_model/movie_trailer_model.dart';
import 'package:movies/core/services/apis/api_manager.dart';
import 'package:movies/core/services/apis/api_result.dart';

class MovieTrailerViewModel extends BaseViewModel<VideoResult> {
  MovieTrailerViewModel() : super(viewState: LoadingState());

  Future<void> getMoveTrailer({required num movieId}) async {
    var result = await ApiManager.getMovieVideos(movieId);
    switch (result) {
      case Success<List<VideoResult>>():
        refreshWithState(
            SuccessState(data: _getTrailerVideo(result.data) ?? VideoResult()));
      case ServerError<List<VideoResult>>():
        refreshWithState(ErrorState(serverError: result));
      case CodeError<List<VideoResult>>():
        refreshWithState(ErrorState(codeError: result));
    }
  }

  VideoResult? _getTrailerVideo(List<VideoResult> videos) {
    var trailerVideos = videos.where(
      (element) {
        return element.type == "Trailer";
      },
    ).toList();
    if (trailerVideos.isEmpty) {
      return null;
    } else {
      var officialTrailer = trailerVideos.where(
        (element) {
          return element.name == "Official Trailer";
        },
      ).toList();
      if (officialTrailer.isNotEmpty) {
        return officialTrailer[0];
      } else {
        return trailerVideos[0];
      }
    }
  }
}
