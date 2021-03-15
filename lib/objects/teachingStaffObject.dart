// To parse this JSON data, do
//
//     final teachingStaffObject = teachingStaffObjectFromJson(jsonString);

import 'dart:convert';

TeachingStaffObject teachingStaffObjectFromJson(String str) => TeachingStaffObject.fromJson(json.decode(str));

String teachingStaffObjectToJson(TeachingStaffObject data) => json.encode(data.toJson());

class TeachingStaffObject {
    TeachingStaffObject({
        this.email,
        this.qualification,
        this.experience,
        this.designation,
        this.specialinterest,
    });

    String email;
    List<dynamic> qualification;
    String experience;
    String designation;
    String specialinterest;

    factory TeachingStaffObject.fromJson(Map<String, dynamic> json) => TeachingStaffObject(
        email: json["email"],
        qualification: List<dynamic>.from(json["qualification"].map((x) => x)),
        experience: json["experience"],
        designation: json["designation"],
        specialinterest: json["specialinterest"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "qualification": List<dynamic>.from(qualification.map((x) => x)),
        "experience": experience,
        "designation": designation,
        "specialinterest": specialinterest,
    };
}
