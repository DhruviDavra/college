// To parse this JSON data, do
//
//     final feedbackObject = feedbackObjectFromJson(jsonString);

import 'dart:convert';

FeedbackObject feedbackObjectFromJson(String str) =>
    FeedbackObject.fromJson(json.decode(str));

String feedbackObjectToJson(FeedbackObject data) => json.encode(data.toJson());

class FeedbackObject {
  FeedbackObject({
    this.email,
    this.des,
    this.date,
    this.time,
  });

  String email;
  String des;
  String date;
  String time;
  factory FeedbackObject.fromJson(Map<String, dynamic> json) => FeedbackObject(
        email: json["email"],
        des: json["des"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "des": des,
        "date": date,
        "time": time,
      };
}
