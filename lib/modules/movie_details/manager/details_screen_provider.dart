import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/database/hive/boxes/template_colors_box.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/view_models/api_view_models/movie_details_view_model.dart';
import 'package:movies/core/view_models/api_view_models/movie_trailer_view_model.dart';
import 'package:movies/core/view_models/api_view_models/release_dates_view_model.dart';
import 'package:movies/core/view_models/api_view_models/similar_movies_view_model.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreenProvider extends ChangeNotifier {
  ReleaseDateViewModel releaseDateViewModel = ReleaseDateViewModel();
  MovieDetailsViewModel movieDetailsViewModel = MovieDetailsViewModel();
  SimilarMoviesViewModel similarMoviesViewModel = SimilarMoviesViewModel();
  MovieTrailerViewModel movieTrailerViewModel = MovieTrailerViewModel();

  bool isFullScreen = false;

  void changeIsFullScreenStatus(bool newStatus) {
    isFullScreen = newStatus;
    notifyListeners();
  }

  BaseViewState<List<Color>> paletteGeneratorState = LoadingState();
  List<Color> _colors = [];
  PaletteGenerator? paletteGenerator;

  Future<void> getPalettes(num movieId, String posterPath) async {
    try {
      List<Color>? cachedColors = TemplateColorsBox.readListOfColors(movieId);
      if (cachedColors != null) {
        _colors = cachedColors;
        paletteGeneratorState = SuccessState(data: _colors);
      } else {
        if (posterPath.isEmpty) {
          paletteGeneratorState = ErrorState();
        } else {
          paletteGenerator = await PaletteGenerator.fromImageProvider(
              NetworkImage(ImageUrl.getFullUrl(posterPath)),
              size: const Size(30, 40));
          _colors = [
            paletteGenerator?.dominantColor?.color ??
                AppThemes.darkPrimaryColor,
            paletteGenerator?.darkMutedColor?.color ??
                AppThemes.darkPrimaryColor,
            paletteGenerator?.darkVibrantColor?.color ??
                AppThemes.darkPrimaryColor,
            paletteGenerator?.vibrantColor?.color ?? AppThemes.darkPrimaryColor
          ];
          TemplateColorsBox.writeColors(movieId, _colors);
          paletteGeneratorState = SuccessState(data: _colors);
        }
      }
    } catch (e) {
      paletteGeneratorState = ErrorState();
    }
    notifyListeners();
  }

  String launchingUrlErrorMessage = "";

  Future<void> openYoutubeVideoLink(String videoKey) async {
    updateUrlErrorMessage("");
    Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (videoKey != "" && await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      updateUrlErrorMessage("Failed To Launch URL❗");
    }
  }

  void updateUrlErrorMessage(String newMessage) {
    launchingUrlErrorMessage = newMessage + DateTime.now().toString();
    notifyListeners();
  }
}
