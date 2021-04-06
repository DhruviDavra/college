import 'dart:convert';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:college_management_system/objects/studentObject.dart';

class StudentProvider extends ChangeNotifier {
  static createStudentTable() {
    FirebaseFirestore.instance.collection("tbl_student");
  }

  String profileEmail;
  String sem;

  List<StudentObject> studentDetails = [];
  List<UserInfoObj> userDetails = [];

  addStudent(StudentObject studentObject) {
    try {
      createStudentTable();
      FirebaseFirestore.instance.collection("tbl_student").add({
        "rno": studentObject.rno,
        "email": studentObject.email,
        "enrollno": studentObject.enrollno,
        "div": studentObject.div,
        "sem": studentObject.sem,
        "acadamic-year": studentObject.acadamicYear,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<StudentObject>> getStudentDetail(String s) async {
    QuerySnapshot teachingData =
        await FirebaseFirestore.instance.collection("tbl_student").get();
    for (int i = 0; i < teachingData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_student")
          .where("email", isEqualTo: teachingData.docs[i].data()["email"])
          .where("sem", isEqualTo: s)
          .get();
     // print("length " + querySnapshot.docs.length.toString());

      if (querySnapshot.docs.length > 0) {
        studentDetails.add(studentObjectFromJson(
            json.encode(querySnapshot.docs.first.data())));
      }
    } //for
    return studentDetails;
  }

  Future<List<UserInfoObj>> getUserDetail(String s) async {
    QuerySnapshot studentData = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: s)
        .get();

    for (int i = 0; i < studentData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_users")
          .where("email", isEqualTo: studentData.docs[i].data()["email"])
          .get();

      userDetails.add(
          userInfoObjFromJson(json.encode(querySnapshot.docs.first.data())));
    } //for
    return userDetails;
  }

  updateStudent(String email, StudentObject studentObject) async {
    try {
      QuerySnapshot studentQuery = await FirebaseFirestore.instance
          .collection("tbl_student")
          .where("email", isEqualTo: email)
          .get();

      studentQuery.docs.forEach(
        (element) async {
          await FirebaseFirestore.instance
              .collection("tbl_student")
              .doc(element.id)
              .update(studentObject.toJson());
        },
      );
    } catch (e) {
      throw e;
    }
  }

  updateUser(String email, UserInfoObj userInfoObj) async {
    try {
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
    } catch (e) {
      throw e;
    }
  }

  Future<void> update(String email, UserInfoObj userInfoObj,
      StudentObject studentObject) async {
    await updateStudent(email, studentObject);
    await updateUser(email, userInfoObj);
  }

  deleteStudent(String email) async {
    print(email);
    QuerySnapshot studentQuery = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("email", isEqualTo: email)
        .get();
    studentQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_student")
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

  getParticularStudent(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("email", isEqualTo: email)
        .get();
    return studentObjectFromJson(
        json.encode(querySnapshot.docs.first.data()));
  }

  getParticularUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    return userInfoObjFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  countStaff() async {
    QuerySnapshot countStaff =
        await FirebaseFirestore.instance.collection("tbl_student").get();
    return countStaff.docs.length.toString();
  }
}
