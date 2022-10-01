// To parse this JSON data, do
//
//     final cityResponse = cityResponseFromJson(jsonString);

import 'dart:convert';

List<CityResponse> cityResponseFromJson(String str) => new List<CityResponse>.from(json.decode(str).map((x) => CityResponse.fromJson(x)));

String cityResponseToJson(List<CityResponse> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class CityResponse {
    String id;
    String provinceId;
    String name;

    CityResponse({
        this.id,
        this.provinceId,
        this.name,
    });

    factory CityResponse.fromJson(Map<String, dynamic> json) => new CityResponse(
        id: json["id"],
        provinceId: json["province_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
    };
}
