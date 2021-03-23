import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:college_management_system/objects/feedbackObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackProvider extends ChangeNotifier {
  static createSeminarTable() {
    FirebaseFirestore.instance.collection("tbl_feedback");
  }

  List<FeedbackObject> feedbackDetails = [];

  // List<SeminarObject> seminarDetails = [];
  // String detailTime;

  // addSeminar(SeminarObject seminarObject) {
  //   createSeminarTable();
  //   FirebaseFirestore.instance.collection("tbl_seminar").add({
  //     "time": seminarObject.time,
  //     "topic": seminarObject.topic,
  //     "des": seminarObject.des,
  //     "sem": seminarObject.sem,
  //     "date": seminarObject.date,
  //     "seminar-time": seminarObject.seminarTime,
  //     "organizer": seminarObject.organizer,
  //     "speaker": seminarObject.speaker
  //   });
  // }

  // Future<List<SeminarObject>> getSeminarDetail() async {
  //   QuerySnapshot seminarData =
  //       await FirebaseFirestore.instance.collection("tbl_seminar").get();
  //   for (int i = 0; i < seminarData.docs.length; i++) {
  //     print(seminarData.docs[0].data()["topic"]);
  //     seminarDetails
  //         .add(seminarObjectFromJson(json.encode(seminarData.docs[i].data())));
  //   } //for
  //   return seminarDetails;
  // }

  // deleteSeminar(String time) async {
  //   print(time);
  //   QuerySnapshot teachingQuery = await FirebaseFirestore.instance
  //       .collection("tbl_seminar")
  //       .where("time", isEqualTo: time)
  //       .get();
  //   teachingQuery.docs.forEach(
  //     (element) async {
  //       await FirebaseFirestore.instance
  //           .collection("tbl_seminar")
  //           .doc(element.id)
  //           .delete();
  //     },
  //   );
  // }

String email;


  getParticularfeedback(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("email", isEqualTo: email)
        .get();
    return feedbackObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }


  Future<List<FeedbackObject>> findFeedback(String date) async {
    QuerySnapshot seminarData = await FirebaseFirestore.instance
        .collection("tbl_feedback")
        .where("date", isEqualTo: date)
        .get();
    for (int i = 0; i < seminarData.docs.length; i++) {
     // print(seminarData.docs[i].data()["email"]);
      feedbackDetails
          .add(feedbackObjectFromJson(json.encode(seminarData.docs[i].data())));
    } //for
    return feedbackDetails;
  }

  countFeedback() async {
    QuerySnapshot countFeedback =
        await FirebaseFirestore.instance.collection("tbl_feedback").get();
    return countFeedback.docs.length.toString();
  }
}
