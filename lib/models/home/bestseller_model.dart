// To parse this JSON data, do
//
//     final bestSellerResponse = bestSellerResponseFromJson(jsonString);

import 'dart:convert';

BestSellerResponse bestSellerResponseFromJson(String str) => BestSellerResponse.fromJson(json.decode(str));

String bestSellerResponseToJson(BestSellerResponse data) => json.encode(data.toJson());

class BestSellerResponse {
  String success;
  String message;
  List<BestSellerItem> data;

  BestSellerResponse({
    this.success,
    this.message,
    this.data,
  });

  factory BestSellerResponse.fromJson(Map<String, dynamic> json) => new BestSellerResponse(
    success: json["success"],
    message: json["message"],
    data: new List<BestSellerItem>.from(json["data"].map((x) => BestSellerItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BestSellerItem {
  String dataId;
  String linkType;
  String title;
  String image;

  BestSellerItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory BestSellerItem.fromJson(Map<String, dynamic> json) => new BestSellerItem(
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
