// To parse this JSON data, do
//
//     final attendanceObject = attendanceObjectFromJson(jsonString);

import 'dart:convert';

AttendanceObject attendanceObjectFromJson(String str) => AttendanceObject.fromJson(json.decode(str));

String attendanceObjectToJson(AttendanceObject data) => json.encode(data.toJson());

class AttendanceObject {
    AttendanceObject({
        this.email,
        this.date,
        this.subCode,
        this.status,
    });

    List<String> email;
    String date;
    int subCode;
    String status;


    factory AttendanceObject.fromJson(Map<String, dynamic> json) => AttendanceObject(
        email:  List<String>.from(json["email"].map((x) => x)),
        date: json["date"],
        subCode: json["subCode"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "email":List<dynamic>.from(email.map((x) => x)),
        "date": date,
        "subCode": subCode,
        "status": status,
    };
}
