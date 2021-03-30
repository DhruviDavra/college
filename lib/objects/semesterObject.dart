// To parse this JSON data, do
//
//     final semesterObject = semesterObjectFromJson(jsonString);

import 'dart:convert';

SemesterObject semesterObjectFromJson(String str) => SemesterObject.fromJson(json.decode(str));

String semesterObjectToJson(SemesterObject data) => json.encode(data.toJson());

class SemesterObject {
    SemesterObject({
        this.id,
        this.sem,
    });

    int id;
    String sem;

    factory SemesterObject.fromJson(Map<String, dynamic> json) => SemesterObject(
        id: json["id"],
        sem: json["sem"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sem": sem,
    };
}
