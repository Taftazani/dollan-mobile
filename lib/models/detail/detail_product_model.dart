// To parse this JSON data, do
//
//     final detailProductResponse = detailProductResponseFromJson(jsonString);

import 'dart:convert';

DetailProductResponse detailProductResponseFromJson(String str) => DetailProductResponse.fromJson(json.decode(str));

String detailProductResponseToJson(DetailProductResponse data) => json.encode(data.toJson());

class DetailProductResponse {
    String success;
    String message;
    DetailProductItem data;

    DetailProductResponse({
        this.success,
        this.message,
        this.data,
    });

    factory DetailProductResponse.fromJson(Map<String, dynamic> json) => new DetailProductResponse(
        success: json["success"],
        message: json["message"],
        data: DetailProductItem.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class DetailProductItem {
    String id;
    String title;
    String images;
    String description;
    String content;
    String slug;
    String username;
    String userimage;
    String date;
    String provname;
    String kabname;
    String longitude;
    String latitude;
    dynamic rating;
    String catname;
    String company;
    String price;
    String catid;
    String compname;
    String contentType;

    DetailProductItem({
        this.id,
        this.title,
        this.images,
        this.description,
        this.content,
        this.slug,
        this.username,
        this.userimage,
        this.date,
        this.provname,
        this.kabname,
        this.longitude,
        this.latitude,
        this.rating,
        this.catname,
        this.company,
        this.price,
        this.catid,
        this.compname,
        this.contentType
    });

    factory DetailProductItem.fromJson(Map<String, dynamic> json) => new DetailProductItem(
        id: json["id"],
        title: json["title"],
        images: json["images"],
        description: json["description"],
        content: json["content"],
        slug: json["slug"],
        username: json["username"],
        userimage: json["userimage"],
        date: json["date"],
        provname: json["provname"],
        kabname: json["kabname"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        rating: json["rating"],
        catname: json["catname"],
        company: json["company"],
        price: json["price"],
        catid: json["catid"],
        compname:json["compname"],
        contentType: json['content_type']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "images": images,
        "description": description,
        "content": content,
        "slug": slug,
        "username": username,
        "userimage": userimage,
        "date": date,
        "provname": provname,
        "kabname": kabname,
        "longitude": longitude,
        "latitude": latitude,
        "rating": rating,
        "catname": catname,
        "company": company,
        "price": price,
        "catid": catid,
        "compname":compname,
        "content_type":contentType
    };
}
