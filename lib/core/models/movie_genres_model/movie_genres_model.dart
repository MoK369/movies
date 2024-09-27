class MovieGenresModel {
  num? statusCode;
  String? statusMessage;
  bool? success;
  List<MovieGenre>? genres;

  MovieGenresModel({
    this.statusCode,
    this.statusMessage,
    this.success,
    this.genres,
  });

  MovieGenresModel.fromJson(dynamic json) {
    statusCode = json["status_code"];
    statusMessage = json["status_message"];
    success = json["success"];
    if (json['genres'] != null) {
      genres = [];
      json['genres'].forEach((v) {
        genres?.add(MovieGenre.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (genres != null) {
      map['genres'] = genres?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MovieGenre {
  num? id;
  String? name;

  MovieGenre({
    this.id,
    this.name,
  });

  MovieGenre.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
