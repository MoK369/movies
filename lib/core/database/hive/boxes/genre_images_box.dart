import 'package:hive_flutter/hive_flutter.dart';

class GenreImagesBox {
  static Box<List<String>> genreImagesBoxInstance =
      Hive.box<List<String>>("GenreImagesBox");

  static void writeGenreImagePaths(num genreId, List<String> twoImagePaths) {
    genreImagesBoxInstance.put(genreId, twoImagePaths);
  }

  static List<String>? readGenreImagePaths(num genreId) {
    return genreImagesBoxInstance.get(genreId);
  }
}
