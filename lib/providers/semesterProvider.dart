import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:college_management_system/objects/semesterObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterProvider extends ChangeNotifier {
  List<SemesterObject> semesterDetails = [];
  String detailTime;

  Future<List<SemesterObject>> getSemesterDetail() async {
    QuerySnapshot seminarData = await FirebaseFirestore.instance
        .collection("tbl_semester")
        .orderBy("id")
        .get();
    for (int i = 0; i < seminarData.docs.length; i++) {
      semesterDetails
          .add(semesterObjectFromJson(json.encode(seminarData.docs[i].data())));
    } //for
    return semesterDetails;
  }

  countSemester() async {
    QuerySnapshot countSeminar =
        await FirebaseFirestore.instance.collection("tbl_semester").get();
    return countSeminar.docs.length.toString();
  }
}
