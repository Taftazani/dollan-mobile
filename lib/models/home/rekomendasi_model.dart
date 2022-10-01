// To parse this JSON data, do
//
//     final rekomendasiResponse = rekomendasiResponseFromJson(jsonString);

import 'dart:convert';

RekomendasiResponse rekomendasiResponseFromJson(String str) => RekomendasiResponse.fromJson(json.decode(str));

String rekomendasiResponseToJson(RekomendasiResponse data) => json.encode(data.toJson());

class RekomendasiResponse {
  String success;
  String message;
  List<RekomendasiItem> data;

  RekomendasiResponse({
    this.success,
    this.message,
    this.data,
  });

  factory RekomendasiResponse.fromJson(Map<String, dynamic> json) => new RekomendasiResponse(
    success: json["success"],
    message: json["message"],
    data: new List<RekomendasiItem>.from(json["data"].map((x) => RekomendasiItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RekomendasiItem {
  String dataId;
  String linkType;
  String title;
  String price;
  String image;
  String propinsi;
  String kabupaten;
  String contentType;

  RekomendasiItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
    this.price,
    this.propinsi,
    this.kabupaten,
    this.contentType
  });

  factory RekomendasiItem.fromJson(Map<String, dynamic> json) => new RekomendasiItem(
    dataId: json["data_id"],
    linkType: json["link_type"],
    title: json["title"],
    image: json["image"],
    price: json["price"],
      propinsi: json["propinsi"],
      kabupaten: json["kabupaten"],
      contentType: json["content_type"]
  );

  Map<String, dynamic> toJson() => {
    "data_id": dataId,
    "link_type": linkType,
    "title": title,
    "image": image,
    "price":price,
    "propinsi":propinsi,
    "kabupaten":kabupaten,
    "content_type":contentType
  };
}
