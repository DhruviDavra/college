import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/assignmentObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AssignmentProvider extends ChangeNotifier {
  static createAssignmentTable() {
    FirebaseFirestore.instance.collection("tbl_assignment");
  }

  List<AssignmentObject> assignmentDetail = [];
  String detailTime;
  AssignmentObject particularAssignment = AssignmentObject();

  addAssignment(AssignmentObject assignmentObject) {
    createAssignmentTable();
    FirebaseFirestore.instance.collection("tbl_assignment").add({
      "title":assignmentObject.title,
      "time": assignmentObject.time,
      "docname": assignmentObject.docname,
      "path": assignmentObject.path,
      "sem": assignmentObject.sem,
      "Subject": assignmentObject.subject,
      "des":assignmentObject.des,
      "asno":assignmentObject.asno,
    });
  }

  Future<List<AssignmentObject>> getAssignmentDetail() async {
    assignmentDetail.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_assignment").get();
    for (int i = 0; i < data.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      assignmentDetail.add(
          assignmentObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return assignmentDetail;
  }

  deleteAssignment(AssignmentObject assignmentObject) async {
    // print(time);

    String filePath = assignmentObject.path.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/collegemanagementsystem-58017.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    Reference storageReference = FirebaseStorage.instance.ref();
    await storageReference.child(filePath).delete();

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("tbl_assignment")
        .where("time", isEqualTo: assignmentObject.time)
        .get();
    query.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_assignment")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Assignments").child(filename);

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
