// To parse this JSON data, do
//
//     final feeObject = feeObjectFromJson(jsonString);

import 'dart:convert';

FeeObject feeObjectFromJson(String str) => FeeObject.fromJson(json.decode(str));

String feeObjectToJson(FeeObject data) => json.encode(data.toJson());

class FeeObject {
    FeeObject({
        this.email,
        this.erno,
        this.sem,
        this.status,
    });

    String email;
    String erno;
    String sem;
    String status;

    factory FeeObject.fromJson(Map<String, dynamic> json) => FeeObject(
        email: json["email"],
        erno: json["erno"],
        sem: json["sem"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "erno": erno,
        "sem": sem,
        "status": status,
    };
}
