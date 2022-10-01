// To parse this JSON data, do
//
//     final moodResponse = moodResponseFromJson(jsonString);

import 'dart:convert';

List<MoodItem> moodResponseFromJson(String str) => new List<MoodItem>.from(json.decode(str).map((x) => MoodItem.fromJson(x)));

String moodResponseToJson(List<MoodItem> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class MoodItem {
  String dataId;
  String linkType;
  String title;
  String image;

  MoodItem({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory MoodItem.fromJson(Map<String, dynamic> json) => new MoodItem(
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

