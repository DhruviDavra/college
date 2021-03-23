import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:college_management_system/objects/seminarObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeminarProvider extends ChangeNotifier {
  static createSeminarTable() {
    FirebaseFirestore.instance.collection("tbl_seminar");
  }

  List<SeminarObject> seminarDetails = [];
  String detailTime;

  addSeminar(SeminarObject seminarObject) {
    createSeminarTable();
    FirebaseFirestore.instance.collection("tbl_seminar").add({
      "time": seminarObject.time,
      "topic": seminarObject.topic,
      "des": seminarObject.des,
      "sem": seminarObject.sem,
      "date": seminarObject.date,
      "seminar-time": seminarObject.seminarTime,
      "organizer": seminarObject.organizer,
      "speaker": seminarObject.speaker
    });
  }

  Future<List<SeminarObject>> getSeminarDetail() async {
    QuerySnapshot seminarData =
        await FirebaseFirestore.instance.collection("tbl_seminar").get();
    for (int i = 0; i < seminarData.docs.length; i++) {
      print(seminarData.docs[0].data()["topic"]);
      seminarDetails
          .add(seminarObjectFromJson(json.encode(seminarData.docs[i].data())));
    } //for
    return seminarDetails;
  }

  updateSeminar(String time, SeminarObject seminarObject) async {
    //  print(time);
    print(seminarObject.topic);
    print(seminarObject.des);
    print(seminarObject.sem);
    print(seminarObject.date);
    print(seminarObject.seminarTime);
    print(seminarObject.time);
    print(seminarObject.organizer);
    print(seminarObject.speaker);
    print(seminarObject.sem);
    QuerySnapshot seminarQuery = await FirebaseFirestore.instance
        .collection("tbl_seminar")
        .where("time", isEqualTo: time)
        .get();
    print(seminarObject.topic);
    seminarQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_seminar")
            .doc(element.id)
            .update(seminarObject.toJson());
      },
    );
  }

  getParticularSeminar(String time) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_seminar")
        .where("time", isEqualTo: time)
        .get();
    return seminarObjectFromJson(json.encode(querySnapshot.docs.first.data()));
  }

  deleteSeminar(String time) async {
    print(time);
    QuerySnapshot teachingQuery = await FirebaseFirestore.instance
        .collection("tbl_seminar")
        .where("time", isEqualTo: time)
        .get();
    teachingQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_seminar")
            .doc(element.id)
            .delete();
      },
    );
  }

  countSeminar() async {
    QuerySnapshot countSeminar =
        await FirebaseFirestore.instance.collection("tbl_seminar").get();
    return countSeminar.docs.length.toString();
  }
}
