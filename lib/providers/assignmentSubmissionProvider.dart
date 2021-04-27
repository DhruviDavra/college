import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/assignmentSubmissionObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AssignmentSubmissionProvider extends ChangeNotifier {
  static createAssignmentTable() {
    FirebaseFirestore.instance.collection("tbl_assignment_submission");
  }

  List<AssignmentSubmissionObject> assignmentDetail = [];
  String detailTime;
  AssignmentSubmissionObject particularAssignment = AssignmentSubmissionObject();

  addAssignment(AssignmentSubmissionObject assignmentObject) {
    createAssignmentTable();
    FirebaseFirestore.instance.collection("tbl_assignment_submission").add({
      "title":assignmentObject.title,
      "time": assignmentObject.time,
      "path": assignmentObject.path,
      "sem": assignmentObject.sem,
      "Subject": assignmentObject.subject,
    });
  }

  Future<List<AssignmentSubmissionObject>> getAssignmentDetail() async {
    assignmentDetail.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_assignment_submission").get();
    for (int i = 0; i < data.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      assignmentDetail.add(
          assignmentSubmissionObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return assignmentDetail;
  }

  deleteAssignment(AssignmentSubmissionObject assignmentObject) async {
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
        .collection("tbl_assignment_submission")
        .where("time", isEqualTo: assignmentObject.time)
        .get();
    query.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_assignment_submission")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Assignment_submission").child(filename);

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
