class Review {
  final String? code;
  final String? message;
  final int? placeId;
  final String? viewDate;
  final List<dynamic>? keyword;
  final List<dynamic>? pSummary;
  final String? pBody;
  final List<dynamic>? nSummary;
  final String? nBody;
  final String? createdAt;
  final String? updatedAt;

  Review(
      {this.code,
      this.message,
      this.placeId,
      this.viewDate,
      this.keyword,
      this.pSummary,
      this.pBody,
      this.nSummary,
      this.nBody,
      this.createdAt,
      this.updatedAt});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        code: json['code'],
        message: json['message'],
        placeId: json['placeId'],
        viewDate: json['viewDate'],
        keyword: json['keyword'],
        pSummary: json['psummary'],
        pBody: json['pbody'],
        nSummary: json['nsummary'],
        nBody: json['nbody'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
