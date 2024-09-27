import 'package:movies/core/models/result.dart';

class UpcomingMoviesModel {
  num? statusCode;
  String? statusMessage;
  bool? success;
  Dates? dates;
  List<Result>? results;
  num? page, totalPages, totalResults;

  UpcomingMoviesModel(
      {this.statusCode,
      this.statusMessage,
      this.success,
      this.dates,
      this.results,
      this.page,
      this.totalPages,
      this.totalResults});

  UpcomingMoviesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json["status_code"];
    statusMessage = json["status_message"];
    success = json["success"];
    dates = Dates.fromJson(json["dates"]);
    page = json["page"];
    results = [];
    for (var result in json["results"] ?? []) {
      results?.add(Result.fromJson(result));
    }
    totalPages = json["total_pages"];
    totalResults = json["total_results"];
  }
}

class Dates {
  String? maximum, minimum;

  Dates({this.maximum, this.minimum});

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json["maximum"];
    minimum = json["minimum"];
  }
}
