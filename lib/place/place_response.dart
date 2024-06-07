class Place {
  final int? placeId;
  final String? placeName;
  final String? profileImg;

  Place({
    this.placeId,
    this.placeName,
    this.profileImg,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['placeId'],
      placeName: json['placeName'],
      profileImg: json['profileImg'],
    );
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
