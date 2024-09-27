class ReleaseDatesModel {
  num? statusCode;
  String? statusMessage;
  bool? success;
  num? id;
  List<ReleaseDateResult>? results;

  ReleaseDatesModel({
    this.statusCode,
    this.statusMessage,
    this.success,
    this.id,
    this.results,
  });

  ReleaseDatesModel.fromJson(dynamic json) {
    statusCode = json["status_code"];
    statusMessage = json["status_message"];
    success = json["success"];
    id = json['id'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(ReleaseDateResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ReleaseDateResult {
  String? iso31661;
  List<ReleaseDate>? releaseDates;

  ReleaseDateResult({
    this.iso31661,
    this.releaseDates,
  });

  ReleaseDateResult.fromJson(dynamic json) {
    iso31661 = json['iso_3166_1'];
    if (json['release_dates'] != null) {
      releaseDates = [];
      json['release_dates'].forEach((v) {
        releaseDates?.add(ReleaseDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iso_3166_1'] = iso31661;
    if (releaseDates != null) {
      map['release_dates'] = releaseDates?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ReleaseDate {
  String? certification;
  List<String>? descriptors;
  String? iso6391;
  String? note;
  String? releaseDate;
  num? type;

  ReleaseDate({
    this.certification,
    this.descriptors,
    this.iso6391,
    this.note,
    this.releaseDate,
    this.type,
  });

  ReleaseDate.fromJson(dynamic json) {
    certification = json['certification'];
    if (json['descriptors'] != null) {
      descriptors = [];
      json['descriptors'].forEach((v) {
        descriptors?.add(v.toString());
      });
    }
    iso6391 = json['iso_639_1'];
    note = json['note'];
    releaseDate = json['release_date'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['certification'] = certification;
    if (descriptors != null) {
      map['descriptors'] = descriptors;
    }
    map['iso_639_1'] = iso6391;
    map['note'] = note;
    map['release_date'] = releaseDate;
    map['type'] = type;
    return map;
  }
}
