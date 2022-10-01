// To parse this JSON data, do
//
//     final commentsResponse = commentsResponseFromJson(jsonString);

import 'dart:convert';

CommentsResponse commentsResponseFromJson(String str) => CommentsResponse.fromJson(json.decode(str));

String commentsResponseToJson(CommentsResponse data) => json.encode(data.toJson());

class CommentsResponse {
  String success;
  String message;
  List<CommentItem> data;

  CommentsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) => new CommentsResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : new List<CommentItem>.from(json["data"].map((x) => CommentItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CommentItem {
  String idcoment;
  String photo;
  String namauser;
  String comment;
  String postdate;
  String like;
  String dislike;

  CommentItem({
    this.idcoment,
    this.photo,
    this.namauser,
    this.comment,
    this.postdate,
    this.like,
    this.dislike,
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) => new CommentItem(
    idcoment: json["idcoment"] == null ? null : json["idcoment"],
    photo: json["photo"] == null ? null : json["photo"],
    namauser: json["namauser"] == null ? null : json["namauser"],
    comment: json["comment"] == null ? null : json["comment"],
    postdate: json["postdate"] == null ? null : json["postdate"],
    like: json["like"] == null ? null : json["like"],
    dislike: json["dislike"] == null ? null : json["dislike"],
  );

  Map<String, dynamic> toJson() => {
    "idcoment": idcoment == null ? null : idcoment,
    "photo": photo == null ? null : photo,
    "namauser": namauser == null ? null : namauser,
    "comment": comment == null ? null : comment,
    "postdate": postdate == null ? null : postdate,
    "like": like == null ? null : like,
    "dislike": dislike == null ? null : dislike,
  };
}
