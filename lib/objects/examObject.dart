// To parse this JSON data, do
//
//     final examObject = examObjectFromJson(jsonString);

import 'dart:convert';

ExamObject examObjectFromJson(String str) => ExamObject.fromJson(json.decode(str));

String examObjectToJson(ExamObject data) => json.encode(data.toJson());

class ExamObject {
    ExamObject({
        this.erno,
        this.etype,
        this.sem,
        this.subcode,
        this.total,
        this.marks,
        this.time,
    });

    String erno;
    String etype;
    String sem;
    List<int> subcode;
    int total;
    List<int> marks;
    int time;

    factory ExamObject.fromJson(Map<String, dynamic> json) => ExamObject(
        erno: json["erno"],
        etype: json["etype"],
        sem: json["sem"],
        subcode: List<int>.from(json["subcode"].map((x) => x)),
        total:json["total"],
        marks: List<int>.from(json["marks"].map((x) => x)),
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "erno": erno,
        "etype": etype,
        "sem": sem,
        "subcode": List<dynamic>.from(subcode.map((x) => x)),
        "total": total,
        "marks": List<dynamic>.from(marks.map((x) => x)),
        "time": time,
    };
}
