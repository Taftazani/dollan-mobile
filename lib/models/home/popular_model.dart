// To parse this JSON data, do
//
//     final popularResponse = popularResponseFromJson(jsonString);

import 'dart:convert';

PopularResponse popularResponseFromJson(String str) => PopularResponse.fromJson(json.decode(str));

String popularResponseToJson(PopularResponse data) => json.encode(data.toJson());

class PopularResponse {
  String success;
  String message;
  List<PopularItem> data;

  PopularResponse({
    this.success,
    this.message,
    this.data,
  });

  factory PopularResponse.fromJson(Map<String, dynamic> json) => new PopularResponse(
    success: json["success"],
    message: json["message"],
    data: new List<PopularItem>.from(json["data"].map((x) => PopularItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PopularItem {
  String dataId;
  String linkType;
  String title;
  String image;

  PopularItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory PopularItem.fromJson(Map<String, dynamic> json) => new PopularItem(
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
