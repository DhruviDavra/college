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
List<String> erno=[];
  // String studentEmail;
  // String uploadtime;
  // String email;
  // String time;
  // bool isStudent = false;
  String sem;
  String etype;
  List<int> subCode=[];

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

 Future<List<int>>  getSubCodeSemWise(String sem) async {
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


 Future<List<String>>  getErnoSemWise(String sem) async {
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


  // getParticularfeedback(String uploadtime) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("tbl_feedback")
  //       .where("time", isEqualTo: uploadtime)
  //       .get();
  //   return examObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  // }

  Future<List<ExamObject>> allInternal() async {
    allData.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("tbl_internalExam")
        .orderBy("erno")
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      allData.add(examObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return allData;
  }

  // getParticularfeedbackStudentWise(String time) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("tbl_feedback")
  //       .where("time", isEqualTo: time)
  //       .get();
  //   return feedbackObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  // }

  // Future<List<FeedbackObject>> getFeedbackDetailStudentWise(
  //     String email) async {
  //       feedbackStudentWise.clear();
  //   print(email);
  //   QuerySnapshot feedbackData = await FirebaseFirestore.instance
  //       .collection("tbl_feedback")
  //       .where("email", isEqualTo: email)
  //       .get();
  //   for (int i = 0; i < feedbackData.docs.length; i++) {
  //     //  print(feedbackData.docs[i].data()["email"]);
  //     feedbackStudentWise.add(
  //         feedbackObjectFromJson(json.encode(feedbackData.docs[i].data())));
  //   } //for
  //   return feedbackStudentWise;
  // }

  // countFeedback() async {
  //   QuerySnapshot countFeedback =
  //       await FirebaseFirestore.instance.collection("tbl_feedback").get();
  //   return countFeedback.docs.length.toString();
  // }
}
