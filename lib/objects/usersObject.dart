// To parse this JSON data, do
//
//     final userInfoObj = userInfoObjFromJson(jsonString);

import 'dart:convert';

UserInfoObj userInfoObjFromJson(String str) =>
    UserInfoObj.fromJson(json.decode(str));

String userInfoObjToJson(UserInfoObj data) => json.encode(data.toJson());

class UserInfoObj {
  UserInfoObj({
    this.uid,
    this.fname,
    this.mname,
    this.lname,
    this.dob,
    this.cno,
    this.email,
    this.password,
    this.utype,
  });

  String uid;
  String fname;
  String mname;
  String lname;
  String dob;
  String cno;
  String email;
  String password;
  String utype;

  factory UserInfoObj.fromJson(Map<String, dynamic> json) => UserInfoObj(
        uid: json["uid"],
        fname: json["fname"],
        mname: json["mname"],
        lname: json["lname"],
        dob: json["dob"],
        cno: json["cno"],
        email: json["email"],
        password: json["password"],
        utype: json["utype"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fname": fname,
        "mname": mname,
        "lname": lname,
        "dob": dob,
        "cno": cno,
        "email": email,
        "password": password,
        "utype": utype,
      };
}
