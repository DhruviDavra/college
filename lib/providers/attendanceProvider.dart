import 'dart:convert';
import 'package:college_management_system/objects/attendanceObject.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceProvider extends ChangeNotifier {
  static createAttendanceTable() {
    FirebaseFirestore.instance.collection("tbl_attendance");
  }

  List<AttendanceObject> attendanceDetails = [];
  String detailTime;
  String selectedSem;
  int selectedSub;

  addAttendance(AttendanceObject attendanceObject) {
    createAttendanceTable();
    FirebaseFirestore.instance.collection("tbl_attendance").add({
      "email": attendanceObject.email,
      "time": attendanceObject.date,
      "subCode": attendanceObject.subCode,
      "status": attendanceObject.status,
    });
  }

  Future<List<AttendanceObject>> getSeminarDetail() async {
    attendanceDetails.clear();
    QuerySnapshot seminarData =
        await FirebaseFirestore.instance.collection("tbl_attendance").get();
    for (int i = 0; i < seminarData.docs.length; i++) {
      print(seminarData.docs[0].data()["topic"]);
      attendanceDetails.add(
          attendanceObjectFromJson(json.encode(seminarData.docs[i].data())));
    } //for
    return attendanceDetails;
  }

  updateAttendance(String time, AttendanceObject seminarObject) async {
    QuerySnapshot seminarQuery = await FirebaseFirestore.instance
        .collection("tbl_attendance")
        .where("time", isEqualTo: time)
        .get();
    seminarQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_attendance")
            .doc(element.id)
            .update(seminarObject.toJson());
      },
    );
  }
}
