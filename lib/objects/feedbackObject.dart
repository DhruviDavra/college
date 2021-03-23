// To parse this JSON data, do
//
//     final feedbackObject = feedbackObjectFromJson(jsonString);

import 'dart:convert';

FeedbackObject feedbackObjectFromJson(String str) => FeedbackObject.fromJson(json.decode(str));

String feedbackObjectToJson(FeedbackObject data) => json.encode(data.toJson());

class FeedbackObject {
    FeedbackObject({
        this.email,
        this.des,
        this.date,
    });

    String email;
    String des;
    String date;

    factory FeedbackObject.fromJson(Map<String, dynamic> json) => FeedbackObject(
        email: json["email"],
        des: json["des"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "des": des,
        "date": date,
    };
}