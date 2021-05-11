
import 'package:college_management_system/objects/feeObject.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeeProvider extends ChangeNotifier {
  static createFeeTable() {
    FirebaseFirestore.instance.collection("tbl_feeInfo");
  }

  List<FeeObject> feeDetails = [];
 // List<FeeObject> particularDate = [];
  String detailTime;
  String selectedDiv;
  String selectedSem;
 String studentEmail;

  addFeeData(FeeObject feeObject) {
    createFeeTable();
    FirebaseFirestore.instance.collection("tbl_feeInfo").add({
      "email": feeObject.email,
      "erno": feeObject.erno,
      "sem": feeObject.sem,
      "status": feeObject.status,
    });
  }
 Future<void> updateFeeStatus(String email, FeeObject feeObject) async {
    print(feeObject.status);
    QuerySnapshot leaveQuery = await FirebaseFirestore.instance
        .collection("tbl_feeInfo")
        .where("email", isEqualTo: email)
        .get();
    leaveQuery.docs.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection("tbl_feeInfo")
            .doc(element.id)
            .update(feeObject.toJson());
      },
    );
  }
 

}
