import 'dart:convert';
import 'package:college_management_system/objects/attendanceObject.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceProvider extends ChangeNotifier {
  static createAttendanceTable() {
    FirebaseFirestore.instance.collection("tbl_attendance");
  }

  List<AttendanceObject> attendanceDetails = [];
  List<AttendanceObject> particularDate = [];
  String detailTime;
  String selectedSem;
  int selectedSub;
  int selectedSubjectForStudent;
  String date;
  String studentEmail;

  addAttendance(AttendanceObject attendanceObject) {
    createAttendanceTable();
    FirebaseFirestore.instance.collection("tbl_attendance").add({
      "email": attendanceObject.email,
      "time": attendanceObject.date,
      "subCode": attendanceObject.subCode,
      "status": attendanceObject.status,
    });
  }

  Future<List<AttendanceObject>> findAttendance(String date) async {
    print("date: " + date);
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_attendance")
        .where("time", isEqualTo: date)
        .where("subCode", isEqualTo: selectedSubjectForStudent)
        .get();
    print(data.docs.length);
    particularDate = data.docs
        .map((e) => attendanceObjectFromJson(json.encode(e.data())))
        .toList();

    return particularDate;
  }

   Future<List<AttendanceObject>> getAttendanceSubjectWise(int subject) async {
     QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_attendance")
        .where("subCode", isEqualTo: subject)
        .get();
    print(data.docs.length);
    particularDate = data.docs
        .map((e) => attendanceObjectFromJson(json.encode(e.data())))
        .toList();

    return particularDate;
  }

  Future<String> getSubjectname() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_subject")
        .where("subCode", isEqualTo: selectedSubjectForStudent)
        .get();

    return querySnapshot.docs.first.data()["subName"];
  }
}
