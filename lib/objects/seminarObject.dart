// To parse this JSON data, do
//
//     final seminarObject = seminarObjectFromJson(jsonString);

import 'dart:convert';

SeminarObject seminarObjectFromJson(String str) => SeminarObject.fromJson(json.decode(str));

String seminarObjectToJson(SeminarObject data) => json.encode(data.toJson());

class SeminarObject {
    SeminarObject({
        this.time,
        this.topic,
        this.des,
        this.sem,
        this.date,
        this.seminarTime,
        this.organizer,
        this.speaker,
    });

    String time;
    String topic;
    String des;
    List<dynamic> sem;
    String date;
    String seminarTime;
    String organizer;
    String speaker;

    factory SeminarObject.fromJson(Map<String, dynamic> json) => SeminarObject(
        time: json["time"],
        topic: json["topic"],
        des: json["des"],
        sem: List<dynamic>.from(json["sem"].map((x) => x)),
        date: json["date"],
        seminarTime: json["seminarTime"],
        organizer: json["organizer"],
        speaker: json["speaker"],
    );

    Map<String, dynamic> toJson() => {
        "time": time,
        "topic": topic,
        "des": des,
        "sem": List<dynamic>.from(sem.map((x) => x)),
        "date": date,
        "seminarTime": seminarTime,
        "organizer": organizer,
        "speaker": speaker,
    };
}
