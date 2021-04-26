import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/syllabusObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SyllabusProvider extends ChangeNotifier {
  static createSyllabusTable() {
    FirebaseFirestore.instance.collection("tbl_syllabus");
  }

  List<SyllabusObject> syllabusDetails = [];
  String detailTime;
  SyllabusObject particularSyllabus = SyllabusObject();

  addSyllabus(SyllabusObject syllabusObject) {
    createSyllabusTable();
    FirebaseFirestore.instance.collection("tbl_syllabus").add({
      "title":syllabusObject.title,
      "time": syllabusObject.time,
      "docname": syllabusObject.docname,
      "path": syllabusObject.path,
      "sem": syllabusObject.sem,
      "Subject": syllabusObject.subject,
    });
  }

  Future<List<SyllabusObject>> getSyllabusDetail() async {
    syllabusDetails.clear();
    QuerySnapshot syllabusData =
        await FirebaseFirestore.instance.collection("tbl_syllabus").get();
    for (int i = 0; i < syllabusData.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      syllabusDetails.add(
          syllabusObjectFromJson(json.encode(syllabusData.docs[i].data())));
    } //for
    return syllabusDetails;
  }

  deleteSyllabus(SyllabusObject syllabusObject) async {
    // print(time);

    String filePath = syllabusObject.path.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/collegemanagementsystem-58017.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    Reference storageReference = FirebaseStorage.instance.ref();
    await storageReference.child(filePath).delete();

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("tbl_syllabus")
        .where("time", isEqualTo: syllabusObject.time)
        .get();
    query.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_syllabus")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Syllabus").child(filename);

    UploadTask uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() async {
      try {
        imageUrl = await reference.getDownloadURL();
      } catch (e) {
        print(e);
      }
      // print("URl: "+imageUrl);
    });
    return imageUrl;
  }

  // countNotice() async {
  //   QuerySnapshot countNotice =
  //       await FirebaseFirestore.instance.collection("tbl_syllabus").get();
  //   return countNotice.docs.length.toString();
  // }
}
