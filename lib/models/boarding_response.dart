// To parse this JSON data, do
//
//     final boardingResponse = boardingResponseFromJson(jsonString);

import 'dart:convert';

BoardingResponse boardingResponseFromJson(String str) => BoardingResponse.fromJson(json.decode(str));

String boardingResponseToJson(BoardingResponse data) => json.encode(data.toJson());

class BoardingResponse {
  String success;
  String message;
  List<BoardingData> data;

  BoardingResponse({
    this.success,
    this.message,
    this.data,
  });

  factory BoardingResponse.fromJson(Map<String, dynamic> json) => new BoardingResponse(
    success: json["success"],
    message: json["message"],
    data: new List<BoardingData>.from(json["data"].map((x) => BoardingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BoardingData {
  String dataId;
  String linkType;
  String title;
  String image;

  BoardingData({
    this.dataId,
    this.linkType,
    this.title,
    this.image,
  });

  factory BoardingData.fromJson(Map<String, dynamic> json) => new BoardingData(
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
