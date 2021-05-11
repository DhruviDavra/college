// To parse this JSON data, do
//
//     final bookObject = bookObjectFromJson(jsonString);

import 'dart:convert';

CircularObject circularObjectFromJson(String str) =>
    CircularObject.fromJson(json.decode(str));

String circularObjectToJson(CircularObject data) => json.encode(data.toJson());

class CircularObject {
  CircularObject({
    this.title,
    this.des,
    this.time,
    this.path,
    this.utype,
    this.subject,
    this.filename,
  });

  String title;
  String des;
  int time;
  String path;
  List<String> utype;
  String subject;
  String filename;

  factory CircularObject.fromJson(Map<String, dynamic> json) => CircularObject(
        title: json["title"],
        des: json["docname"],
        time: json["time"],
        path: json["path"],
        utype: List<String>.from(json["utype"].map((x) => x)),
        subject: json["subject"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "docname": des,
        "time": time,
        "path": path,
        "utype": List<dynamic>.from(utype.map((x) => x)),
        "subject": subject,
        "filename": filename,
      };
}
