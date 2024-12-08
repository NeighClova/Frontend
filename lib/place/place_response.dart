class Place {
  final int? placeId;
  final String? placeName;
  final String? profileImg;
  final String? category;
  final String? placeUrl;
  final List<dynamic>? targetAge;
  final List<dynamic>? target;

  Place({
    this.placeId,
    this.placeName,
    this.profileImg,
    this.category,
    this.placeUrl,
    this.target,
    this.targetAge,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        placeId: json['placeId'],
        placeName: json['placeName'],
        profileImg: json['profileImg'],
        category: json['category'],
        placeUrl: json['placeUrl'],
        target: json['target'],
        targetAge: json['targetAge']);
  }
}

class PlaceResponse {
  final String? code;
  final String? message;
  final List<Place>? placeList;

  PlaceResponse({
    this.code,
    this.message,
    this.placeList,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    var list = json['placeList'] as List<dynamic>?;
    List<Place>? placeList = list?.map((item) => Place.fromJson(item)).toList();

    return PlaceResponse(
      code: json['code'],
      message: json['message'],
      placeList: placeList,
    );
  }
}

class PlaceNumResponse {
  final String? code;
  final String? message;
  final String? placeNum;

  PlaceNumResponse({
    this.code,
    this.message,
    this.placeNum,
  });

  factory PlaceNumResponse.fromJson(Map<String, dynamic> json) {
    return PlaceNumResponse(
      code: json['code'],
      message: json['message'],
      placeNum: json['place_num'],
    );
  }
}
