class Introduces {
  final int? introduceId;
  final String? content;
  final String? createdAt;

  Introduces({
    this.introduceId,
    this.content,
    this.createdAt,
  });

  factory Introduces.fromJson(Map<String, dynamic> json) {
    return Introduces(
      introduceId: json['introduceId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}

class IntroducesResponse {
  final String? code;
  final String? message;
  final int? placeId;
  final String? placeName;
  final String? placeCategory;
  final String? placeProfileImg;
  final List<Introduces>? introduceList;

  IntroducesResponse({
    this.code,
    this.message,
    this.placeId,
    this.placeName,
    this.placeCategory,
    this.placeProfileImg,
    this.introduceList,
  });

  factory IntroducesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['introduceList'] as List<dynamic>?;
    List<Introduces>? introduceList =
        list?.map((item) => Introduces.fromJson(item)).toList();

    return IntroducesResponse(
      code: json['code'],
      message: json['message'],
      introduceList: introduceList,
    );
  }
}
