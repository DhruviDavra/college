// To parse this JSON data, do
//
//     final assignmentSubmissionObject = assignmentSubmissionObjectFromJson(jsonString);

import 'dart:convert';

AssignmentSubmissionObject assignmentSubmissionObjectFromJson(String str) => AssignmentSubmissionObject.fromJson(json.decode(str));

String assignmentSubmissionObjectToJson(AssignmentSubmissionObject data) => json.encode(data.toJson());

class AssignmentSubmissionObject {
    AssignmentSubmissionObject({
        this.time,
        this.email,
        this.title,
        this.subject,
        this.path,
        this.sem,
    });

    int time;
    String email;
    String title;
    String subject;
    String path;
    String sem;

    factory AssignmentSubmissionObject.fromJson(Map<String, dynamic> json) => AssignmentSubmissionObject(
        time: json["time"],
        email: json["email"],
        title: json["title"],
        subject: json["subject"],
        path: json["path"],
        sem: json["sem"],
    );

    Map<String, dynamic> toJson() => {
        "time": time,
        "email": email,
        "title": title,
        "subject": subject,
        "path": path,
        "sem": sem,
    };
}
