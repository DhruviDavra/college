import 'dart:convert';
import 'dart:io';
import 'package:college_management_system/objects/bookObject.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookProvider extends ChangeNotifier {
  static createBookTable() {
    FirebaseFirestore.instance.collection("tbl_book");
  }

  List<BookObject> bookDetails = [];
  String detailTime;
  BookObject particularBook = BookObject();

  addBook(BookObject bookObject) {
    createBookTable();
    FirebaseFirestore.instance.collection("tbl_book").add({
      "title":bookObject.title,
      "time": bookObject.time,
      "docname": bookObject.docname,
      "path": bookObject.path,
      "sem": bookObject.sem,
      "Subject": bookObject.subject,
    });
  }

  Future<List<BookObject>> getBooksDetail() async {
    bookDetails.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("tbl_book").get();
    for (int i = 0; i < data.docs.length; i++) {
      //  print(noticeData.docs[0].data()["docname"]);
      bookDetails.add(
          bookObjectFromJson(json.encode(data.docs[i].data())));
    } //for
    return bookDetails;
  }

  deleteBook(BookObject bookObject) async {
    // print(time);

    String filePath = bookObject.path.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/collegemanagementsystem-58017.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    Reference storageReference = FirebaseStorage.instance.ref();
    await storageReference.child(filePath).delete();

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("tbl_book")
        .where("time", isEqualTo: bookObject.time)
        .get();
    query.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_book")
            .doc(element.id)
            .delete();
      },
    );
  }

  String imageUrl;
  Future<String> uploadFile(String filename, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("Books").child(filename);

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
