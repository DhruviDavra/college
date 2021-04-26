// To parse this JSON data, do
//

import 'dart:convert';

NonTeachingStaffObject nonTeachingStaffObjectFromJson(String str) => NonTeachingStaffObject.fromJson(json.decode(str));

String nonTeachingStaffObjectToJson(NonTeachingStaffObject data) => json.encode(data.toJson());

class NonTeachingStaffObject {
    NonTeachingStaffObject({
        this.email,
        this.qualification,
        this.experience,
        this.designation,
     
    });

    String email;
    List<dynamic> qualification;
    int experience;
    String designation;
   
    factory NonTeachingStaffObject.fromJson(Map<String, dynamic> json) => NonTeachingStaffObject(
        email: json["email"],
        qualification: List<dynamic>.from(json["qualification"].map((x) => x)),
        experience: json["experience"],
        designation: json["designation"],
        );

    Map<String, dynamic> toJson() => {
        "email": email,
        "qualification": List<dynamic>.from(qualification.map((x) => x)),
        "experience": experience,
        "designation": designation,
         };
}
