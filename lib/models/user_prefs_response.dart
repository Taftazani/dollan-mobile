// To parse this JSON UserPrefsData, do
//
//     final userPrefsResponse = userPrefsResponseFromJson(jsonString);

import 'dart:convert';

UserPrefsResponse userPrefsResponseFromJson(String str) => UserPrefsResponse.fromJson(json.decode(str));

String userPrefsResponseToJson(UserPrefsResponse UserPrefsData) => json.encode(UserPrefsData.toJson());

class UserPrefsResponse {
  String success;
  String message;
  UserPrefsData data;

  UserPrefsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UserPrefsResponse.fromJson(Map<String, dynamic> json) => new UserPrefsResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : UserPrefsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class UserPrefsData {
  String iduser;
  String question;
  String answer;
  String updatedBy;
  String updatedDate;

  UserPrefsData({
    this.iduser,
    this.question,
    this.answer,
    this.updatedBy,
    this.updatedDate,
  });

  factory UserPrefsData.fromJson(Map<String, dynamic> json) => new UserPrefsData(
    iduser: json["iduser"] == null ? null : json["iduser"],
    question: json["question"] == null ? null : json["question"],
    answer: json["answer"] == null ? null : json["answer"],
    updatedBy: json["updated_by"] == null ? null : json["updated_by"],
    updatedDate: json["updated_date"] == null ? null : json["updated_date"],
  );

  Map<String, dynamic> toJson() => {
    "iduser": iduser == null ? null : iduser,
    "question": question == null ? null : question,
    "answer": answer == null ? null : answer,
    "updated_by": updatedBy == null ? null : updatedBy,
    "updated_date": updatedDate == null ? null : updatedDate,
  };
}
