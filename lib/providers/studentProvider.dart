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

  List<StudentObject> studentDetailsOfA = [];
  List<UserInfoObj> userDetailsOfA = [];

  List<StudentObject> studentDetailsOfB = [];
  List<UserInfoObj> userDetailsOfB = [];

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

  Future<List<StudentObject>> getStudentDetailOfA(String s) async {
    QuerySnapshot studentData =
        await FirebaseFirestore.instance.collection("tbl_student").get();
    for (int i = 0; i < studentData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_student")
          .where("email", isEqualTo: studentData.docs[i].data()["email"])
          .where("sem", isEqualTo: s)
          .where("div", isEqualTo: "A")
          .get();
      // print("length " + querySnapshot.docs.length.toString());

      if (querySnapshot.docs.length > 0) {
        studentDetailsOfA.add(studentObjectFromJson(
            json.encode(querySnapshot.docs.first.data())));
      }
    } //for
    return studentDetailsOfA;
  }

  Future<List<UserInfoObj>> getUserDetailOfA(String s) async {
    QuerySnapshot studentData = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: s)
        .where("div", isEqualTo: "A")
        .get();

    for (int i = 0; i < studentData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_users")
          .where("email", isEqualTo: studentData.docs[i].data()["email"])
          .get();

      userDetailsOfA.add(
          userInfoObjFromJson(json.encode(querySnapshot.docs.first.data())));
    } //for
    return userDetailsOfA;
  }

  

  Future<List<StudentObject>> getStudentDetailOfB(String s) async {
    QuerySnapshot studentData =
        await FirebaseFirestore.instance.collection("tbl_student").get();
    for (int i = 0; i < studentData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_student")
          .where("email", isEqualTo: studentData.docs[i].data()["email"])
          .where("sem", isEqualTo: s)
          .where("div", isEqualTo: "B")
          .get();
      // print("length " + querySnapshot.docs.length.toString());

      if (querySnapshot.docs.length > 0) {
        studentDetailsOfB.add(studentObjectFromJson(
            json.encode(querySnapshot.docs.first.data())));
      }
    } //for
    return studentDetailsOfB;
  }

  Future<List<UserInfoObj>> getUserDetailOfB(String s) async {
    QuerySnapshot studentData = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: s)
        .where("div", isEqualTo: "B")
        .get();

    for (int i = 0; i < studentData.docs.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tbl_users")
          .where("email", isEqualTo: studentData.docs[i].data()["email"])
          .get();

      userDetailsOfB.add(
          userInfoObjFromJson(json.encode(querySnapshot.docs.first.data())));
    } //for
    return userDetailsOfB;
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
    return studentObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  getParticularUser(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("email", isEqualTo: email)
        .get();
    return userInfoObjFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  countStudent() async {
    QuerySnapshot countStaff =
        await FirebaseFirestore.instance.collection("tbl_student").get();
    return countStaff.docs.length.toString();
  }
}
