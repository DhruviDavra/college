import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:college_management_system/objects/examObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamProvider extends ChangeNotifier {
  static createInternalExamTable() {
    FirebaseFirestore.instance.collection("tbl_internalExam");
  }

  static createExternalExamTable() {
    FirebaseFirestore.instance.collection("tbl_externalExam");
  }

  List<ExamObject> examDetails = [];
  List<ExamObject> allData = [];
  List<String> erno = [];
  // String studentEmail;
  // String uploadtime;
  // String email;
  // String time;
  // bool isStudent = false;
  String sem;
  String semForResult;
  String etype;
  List<int> subCode = [];
  List<int> credit = [];

  addInternalDetails(ExamObject examObject) {
    createInternalExamTable();
    FirebaseFirestore.instance.collection("tbl_internalExam").add({
      "erno": examObject.erno,
      "etype": examObject.etype,
      "sem": examObject.sem,
      "subcode": examObject.subcode,
      "total": examObject.total,
      "marks": examObject.marks,
      "time": examObject.time,
    });
  }

  addExternalDetails(ExamObject examObject) {
    createExternalExamTable();
    FirebaseFirestore.instance.collection("tbl_externalExam").add({
      "erno": examObject.erno,
      "etype": examObject.etype,
      "sem": examObject.sem,
      "subcode": examObject.subcode,
      "total": examObject.total,
      "marks": examObject.marks,
      "time": examObject.time,
    });
  }

  Future<List<int>> getSubCodeSemWise(String sem) async {
    subCode.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_subject")
        .where("sem", isEqualTo: sem)
        .orderBy("subCode")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      subCode.add(querySnapshot.docs[i].data()["subCode"]);
    } //for
    return subCode;
  }

  Future<List<int>> getCreditSemWise(String sem) async {
    credit.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_subject")
        .where("sem", isEqualTo: sem)
        .orderBy("subCode")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      credit.add(querySnapshot.docs[i].data()["credit"]);
    } //for
    return credit;
  }

  Future<List<String>> getErnoSemWise(String sem) async {
    erno.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: sem)
        .orderBy("rno")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      erno.add(querySnapshot.docs[i].data()["enrollno"]);
    } //for
    return erno;
  }

  Future<List<ExamObject>> allInternalSemWise() async {
    allData.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_internalExam")
        .where("sem", isEqualTo: semForResult)
        .orderBy("erno")
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      allData.add(examObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return allData;
  }

  Future<List<ExamObject>> allExternalSemWise() async {
    allData.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_externalExam")
        .where("sem", isEqualTo: semForResult)
        .orderBy("erno")
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      allData.add(examObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return allData;
  }

 Future<List<ExamObject>> userFromInternal() async {
    allData.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_externalExam")
        .where("sem", isEqualTo: semForResult)
        .orderBy("erno")
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      allData.add(examObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return allData;
  }


  getInternalMarks(String erno) async {
    ExamObject examObject = ExamObject();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_internalExam")
        .where("erno", isEqualTo: erno)
        .get();

    examObject = (examObjectFromJson(json.encode(data.docs.first.data())));
    return examObject;
  }

  Future<ExamObject> getExternalMarks(String erno) async {
    ExamObject examObject = ExamObject();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_externalExam")
        .where("erno", isEqualTo: erno)
        .get();

    examObject = (examObjectFromJson(json.encode(data.docs.first.data())));

    return examObject;
  }
}
