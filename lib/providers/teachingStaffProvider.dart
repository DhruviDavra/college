import 'dart:convert';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_management_system/objects/teachingStaffObject.dart';

class TeachingStaffProvider extends ChangeNotifier {
  static createTeachingStaffTable() {
    FirebaseFirestore.instance.collection("tbl_teachingStaff");
  }

  String profileEmail;
  String teachingEmail;
  bool isTeachingStaffLogin = false;
  List<TeachingStaffObject> teachingDetails = [];
  List<UserInfoObj> userDetails = [];

  addTeachingStaff(TeachingStaffObject teachingStaff) {
    createTeachingStaffTable();
    FirebaseFirestore.instance.collection("tbl_teachingStaff").add({
      "email": teachingStaff.email,
      "qualification": teachingStaff.qualification,
      "experience": teachingStaff.experience,
      "designation": teachingStaff.designation,
      "specialinterest": teachingStaff.specialinterest,
    });
  }

  Future<List<TeachingStaffObject>> getTeachingDetail() async {
    teachingDetails.clear();
    QuerySnapshot teachingData =
        await FirebaseFirestore.instance.collection("tbl_teachingStaff").get();
    for (int i = 0; i < teachingData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_teachingStaff")
          .where("email", isEqualTo: teachingData.docs[i].data()["email"])
          .orderBy("experience",descending: true)
          .get();

      teachingDetails.add(teachingStaffObjectFromJson(
          json.encode(querySnapshot.docs.first.data())));
      // print(teachingName);
    } //for
    return teachingDetails;
  }

  Future<List<UserInfoObj>> getUserDetail() async {
    userDetails.clear();
    QuerySnapshot teachingData = await FirebaseFirestore.instance
        .collection("tbl_teachingStaff")
        .orderBy("experience",descending: true)
        .get();

    for (int i = 0; i < teachingData.docs.length; i++) {
      //  print("debug Email: "+teachingData.docs[i].data()["email"]);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_users")
          .where("email", isEqualTo: teachingData.docs[i].data()["email"])
          .get();

      userDetails.add(
          userInfoObjFromJson(json.encode(querySnapshot.docs.first.data())));
    } //for
    return userDetails;

    //print(querySnapshot.docs[0].data()["dob"]);
  }

  updateStaff(String email, TeachingStaffObject teachingStaffObject) async {
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_teachingStaff")
        .where("email", isEqualTo: email)
        .get();
    print(teachingStaffObject.qualification);
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_teachingStaff")
            .doc(element.id)
            .update(teachingStaffObject.toJson());
      },
    );
  }

  updateUser(String email, UserInfoObj userInfoObj) async {
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_users")
            .doc(element.id)
            .update(userInfoObj.toJson());
      },
    );
  }

  Future<void> update(String email, UserInfoObj userInfoObj,
      TeachingStaffObject teachingStaffObject) async {
    await updateStaff(email, teachingStaffObject);
    await updateUser(email, userInfoObj);
  }

  deleteTeachingUser(String email) async {
    print(email);
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_teachingStaff")
        .where("email", isEqualTo: email)
        .get();
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_teachingStaff")
            .doc(element.id)
            .delete();
      },
    );
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    userQuery.docs.forEach((element) async {
      await FirebaseFirestore.instance
          .collection("tbl_users")
          .doc(element.id)
          .delete();
    });
  }

  Future<TeachingStaffObject> getParticularStaff(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_teachingStaff")
        .where("email", isEqualTo: email)
        .get();
    return teachingStaffObjectFromJson(
        json.encode(querySnapshot.docs.first.data()));
  }

  Future<UserInfoObj> getParticularUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    return userInfoObjFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  countStaff() async {
    QuerySnapshot countStaff =
        await FirebaseFirestore.instance.collection("tbl_teachingStaff").get();
    return countStaff.docs.length.toString();
  }
}
