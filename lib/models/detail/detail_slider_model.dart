// To parse this JSON data, do
//
//     final detailSliderResponse = detailSliderResponseFromJson(jsonString);

import 'dart:convert';

DetailSliderResponse detailSliderResponseFromJson(String str) => DetailSliderResponse.fromJson(json.decode(str));

String detailSliderResponseToJson(DetailSliderResponse data) => json.encode(data.toJson());

class DetailSliderResponse {
    String success;
    String message;
    List<DetailSliderItem> data;

    DetailSliderResponse({
        this.success,
        this.message,
        this.data,
    });

    factory DetailSliderResponse.fromJson(Map<String, dynamic> json) => new DetailSliderResponse(
        success: json["success"],
        message: json["message"],
        data: new List<DetailSliderItem>.from(json["data"].map((x) => DetailSliderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DetailSliderItem {
    String title;
    String images;

    DetailSliderItem({
        this.title,
        this.images,
    });

    factory DetailSliderItem.fromJson(Map<String, dynamic> json) => new DetailSliderItem(
        title: json["title"],
        images: json["images"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "images": images,
    };
}
