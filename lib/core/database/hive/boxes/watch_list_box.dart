import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies/core/models/result.dart';

class WatchListBox {
  static Box<Result> watchListBoxInstance = Hive.box<Result>("WatchList");
  static const int _cacheLimit = 100;

  static Future<HiveState<void>> saveToWatchList(
      num movieId, Result movieToSave) async {
    if (watchListBoxInstance.length >= _cacheLimit) {
      return FailureState(
          message: "You Have Exceeded $_cacheLimit bookmarked movies!");
    } else {
      await watchListBoxInstance.put(movieId, movieToSave);
      return SuccessState(data: null);
    }
  }

  static List<Result> readAllSavedMovie() {
    return watchListBoxInstance.values.toList();
  }

  static Result? readASavedMovie(num movieId) {
    return watchListBoxInstance.get(movieId);
  }

  static Future<void> removeASavedMovie(num movieId) {
    return watchListBoxInstance.delete(movieId);
  }
}

sealed class HiveState<T> {}

class SuccessState<T> extends HiveState<T> {
  T data;

  SuccessState({required this.data});
}

class FailureState<T> extends HiveState<T> {
  String message;

  FailureState({required this.message});
}
