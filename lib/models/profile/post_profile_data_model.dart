// To parse this JSON data, do
//
//     final PostProfileDataModel = PostProfileDataModelFromJson(jsonString);

import 'dart:convert';

PostProfileDataModel PostProfileDataModelFromJson(String str) => PostProfileDataModel.fromJson(json.decode(str));

String PostProfileDataModelToJson(PostProfileDataModel data) => json.encode(data.toJson());

class PostProfileDataModel {
  String id;
  String firstname;
  String lastname;
  String password;
  String mobilephone;
  String gender;
  String birthDate;
  String address;
  String email;
  String photo;

  PostProfileDataModel({
    this.id,
    this.firstname,
    this.lastname,
    this.password,
    this.mobilephone,
    this.gender,
    this.birthDate,
    this.address,
    this.email,
    this.photo,
  });

  factory PostProfileDataModel.fromJson(Map<String, dynamic> json) => new PostProfileDataModel(
    id: json["id"] == null ? null : json["id"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    password: json["password"] == null ? null : json["password"],
    mobilephone: json["mobilephone"] == null ? null : json["mobilephone"],
    gender: json["gender"] == null ? null : json["gender"],
    birthDate: json["birth_date"] == null ? null : json["birth_date"],
    address: json["address"] == null ? null : json["address"],
    email: json["email"] == null ? null : json["email"],
    photo: json["photo"] == null ? null : json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "password": password == null ? null : password,
    "mobilephone": mobilephone == null ? null : mobilephone,
    "gender": gender == null ? null : gender,
    "birth_date": birthDate == null ? null : birthDate,
    "address": address == null ? null : address,
    "email": email == null ? null : email,
    "photo": photo == null ? null : photo,
  };
}
