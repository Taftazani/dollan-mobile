// To parse this JSON data, do
//
//     final listFavoritResponse = listFavoritResponseFromJson(jsonString);

import 'dart:convert';

ListFavoritResponse listFavoritResponseFromJson(String str) => ListFavoritResponse.fromJson(json.decode(str));

String listFavoritResponseToJson(ListFavoritResponse data) => json.encode(data.toJson());

class ListFavoritResponse {
  String success;
  String message;
  List<FavoritItem> data;

  ListFavoritResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ListFavoritResponse.fromJson(Map<String, dynamic> json) => new ListFavoritResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : new List<FavoritItem>.from(json["data"].map((x) => FavoritItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class FavoritItem {
  String id;
  String title;
  String images;
  String description;
  dynamic price;
  String slug;

  FavoritItem({
    this.id,
    this.title,
    this.images,
    this.description,
    this.price,
    this.slug,
  });

  factory FavoritItem.fromJson(Map<String, dynamic> json) => new FavoritItem(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    images: json["images"] == null ? null : json["images"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"],
    slug: json["slug"] == null ? null : json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "images": images == null ? null : images,
    "description": description == null ? null : description,
    "price": price,
    "slug": slug == null ? null : slug,
  };
}
