// To parse this JSON data, do
//
//     final wisataSejenisResponse = wisataSejenisResponseFromJson(jsonString);

import 'dart:convert';

WisataSejenisResponse wisataSejenisResponseFromJson(String str) => WisataSejenisResponse.fromJson(json.decode(str));

String wisataSejenisResponseToJson(WisataSejenisResponse data) => json.encode(data.toJson());

class WisataSejenisResponse {
  String success;
  String message;
  List<WisataSejenisItem> data;

  WisataSejenisResponse({
    this.success,
    this.message,
    this.data,
  });

  factory WisataSejenisResponse.fromJson(Map<String, dynamic> json) => new WisataSejenisResponse(
    success: json["success"],
    message: json["message"],
    data: new List<WisataSejenisItem>.from(json["data"].map((x) => WisataSejenisItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WisataSejenisItem {
  String id;
  String title;
  String images;
  String description;
  dynamic price;
  String slug;
  String catname;
  String propinsi;
  String kabupaten;
  String contentType;

  WisataSejenisItem({
    this.id,
    this.title,
    this.images,
    this.description,
    this.price,
    this.slug,
    this.catname,
    this.propinsi,
    this.kabupaten,
    this.contentType
  });

  factory WisataSejenisItem.fromJson(Map<String, dynamic> json) => new WisataSejenisItem(
    id: json["id"],
    title: json["title"],
    images: json["images"],
    description: json["description"],
    price: json["price"],
    slug: json["slug"],
    catname: json["catname"],
    propinsi: json["propinsi"],
    kabupaten: json["kabupaten"],
    contentType: json["content_type"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": images,
    "description": description,
    "price": price,
    "slug": slug,
    "catname": catname,
    "propinsi":propinsi,
    "kabupaten":kabupaten,
    "content_type":contentType,
  };
}
