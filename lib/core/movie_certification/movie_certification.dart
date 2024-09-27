import 'package:movies/core/models/movie_release_dates/release_dates_model.dart';

class MovieCertification {
  static String getMovieCertification(List<ReleaseDate> releaseDates) {
    List<ReleaseDate> output = releaseDates.where(
      (element) {
        return element.certification != "";
      },
    ).toList();
    if (output.isNotEmpty) {
      return output[0].certification ?? "";
    } else {
      return "";
    }
  }
}
