// To parse this JSON data, do
//
//     final bookObject = bookObjectFromJson(jsonString);

import 'dart:convert';

BookObject bookObjectFromJson(String str) => BookObject.fromJson(json.decode(str));

String bookObjectToJson(BookObject data) => json.encode(data.toJson());

class BookObject {
    BookObject({
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

    factory BookObject.fromJson(Map<String, dynamic> json) => BookObject(
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
