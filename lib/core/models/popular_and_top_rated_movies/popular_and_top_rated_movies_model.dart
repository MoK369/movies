import '../result.dart';

class PopularAndTopRatedMoviesModel {
  num? statusCode;
  String? statusMessage;
  bool? success;
  num? page;
  List<Result>? results;
  num? totalPages;
  num? totalResults;

  PopularAndTopRatedMoviesModel({
    this.statusCode,
    this.statusMessage,
    this.success,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  PopularAndTopRatedMoviesModel.fromJson(dynamic json) {
    statusCode = json["status_code"];
    statusMessage = json["status_message"];
    success = json["success"];
    page = json['page'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Result.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_results'] = totalResults;
    return map;
  }
}
