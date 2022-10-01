// To parse this JSON data, do
//
//     final catMoodResponse = catMoodResponseFromJson(jsonString);

import 'dart:convert';

CatMoodResponse catMoodResponseFromJson(String str) => CatMoodResponse.fromJson(json.decode(str));

String catMoodResponseToJson(CatMoodResponse data) => json.encode(data.toJson());

class CatMoodResponse {
    String success;
    String message;
    String title;
    List<CatMoodItem> data;

    CatMoodResponse({
        this.success,
        this.message,
        this.title,
        this.data,
    });

    factory CatMoodResponse.fromJson(Map<String, dynamic> json) => new CatMoodResponse(
        success: json["success"],
        message: json["message"],
        title: json["title"],
        data: new List<CatMoodItem>.from(json["data"].map((x) => CatMoodItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "title": title,
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CatMoodItem {
    String id;
    String title;
    String images;
    String description;
    String price;
    String slug;
    String username;
    String date;
    String propinsi;
    String kabupaten;
    String contentType;

    CatMoodItem({
        this.id,
        this.title,
        this.images,
        this.description,
        this.price,
        this.slug,
        this.username,
        this.date,
        this.propinsi,
        this.kabupaten,
        this.contentType,
    });

    factory CatMoodItem.fromJson(Map<String, dynamic> json) => new CatMoodItem(
        id: json["id"],
        title: json["title"],
        images: json["images"],
        description: json["description"],
        price: json["price"] == null ? null : json["price"],
        slug: json["slug"],
        username: json["username"],
        date: json["date"],
        propinsi: json["propinsi"],
        kabupaten: json["kabupaten"],
        contentType: json["content_type"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "images": images,
        "description": description,
        "price": price == null ? null : price,
        "slug": slug,
        "username": username,
        "date": date,
        "propinsi":propinsi,
        "kabupaten":kabupaten,
        "content_type":contentType
    };
}
