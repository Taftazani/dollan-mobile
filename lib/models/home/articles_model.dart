// To parse this JSON data, do
//
//     final articleResponse = articleResponseFromJson(jsonString);

import 'dart:convert';

ArticleResponse articleResponseFromJson(String str) => ArticleResponse.fromJson(json.decode(str));

String articleResponseToJson(ArticleResponse data) => json.encode(data.toJson());

class ArticleResponse {
  String success;
  String message;
  List<ArticleItem> data;

  ArticleResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) => new ArticleResponse(
    success: json["success"],
    message: json["message"],
    data: new List<ArticleItem>.from(json["data"].map((x) => ArticleItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ArticleItem {
  String dataId;
  String linkType;
  String title;
  String image;

  ArticleItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory ArticleItem.fromJson(Map<String, dynamic> json) => new ArticleItem(
    dataId: json["data_id"],
    linkType: json["link_type"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "data_id": dataId,
    "link_type": linkType,
    "title": title,
    "image": image,
  };
}
