class News {
  final int? newsId;
  final int? placeId;
  final String? placeName;
  final String? profileImg;
  final String? createdAt;
  final String? title;
  final String? content;

  News({
    this.newsId,
    this.placeId,
    this.placeName,
    this.profileImg,
    this.createdAt,
    this.title,
    this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['newsId'],
      placeId: json['placeId'],
      placeName: json['placeName'],
      profileImg: json['profileImg'],
      createdAt: json['createdAt'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class NewsResponse {
  final String? code;
  final String? message;
  final List<News>? newsList;

  NewsResponse({
    this.code,
    this.message,
    this.newsList,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['newsList'] as List<dynamic>?;
    List<News>? newsList = list?.map((item) => News.fromJson(item)).toList();

    return NewsResponse(
      code: json['code'],
      message: json['message'],
      newsList: newsList,
    );
  }
}
