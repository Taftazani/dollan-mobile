// To parse this JSON data, do
//
//     final prefsResponse = prefsResponseFromJson(jsonString);

import 'dart:convert';

PrefsResponse prefsResponseFromJson(String str) => PrefsResponse.fromJson(json.decode(str));

String prefsResponseToJson(PrefsResponse data) => json.encode(data.toJson());

class PrefsResponse {
    String success;
    String message;
    PrefsData data;

    PrefsResponse({
        this.success,
        this.message,
        this.data,
    });

    factory PrefsResponse.fromJson(Map<String, dynamic> json) => new PrefsResponse(
        success: json["success"],
        message: json["message"],
        data: PrefsData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class PrefsData {
    String id;
    String question;
    List<ItemAnswer> itemAnswer;

    PrefsData({
        this.id,
        this.question,
        this.itemAnswer,
    });

    factory PrefsData.fromJson(Map<String, dynamic> json) => new PrefsData(
        id: json["id"],
        question: json["question"],
        itemAnswer: new List<ItemAnswer>.from(json["item_answer"].map((x) => ItemAnswer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "item_answer": new List<dynamic>.from(itemAnswer.map((x) => x.toJson())),
    };
}

class ItemAnswer {
    String answer;
    String image;

    ItemAnswer({
        this.answer,
        this.image,
    });

    factory ItemAnswer.fromJson(Map<String, dynamic> json) => new ItemAnswer(
        answer: json["answer"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "answer": answer,
        "image": image,
    };
}
