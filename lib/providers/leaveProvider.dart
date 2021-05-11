import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/leaveObject.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:intl/intl.dart';

class LeaveProvider extends ChangeNotifier {
  static createLeaveTable() {
    FirebaseFirestore.instance.collection("tbl_leave");
  }

  bool isTeachingStaff = false;
  List<LeaveObject> leaveDetails = [];
  List<LeaveObject> leaveDetailsForStudent = [];
  List<LeaveObject> leaveDetailsForUser = [];

  List<StudentObject> studentDetails = [];
  List<UserInfoObj> userDetails = [];

  String detailTime;

  String epochToLocal(int epochTime) {
    try {
      DateTime localTime =
          DateTime.fromMillisecondsSinceEpoch(epochTime, isUtc: false);
      return DateFormat("dd-MM-yyyy").format(localTime).toString();
    } catch (e) {
      return "";
    }
  }

  addLeave(LeaveObject leaveObject) {
    createLeaveTable();
    FirebaseFirestore.instance.collection("tbl_leave").add({
      "email": leaveObject.email,
      "applytime": leaveObject.applytime,
      "toDate": leaveObject.toDate,
      "fromDate": leaveObject.fromDate,
      "status": leaveObject.status,
      "title": leaveObject.title,
      "des": leaveObject.des,
    });
  }

  String studentEmail;
  Future<List<LeaveObject>> getLeaveDetailForStudent() async {
    leaveDetails.clear();
    QuerySnapshot leaveData = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .where("email", isEqualTo: studentEmail)
        .get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetails
          .add(leaveObjectFromJson(json.encode(leaveData.docs[i].data())));
    } //for
    return leaveDetails;
  }

  Future<List<LeaveObject>> getLeaveDetail() async {
    leaveDetails.clear();
    QuerySnapshot leaveData = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .orderBy("applytime")
        .get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetails
          .add(leaveObjectFromJson(json.encode(leaveData.docs[i].data())));
    } //for
    return leaveDetails;
  }

  Future<List<LeaveObject>> getAllLeave() async {
    leaveDetails.clear();
    QuerySnapshot leaveData = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .orderBy("email")
        
        .get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetails
          .add(leaveObjectFromJson(json.encode(leaveData.docs[i].data())));
    } //for
    return leaveDetails;
  }

  Future<List<StudentObject>> getStudentDetail() async {
    studentDetails.clear();
    QuerySnapshot leaveData = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .orderBy("applytime")
        .get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetailsForStudent
          .add(leaveObjectFromJson(json.encode(leaveData.docs[i].data())));

      QuerySnapshot studentData = await FirebaseFirestore.instance
          .collection("tbl_student")
          .where("email", isEqualTo: leaveDetailsForStudent[i].email)
          .get();
      studentDetails.add(
          studentObjectFromJson(json.encode(studentData.docs.first.data())));
    } //for

    return studentDetails;
  }

  StudentObject studentObject = StudentObject();
  Future<StudentObject> getLeaveStudent(String email) async {
    QuerySnapshot studentData = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("email", isEqualTo: email)
        .get();
    studentObject =
        (studentObjectFromJson(json.encode(studentData.docs.first.data())));

    return studentObject;
  }

  Future<List<UserInfoObj>> getUserDetail() async {
    userDetails.clear();
    QuerySnapshot leaveData = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .orderBy("applytime")
        .get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetailsForUser
          .add(leaveObjectFromJson(json.encode(leaveData.docs.first.data())));

      QuerySnapshot userData = await FirebaseFirestore.instance
          .collection("tbl_users")
          .where("email", isEqualTo: leaveDetailsForUser[i].email)
          .get();
      userDetails
          .add(userInfoObjFromJson(json.encode(userData.docs.first.data())));
    } //for

    //  for (int i = 0; i < leaveDetailsForUser.length; i++) {} //for

    return userDetails;
  }

  Future<void> updateLeaveStatus(int time, LeaveObject leaveObject) async {
    print(leaveObject.status);
    QuerySnapshot leaveQuery = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .where("applytime", isEqualTo: time)
        .get();
    leaveQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_leave")
            .doc(element.id)
            .update(leaveObject.toJson());
      },
    );
  }

  deleteLeave(String time) async {
    print(time);
    QuerySnapshot leaveQuery = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .where("time", isEqualTo: time)
        .get();
    leaveQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_leave")
            .doc(element.id)
            .delete();
      },
    );
  }

  int time;
  Future<LeaveObject> getParticularLeave() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_leave")
        .where("applytime", isEqualTo: time)
        .get();
    return leaveObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  countLeave() async {
    QuerySnapshot countLeave =
        await FirebaseFirestore.instance.collection("tbl_leave").get();
    return countLeave.docs.length.toString();
  }
}
