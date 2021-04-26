import 'dart:convert';
import 'package:college_management_system/objects/subjectObject.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectProvider extends ChangeNotifier {
  List<SubjectObject> subjectDetails = [];
  List<SubjectObject> subjectDetailsSemWise = [];
  String detailTime;

  Future<List<SubjectObject>> getSubjectDetail() async {
    subjectDetails.clear();
    QuerySnapshot seminarData = await FirebaseFirestore.instance
        .collection("tbl_subject")
        .orderBy("subCode")
        .get();
        print(seminarData.docs.first.data());
    for (int i = 0; i < seminarData.docs.length; i++) {
      subjectDetails
          .add(subjectObjectFromJson(json.encode(seminarData.docs[i].data())));
    } //for
    return subjectDetails;
  }

  
  Future<List<SubjectObject>> getSubjectDetailSemWise(String sem) async {
    subjectDetailsSemWise.clear();
    QuerySnapshot subjectData = await FirebaseFirestore.instance
        .collection("tbl_subject")
        .where("sem",isEqualTo: sem)
        .orderBy("subCode")
        .get();
        print(subjectData.docs.first.data());
    for (int i = 0; i < subjectData.docs.length; i++) {
      subjectDetailsSemWise
          .add(subjectObjectFromJson(json.encode(subjectData.docs[i].data())));
    } //for
    return subjectDetailsSemWise;
  }



}
