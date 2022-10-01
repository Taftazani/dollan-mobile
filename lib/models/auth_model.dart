// To parse this JSON data, do
//
//     final authResponse = authResponseFromJson(jsonString);

import 'dart:convert';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
    String success;
    String message;
    Data data;

    AuthResponse({
        this.success,
        this.message,
        this.data,
    });

    factory AuthResponse.fromJson(Map<String, dynamic> json) => new AuthResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    String userId;
    String name;
    String firstname;
    String lastname;
    String email;
    String usertype;
    String phone;
    String mobilephone;
    String city;
    String state;
    String country;
    String lat;
    String long;
    String photo;

    Data({
        this.userId,
        this.name,
        this.firstname,
        this.lastname,
        this.email,
        this.usertype,
        this.phone,
        this.mobilephone,
        this.city,
        this.state,
        this.country,
        this.lat,
        this.long,
        this.photo,
    });

    factory Data.fromJson(Map<String, dynamic> json) => new Data(
        userId: json["UserId"] == null ? null : json["UserId"],
        name: json["name"] == null ? null : json["name"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        email: json["email"] == null ? null : json["email"],
        usertype: json["usertype"] == null ? null : json["usertype"],
        phone: json["phone"] == null ? null : json["phone"],
        mobilephone: json["mobilephone"] == null ? null : json["mobilephone"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        photo: json["photo"] == null ? null : json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "UserId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "email": email == null ? null : email,
        "usertype": usertype == null ? null : usertype,
        "phone": phone == null ? null : phone,
        "mobilephone": mobilephone == null ? null : mobilephone,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
        "lat": lat == null ? null : lat,
        "long": long == null ? null : long,
        "photo": photo == null ? null : photo,
    };
}
