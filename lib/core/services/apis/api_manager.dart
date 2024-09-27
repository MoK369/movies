import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies/core/models/movie_credits_model/movie_credits_model.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/models/movie_genres_model/movie_genres_model.dart';
import 'package:movies/core/models/movie_release_dates/release_dates_model.dart';
import 'package:movies/core/models/movie_trailer_model/movie_trailer_model.dart';
import 'package:movies/core/models/popular_and_top_rated_movies/popular_and_top_rated_movies_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/models/upcoming_movies/upcoming_movies_model.dart';
import 'package:movies/core/services/apis/api_result.dart';

class ApiManager {
  static const String baseUrl = "api.themoviedb.org";

  static Future<ApiResult<List<Result>>> getPopularMovies() async {
    try {
      var url = Uri.https(baseUrl, EndPoints.popularEndPoint);
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      PopularAndTopRatedMoviesModel popularMoviesModel =
          PopularAndTopRatedMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: popularMoviesModel.results ?? []);
      } else {
        return ServerError(
            code: popularMoviesModel.statusCode ?? 0,
            message:
                popularMoviesModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<Result>>> getTopRatedMovies() async {
    try {
      var url = Uri.https(baseUrl, EndPoints.topRatedEndPoint);
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      PopularAndTopRatedMoviesModel topRatedMoviesModel =
          PopularAndTopRatedMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: topRatedMoviesModel.results ?? []);
      } else {
        return ServerError(
            code: topRatedMoviesModel.statusCode ?? 0,
            message:
                topRatedMoviesModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<ReleaseDateResult>>> getMovieReleaseDates(
      num movieId) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.getReleaseDatesEndPoint(movieId));
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      ReleaseDatesModel releaseDatesModel = ReleaseDatesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: releaseDatesModel.results ?? []);
      } else {
        return ServerError(
            code: releaseDatesModel.statusCode ?? 0,
            message:
                releaseDatesModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<MovieDetailsModel>> getMovieDetails(
      num movieId) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.getMovieDetailsEndPoint(movieId));
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      MovieDetailsModel movieDetailsModel = MovieDetailsModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: movieDetailsModel);
      } else {
        return ServerError(
            code: movieDetailsModel.statusCode ?? 0,
            message:
                movieDetailsModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<Result>>> getSimilarMovies(num movieId) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.getSimilarEndPoint(movieId));
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      PopularAndTopRatedMoviesModel popularAndTopRatedMoviesModel =
          PopularAndTopRatedMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: popularAndTopRatedMoviesModel.results ?? []);
      } else {
        return ServerError(
            code: popularAndTopRatedMoviesModel.statusCode ?? 0,
            message: popularAndTopRatedMoviesModel.statusMessage ??
                "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<PopularAndTopRatedMoviesModel>> searchForMovies(
      {required String query, int pageNumber = 1}) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.searchEndPoint,
          {"query": query, "page": "$pageNumber"});
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      PopularAndTopRatedMoviesModel popularAndTopRatedMoviesModel =
          PopularAndTopRatedMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: popularAndTopRatedMoviesModel);
      } else {
        return ServerError(
            code: popularAndTopRatedMoviesModel.statusCode ?? 0,
            message: popularAndTopRatedMoviesModel.statusMessage ??
                "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<VideoResult>>> getMovieVideos(
      num movieId) async {
    try {
      var url = Uri.https(
          baseUrl, EndPoints.getVideosEndPoint(movieId), {"language": "en-US"});
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      MovieTrailerModel movieTrailerModel = MovieTrailerModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: movieTrailerModel.videoResults ?? []);
      } else {
        return ServerError(
            code: movieTrailerModel.statusCode ?? 0,
            message:
                movieTrailerModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<Cast>>> getMovieCredits(num movieId) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.getMovieCreditsEndPoint(movieId),
          {"language": "en-US"});
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      MovieCreditsModel movieCreditsModel = MovieCreditsModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: movieCreditsModel.cast ?? []);
      } else {
        return ServerError(
            code: movieCreditsModel.statusCode ?? 0,
            message:
                movieCreditsModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<Result>>> getUpcomingMovies() async {
    try {
      var url = Uri.https(baseUrl, EndPoints.upcomingEndPoint);
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      UpcomingMoviesModel upcomingMoviesModel =
          UpcomingMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: upcomingMoviesModel.results ?? []);
      } else {
        return ServerError(
            code: upcomingMoviesModel.statusCode ?? 0,
            message:
                upcomingMoviesModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<List<MovieGenre>>> getMovieGenres() async {
    try {
      var url = Uri.https(baseUrl, EndPoints.genresEndPoint);
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      MovieGenresModel movieGenresModel = MovieGenresModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: movieGenresModel.genres ?? []);
      } else {
        return ServerError(
            code: movieGenresModel.statusCode ?? 0,
            message:
                movieGenresModel.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }

  static Future<ApiResult<PopularAndTopRatedMoviesModel>> getMoviesByGenreId(
      {required num genreId, int pageNumber = 1}) async {
    try {
      var url = Uri.https(baseUrl, EndPoints.discoverEndPoint, {
        "with_genres": "$genreId",
        "page": "$pageNumber",
        "sort_by": "popularity.desc"
      });
      var response = await http.get(url, headers: {
        "accept": "application/json",
        "Authorization": dotenv.env["API_KEY"]!,
      });
      var json = jsonDecode(response.body);
      PopularAndTopRatedMoviesModel model =
          PopularAndTopRatedMoviesModel.fromJson(json);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(data: model);
      } else {
        return ServerError(
            code: model.statusCode ?? 0,
            message: model.statusMessage ?? "Something Went Wrong 🤔");
      }
    } on Exception catch (e) {
      return CodeError(exception: e);
    }
  }
}

class EndPoints {
  static const String popularEndPoint = "/3/movie/popular";
  static const String upcomingEndPoint = "/3/movie/upcoming";
  static const String topRatedEndPoint = "/3/movie/top_rated";
  static const String searchEndPoint = "/3/search/movie";
  static const String genresEndPoint = "/3/genre/movie/list";
  static const String discoverEndPoint = "/3/discover/movie";

  static String getReleaseDatesEndPoint(num movieId) {
    return "/3/movie/$movieId/release_dates";
  }

  static String getMovieDetailsEndPoint(num movieId) {
    return "/3/movie/$movieId";
  }

  static String getSimilarEndPoint(num movieId) {
    return "/3/movie/$movieId/similar";
  }

  static String getVideosEndPoint(num movieId) {
    return "/3/movie/$movieId/videos";
  }

  static String getMovieCreditsEndPoint(num movieId) {
    return "/3/movie/$movieId/credits";
  }
}
