import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/noticeObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class NoticeProvider extends ChangeNotifier {
  static createNoticeTable() {
    FirebaseFirestore.instance.collection("tbl_notice");
  }

  List<NoticeObject> noticeDetails = [];
  String detailTime;
  NoticeObject particularNotice = NoticeObject();

 
  addNotice(NoticeObject noticeObject) {
    createNoticeTable();
    FirebaseFirestore.instance.collection("tbl_notice").add({
      "time": noticeObject.time,
      "docname": noticeObject.docname,
      "spath": noticeObject.spath,
    });
  }

  Future<List<NoticeObject>> getNoticeDetail() async {
    QuerySnapshot noticeData =
        await FirebaseFirestore.instance.collection("tbl_notice").get();
    for (int i = 0; i < noticeData.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      noticeDetails
          .add(noticeObjectFromJson(json.encode(noticeData.docs[i].data())));
    } //for
    return noticeDetails;
  }

  deleteNotice(NoticeObject noticeObject) async {
   // print(time);
  
    String filePath = noticeObject.spath.replaceAll(
          new RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/collegemanagementsystem-58017.appspot.com/o/'),
          '');
      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
      Reference storageReference = FirebaseStorage.instance.ref();
      await storageReference.child(filePath).delete();
   
    QuerySnapshot noticeQuery = await FirebaseFirestore.instance
        .collection("tbl_notice")
        .where("time", isEqualTo: noticeObject.time)
        .get();
    noticeQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_notice")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Notices").child(filename);

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

  countNotice() async {
    QuerySnapshot countNotice =
        await FirebaseFirestore.instance.collection("tbl_notice").get();
    return countNotice.docs.length.toString();
  }
}
