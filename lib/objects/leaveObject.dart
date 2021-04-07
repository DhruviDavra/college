// To parse this JSON data, do
//
//     final leaveObject = leaveObjectFromJson(jsonString);

import 'dart:convert';

LeaveObject leaveObjectFromJson(String str) => LeaveObject.fromJson(json.decode(str));

String leaveObjectToJson(LeaveObject data) => json.encode(data.toJson());

class LeaveObject {
    LeaveObject({
        this.email,
        this.applytime,
        this.toDate,
        this.fromDate,
        this.status,
        this.title,
        this.des,
    });

    String email;
    int applytime;
    String toDate;
    String fromDate;
    String status;
    String title;
    String des;

    factory LeaveObject.fromJson(Map<String, dynamic> json) => LeaveObject(
        email: json["email"],
        applytime: json["applytime"],
        toDate: json["toDate"],
        fromDate: json["fromDate"],
        status: json["status"],
        title: json["title"],
        des: json["des"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "applytime": applytime,
        "toDate": toDate,
        "fromDate": fromDate,
        "status": status,
        "title": title,
        "des": des,
    };
}
