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
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_attendance")
        .where("time", isEqualTo: date)
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      // print(seminarData.docs[i].data()["email"]);
      particularDate
          .add(attendanceObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return particularDate;
  }

   Future<List<AttendanceObject>> allFeedback() async {
     particularDate.clear();
    QuerySnapshot feedbackData = await FirebaseFirestore.instance
        .collection("tbl_attendance")
        .orderBy("time")
        .get();
    for (int i = 0; i < feedbackData.docs.length; i++) {
       particularDate
          .add(attendanceObjectFromJson(json.encode(feedbackData.docs[i].data())));
    } //for
    return particularDate;
  }


}
