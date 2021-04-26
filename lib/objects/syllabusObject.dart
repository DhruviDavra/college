// To parse this JSON data, do
//
//     final syllabusObject = syllabusObjectFromJson(jsonString);

import 'dart:convert';

SyllabusObject syllabusObjectFromJson(String str) => SyllabusObject.fromJson(json.decode(str));

String syllabusObjectToJson(SyllabusObject data) => json.encode(data.toJson());

class SyllabusObject {
    SyllabusObject({
        this.title,
        this.docname,
        this.time,
        this.path,
        this.sem,
        this.subject,
    });

    String title;
    String docname;
    int time;
    String path;
    String sem;
    String subject;

    factory SyllabusObject.fromJson(Map<String, dynamic> json) => SyllabusObject(
        title: json["title"],
        docname: json["docname"],
        time: json["time"],
        path: json["path"],
        sem: json["sem"],
        subject: json["subject"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "docname": docname,
        "time": time,
        "path": path,
        "sem": sem,
        "subject": subject,
    };
}
