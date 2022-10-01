// To parse this JSON data, do
//
//     final profileDataModel = profileDataModelFromJson(jsonString);

import 'dart:convert';

ProfileDataModel profileDataModelFromJson(String str) => ProfileDataModel.fromJson(json.decode(str));

String profileDataModelToJson(ProfileDataModel data) => json.encode(data.toJson());

class ProfileDataModel {
  String success;
  String message;
  ProfileData data;

  ProfileDataModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => new ProfileDataModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class ProfileData {
  String id;
  dynamic idgoogle;
  dynamic idfacebook;
  String mobilephone;
  String firstname;
  String lastname;
  String username;
  String email;
  String photo;
  String address;
  String status;
  String gender;
  String birthDate;
  String usertype;
  String imageuser;

  ProfileData({
    this.id,
    this.idgoogle,
    this.idfacebook,
    this.mobilephone,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.photo,
    this.address,
    this.status,
    this.gender,
    this.birthDate,
    this.usertype,
    this.imageuser,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => new ProfileData(
    id: json["id"] == null ? null : json["id"],
    idgoogle: json["idgoogle"],
    idfacebook: json["idfacebook"],
    mobilephone: json["mobilephone"] == null ? null : json["mobilephone"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    username: json["username"] == null ? null : json["username"],
    email: json["email"] == null ? null : json["email"],
    photo: json["photo"] == null ? null : json["photo"],
    address: json["address"] == null ? null : json["address"],
    status: json["status"] == null ? null : json["status"],
    gender: json["gender"] == null ? null : json["gender"],
    birthDate: json["birth_date"] == null ? null : json["birth_date"],
    usertype: json["usertype"] == null ? null : json["usertype"],
    imageuser: json["imageuser"] == null ? null : json["imageuser"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "idgoogle": idgoogle,
    "idfacebook": idfacebook,
    "mobilephone": mobilephone == null ? null : mobilephone,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "username": username == null ? null : username,
    "email": email == null ? null : email,
    "photo": photo == null ? null : photo,
    "address": address == null ? null : address,
    "status": status == null ? null : status,
    "gender": gender == null ? null : gender,
    "birth_date": birthDate == null ? null : birthDate,
    "usertype": usertype == null ? null : usertype,
    "imageuser": imageuser == null ? null : imageuser,
  };
}
