import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/leaveObject.dart';
import 'package:intl/intl.dart';

class LeaveProvider extends ChangeNotifier {
  static createLeaveTable() {
    FirebaseFirestore.instance.collection("tbl_leave");
  }

  List<LeaveObject> leaveDetails = [];
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
    QuerySnapshot leaveData =
        await FirebaseFirestore.instance.collection("tbl_leave").get();
    for (int i = 0; i < leaveData.docs.length; i++) {
      leaveDetails
          .add(leaveObjectFromJson(json.encode(leaveData.docs[i].data())));
    } //for
    return leaveDetails;
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

  // countLeave() async {
  //   QuerySnapshot countSeminar =
  //       await FirebaseFirestore.instance.collection("tbl_seminar").get();
  //   return countSeminar.docs.length.toString();
  // }
}
