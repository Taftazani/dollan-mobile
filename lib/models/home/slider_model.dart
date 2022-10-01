// To parse this JSON data, do
//
//     final sliderResponse = sliderResponseFromJson(jsonString);

import 'dart:convert';

SliderResponse sliderResponseFromJson(String str) => SliderResponse.fromJson(json.decode(str));

String sliderResponseToJson(SliderResponse data) => json.encode(data.toJson());

class SliderResponse {
  String success;
  String message;
  List<SliderItem> data;

  SliderResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SliderResponse.fromJson(Map<String, dynamic> json) => new SliderResponse(
    success: json["success"],
    message: json["message"],
    data: new List<SliderItem>.from(json["data"].map((x) => SliderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SliderItem {
  String dataId;
  String linkType;
  String title;
  String image;

  SliderItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) => new SliderItem(
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
