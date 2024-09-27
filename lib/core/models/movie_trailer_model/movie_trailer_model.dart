class MovieTrailerModel {
  num? statusCode;
  String? statusMessage;
  bool? success;
  num? id;
  List<VideoResult>? videoResults;

  MovieTrailerModel({
    this.statusCode,
    this.statusMessage,
    this.success,
    this.id,
    this.videoResults,
  });

  MovieTrailerModel.fromJson(dynamic json) {
    statusCode = json["status_code"];
    statusMessage = json["status_message"];
    success = json["success"];
    id = json['id'];
    if (json['results'] != null) {
      videoResults = [];
      json['results'].forEach((v) {
        videoResults?.add(VideoResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (videoResults != null) {
      map['results'] = videoResults?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VideoResult {
  VideoResult({
    this.iso6391,
    this.iso31661,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt,
    this.id,
  });

  VideoResult.fromJson(dynamic json) {
    iso6391 = json['iso_639_1'];
    iso31661 = json['iso_3166_1'];
    name = json['name'];
    key = json['key'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
    official = json['official'];
    publishedAt = json['published_at'];
    id = json['id'];
  }

  String? iso6391;
  String? iso31661;
  String? name;
  String? key;
  String? site;
  num? size;
  String? type;
  bool? official;
  String? publishedAt;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iso_639_1'] = iso6391;
    map['iso_3166_1'] = iso31661;
    map['name'] = name;
    map['key'] = key;
    map['site'] = site;
    map['size'] = size;
    map['type'] = type;
    map['official'] = official;
    map['published_at'] = publishedAt;
    map['id'] = id;
    return map;
  }
}
