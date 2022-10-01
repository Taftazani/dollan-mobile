// To parse this JSON data, do
//
//     final kamuSukaResponse = kamuSukaResponseFromJson(jsonString);

import 'dart:convert';

KamuSukaResponse kamuSukaResponseFromJson(String str) => KamuSukaResponse.fromJson(json.decode(str));

String kamuSukaResponseToJson(KamuSukaResponse data) => json.encode(data.toJson());

class KamuSukaResponse {
  String success;
  String message;
  List<KamuSukaItem> data;

  KamuSukaResponse({
    this.success,
    this.message,
    this.data,
  });

  factory KamuSukaResponse.fromJson(Map<String, dynamic> json) => new KamuSukaResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : new List<KamuSukaItem>.from(json["data"].map((x) => KamuSukaItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class KamuSukaItem {
  String id;
  String title;
  String images;
  String description;
  dynamic price;
  String slug;
  String catname;

  KamuSukaItem({
    this.id,
    this.title,
    this.images,
    this.description,
    this.price,
    this.slug,
    this.catname,
  });

  factory KamuSukaItem.fromJson(Map<String, dynamic> json) => new KamuSukaItem(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    images: json["images"] == null ? null : json["images"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"],
    slug: json["slug"] == null ? null : json["slug"],
    catname: json["catname"] == null ? null : json["catname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "images": images == null ? null : images,
    "description": description == null ? null : description,
    "price": price,
    "slug": slug == null ? null : slug,
    "catname": catname == null ? null : catname,
  };
}
