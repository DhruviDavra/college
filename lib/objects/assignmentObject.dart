// To parse this JSON data, do
//
//     final assignmentObject = assignmentObjectFromJson(jsonString);

import 'dart:convert';

AssignmentObject assignmentObjectFromJson(String str) => AssignmentObject.fromJson(json.decode(str));

String assignmentObjectToJson(AssignmentObject data) => json.encode(data.toJson());

class AssignmentObject {
    AssignmentObject({
        this.title,
        this.docname,
        this.time,
        this.path,
        this.sem,
        this.subject,
        this.asno,
        this.des,
    });

    String title;
    String docname;
    int time;
    String path;
    String sem;
    String subject;
    int asno;
    String des;

    factory AssignmentObject.fromJson(Map<String, dynamic> json) => AssignmentObject(
        title: json["title"],
        docname: json["docname"],
        time: json["time"],
        path: json["path"],
        sem: json["sem"],
        subject: json["subject"],
        asno: json["asno"],
        des: json["des"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "docname": docname,
        "time": time,
        "path": path,
        "sem": sem,
        "subject": subject,
        "asno": asno,
        "des": des,
    };
}
