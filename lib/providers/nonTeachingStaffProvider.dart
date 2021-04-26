import 'dart:convert';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_management_system/objects/nonteachingStaffObject.dart';

class NonTeachingStaffProvider extends ChangeNotifier {
  static createNonTeachingStaffTable() {
    FirebaseFirestore.instance.collection("tbl_NonTeachingStaff");
  }

  String profileEmail;
  String teachingEmail;
  bool isTeachingStaffLogin = false;
  List<NonTeachingStaffObject> teachingDetails = [];
  List<UserInfoObj> userDetails = [];

  addTeachingStaff(NonTeachingStaffObject teachingStaff) {
    createNonTeachingStaffTable();
    FirebaseFirestore.instance.collection("tbl_NonTeachingStaff").add({
      "email": teachingStaff.email,
      "qualification": teachingStaff.qualification,
      "experience": teachingStaff.experience,
      "designation": teachingStaff.designation,
    });
  }

  Future<List<NonTeachingStaffObject>> getTeachingDetail() async {
    teachingDetails.clear();
    QuerySnapshot teachingData =
        await FirebaseFirestore.instance.collection("tbl_NonTeachingStaff").get();
    for (int i = 0; i < teachingData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_NonTeachingStaff")
          .where("email", isEqualTo: teachingData.docs[i].data()["email"])
          .orderBy("experience",descending: true)
          .get();

      teachingDetails.add(nonTeachingStaffObjectFromJson(
          json.encode(querySnapshot.docs.first.data())));
      // print(teachingName);
    } //for
    return teachingDetails;
  }

  Future<List<UserInfoObj>> getUserDetail() async {
    userDetails.clear();
    QuerySnapshot teachingData = await FirebaseFirestore.instance
        .collection("tbl_NonTeachingStaff")
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

  updateStaff(String email, NonTeachingStaffObject teachingStaffObject) async {
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_NonTeachingStaff")
        .where("email", isEqualTo: email)
        .get();
    print(teachingStaffObject.qualification);
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_NonTeachingStaff")
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
      NonTeachingStaffObject teachingStaffObject) async {
    await updateStaff(email, teachingStaffObject);
    await updateUser(email, userInfoObj);
  }

  deleteTeachingUser(String email) async {
    print(email);
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_NonTeachingStaff")
        .where("email", isEqualTo: email)
        .get();
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_NonTeachingStaff")
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

  Future<NonTeachingStaffObject> getParticularStaff(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_NonTeachingStaff")
        .where("email", isEqualTo: email)
        .get();
    return nonTeachingStaffObjectFromJson(
        json.encode(querySnapshot.docs.first.data()));
  }

  Future<UserInfoObj> getParticularUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    return userInfoObjFromJson(json.encode(querySnapshot.docs.first.data()));
  }

 
}
