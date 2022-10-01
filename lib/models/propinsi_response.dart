// To parse this JSON data, do
//
//     final propinsiResponse = propinsiResponseFromJson(jsonString);

import 'dart:convert';

List<PropinsiResponse> propinsiResponseFromJson(String str) => new List<PropinsiResponse>.from(json.decode(str).map((x) => PropinsiResponse.fromJson(x)));

String propinsiResponseToJson(List<PropinsiResponse> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class PropinsiResponse {
  String id;
  String name;
  String latitude;
  String longitude;

  PropinsiResponse({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });

  factory PropinsiResponse.fromJson(Map<String, dynamic> json) => new PropinsiResponse(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
  };
}
