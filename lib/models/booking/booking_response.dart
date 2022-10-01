// To parse this JSON data, do
//
//     final getBookingResponse = getBookingResponseFromJson(jsonString);

import 'dart:convert';

GetBookingResponse getBookingResponseFromJson(String str) => GetBookingResponse.fromJson(json.decode(str));

String getBookingResponseToJson(GetBookingResponse data) => json.encode(data.toJson());

class GetBookingResponse {
  String success;
  String message;
  GetBookingData data;

  GetBookingResponse({
    this.success,
    this.message,
    this.data,
  });

  factory GetBookingResponse.fromJson(Map<String, dynamic> json) => new GetBookingResponse(
    success: json["success"],
    message: json["message"],
    data: GetBookingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class GetBookingData {
  String id;
  String title;
  String images;
  String description;
  String date;
  String catname;
  List<Product> product;
  String provname;
  String kabname;

  GetBookingData({
    this.id,
    this.title,
    this.images,
    this.description,
    this.date,
    this.catname,
    this.product,
    this.provname,
    this.kabname,
  });

  factory GetBookingData.fromJson(Map<String, dynamic> json) => new GetBookingData(
    id: json["id"],
    title: json["title"],
    images: json["images"],
    description: json["description"],
    date: json["date"],
    catname: json["catname"],
    product: new List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
    provname: json["provname"],
    kabname: json["kabname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": images,
    "description": description,
    "date": date,
    "catname": catname,
    "product": new List<dynamic>.from(product.map((x) => x.toJson())),
    "provname": provname,
    "kabname": kabname,
  };
}

class Product {
  String id;
  String postid;
  String name;
  String descriptions;
  String price;
  String quota;

  Product({
    this.id,
    this.postid,
    this.name,
    this.descriptions,
    this.price,
    this.quota,
  });

  factory Product.fromJson(Map<String, dynamic> json) => new Product(
    id: json["id"],
    postid: json["postid"],
    name: json["name"],
    descriptions: json["descriptions"],
    price: json["price"],
    quota: json["quota"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "postid": postid,
    "name": name,
    "descriptions": descriptions,
    "price": price,
    "quota": quota,
  };
}
