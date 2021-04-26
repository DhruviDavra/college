// To parse this JSON data, do
//
//     final subjectObject = subjectObjectFromJson(jsonString);

import 'dart:convert';

SubjectObject subjectObjectFromJson(String str) => SubjectObject.fromJson(json.decode(str));

String subjectObjectToJson(SubjectObject data) => json.encode(data.toJson());

class SubjectObject {
    SubjectObject({
        this.subCode,
        this.subName,
        this.sem,
    });

    int subCode;
    String subName;
    String sem;

    factory SubjectObject.fromJson(Map<String, dynamic> json) => SubjectObject(
        subCode: json["subCode"],
        subName: json["subName"],
        sem: json["sem"],
    );

    Map<String, dynamic> toJson() => {
        "sub_code": subCode,
        "subName": subName,
        "sem": sem,
    };
}
