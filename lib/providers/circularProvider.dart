import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/circularObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CircularProvider extends ChangeNotifier {
  static createBookTable() {
    FirebaseFirestore.instance.collection("tbl_circular");
  }

  List<CircularObject> circularDetails = [];
  String detailTime;
  CircularObject particularBook = CircularObject();

  addCircular(CircularObject circularObject) {
    createBookTable();
    FirebaseFirestore.instance.collection("tbl_circular").add({
      "title": circularObject.title,
      "time": circularObject.time,
      "des": circularObject.des,
      "path": circularObject.path,
      "utype": circularObject.utype,
      "Subject": circularObject.subject,
    });
  }

  Future<List<CircularObject>> getBooksDetail() async {
    circularDetails.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_circular").get();
    for (int i = 0; i < data.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      circularDetails
          .add(circularObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return circularDetails;
  }

  Future<List<CircularObject>> getCircularForStudent() async {
    circularDetails.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_circular").get();
    for (int i = 0; i < data.docs.length; i++) {
      List<CircularObject> temp = [];
      temp.add(circularObjectFromJson(json.encode(data.docs[i].data())));
      if (temp.any((circular) => circular.utype.contains("Student"))) {
        circularDetails
            .add(circularObjectFromJson(json.encode(data.docs[i].data())));
      }
    } //for
    return circularDetails;
  }

 Future<List<CircularObject>> getCircularForFaculty() async {
    circularDetails.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_circular").get();
    for (int i = 0; i < data.docs.length; i++) {
      List<CircularObject> temp = [];
      temp.add(circularObjectFromJson(json.encode(data.docs[i].data())));
      if (temp.any((circular) => circular.utype.contains("Faculty"))) {
        circularDetails
            .add(circularObjectFromJson(json.encode(data.docs[i].data())));
      }
    } //for
    return circularDetails;
  }

  deleteBook(CircularObject circularObject) async {
    // print(time);

    String filePath = circularObject.path.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/collegemanagementsystem-58017.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    Reference storageReference = FirebaseStorage.instance.ref();
    await storageReference.child(filePath).delete();

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("tbl_circular")
        .where("time", isEqualTo: circularObject.time)
        .get();
    query.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_circular")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Circular").child(filename);

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
