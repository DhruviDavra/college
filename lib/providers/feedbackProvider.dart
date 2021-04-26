import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:college_management_system/objects/feedbackObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackProvider extends ChangeNotifier {
  static createFeedbackTable() {
    FirebaseFirestore.instance.collection("tbl_feedback");
  }

  List<FeedbackObject> feedbackDetails = [];
  List<FeedbackObject> allFeedbacks=[];
  List<FeedbackObject> feedbackStudentWise = [];
  String studentEmail;
  String uploadtime;
  String email;
  String time;
  bool isStudent = false;

  addFeedback(FeedbackObject feedbackObject) {
    createFeedbackTable();
    FirebaseFirestore.instance.collection("tbl_feedback").add({
      "email": feedbackObject.email,
      "des": feedbackObject.des,
      "date": feedbackObject.date,
      "time":feedbackObject.time,
    });
  }

  getParticularfeedback(String uploadtime) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("time", isEqualTo: uploadtime)
        .get();
    return feedbackObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  Future<List<FeedbackObject>> findFeedback(String date) async {
    QuerySnapshot feedbackData = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("date", isEqualTo: date)
        .get();
    for (int i = 0; i < feedbackData.docs.length; i++) {
      // print(seminarData.docs[i].data()["email"]);
      feedbackDetails
          .add(feedbackObjectFromJson(json.encode(feedbackData.docs[i].data())));
    } //for
    return feedbackDetails;
  }

   Future<List<FeedbackObject>> allFeedback() async {
     allFeedbacks.clear();
    QuerySnapshot feedbackData = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .orderBy("time")
        .get();
    for (int i = 0; i < feedbackData.docs.length; i++) {
       allFeedbacks
          .add(feedbackObjectFromJson(json.encode(feedbackData.docs[i].data())));
    } //for
    return allFeedbacks;
  }

  getParticularfeedbackStudentWise(String time) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("time", isEqualTo: time)
        .get();
    return feedbackObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  Future<List<FeedbackObject>> getFeedbackDetailStudentWise(
      String email) async {
        feedbackStudentWise.clear();
    print(email);
    QuerySnapshot feedbackData = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("email", isEqualTo: email)
        .get();
    for (int i = 0; i < feedbackData.docs.length; i++) {
      //  print(feedbackData.docs[i].data()["email"]);
      feedbackStudentWise.add(
          feedbackObjectFromJson(json.encode(feedbackData.docs[i].data())));
    } //for
    return feedbackStudentWise;
  }

  countFeedback() async {
    QuerySnapshot countFeedback =
        await FirebaseFirestore.instance.collection("tbl_feedback").get();
    return countFeedback.docs.length.toString();
  }
}
