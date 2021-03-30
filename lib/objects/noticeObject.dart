// To parse this JSON data, do
//
//     final noticeObject = noticeObjectFromJson(jsonString);

import 'dart:convert';

NoticeObject noticeObjectFromJson(String str) => NoticeObject.fromJson(json.decode(str));

String noticeObjectToJson(NoticeObject data) => json.encode(data.toJson());

class NoticeObject {
    NoticeObject({
        this.docname,
        this.time,
        this.spath,
    });

    String docname;
    int time;
    String spath;

    factory NoticeObject.fromJson(Map<String, dynamic> json) => NoticeObject(
        docname: json["docname"],
        time: json["time"],
        spath: json["spath"],
    );

    Map<String, dynamic> toJson() => {
        "docname": docname,
        "time": time,
        "spath": spath,
    };
}
