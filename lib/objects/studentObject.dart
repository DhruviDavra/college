// To parse this JSON data, do
//
//     final studentObject = studentObjectFromJson(jsonString);

import 'dart:convert';

StudentObject studentObjectFromJson(String str) => StudentObject.fromJson(json.decode(str));

String studentObjectToJson(StudentObject data) => json.encode(data.toJson());

class StudentObject {
    StudentObject({
        this.rno,
        this.email,
        this.enrollno,
        this.div,
        this.sem,
        this.year,
        this.acadamicYear,
    });

    int rno;
    String email;
    String enrollno;
    String div;
    String sem;
    String year;
    String acadamicYear;

    factory StudentObject.fromJson(Map<String, dynamic> json) => StudentObject(
        rno: json["rno"],
        email: json["email"],
        enrollno: json["enrollno"],
        div: json["div"],
        sem: json["sem"],
        year: json["year"],
        acadamicYear: json["acadamic-year"],
    );

    Map<String, dynamic> toJson() => {
        "rno": rno,
        "email": email,
        "enrollno": enrollno,
        "div": div,
        "sem": sem,
        "year": year,
        "acadamic-year": acadamicYear,
    };
}
