// To parse this JSON data, do
//
//     final moodResponse = moodResponseFromJson(jsonString);

import 'dart:convert';

List<AllMoodItem> allMoodResponseFromJson(String str) => new List<AllMoodItem>.from(json.decode(str).map((x) => AllMoodItem.fromJson(x)));

String allMoodResponseToJson(List<AllMoodItem> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class AllMoodItem {
  String id;
  String name;
  String image;

  AllMoodItem({
    this.id,
    this.name,
    this.image,
  });

  factory AllMoodItem.fromJson(Map<String, dynamic> json) => new AllMoodItem(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

