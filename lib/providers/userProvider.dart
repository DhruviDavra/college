import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  static createUserTable() {
    FirebaseFirestore.instance.collection("tbl_users");
  }

  addUser(UserInfoObj userObj) {
    UserProvider.createUserTable();
    FirebaseFirestore.instance.collection("tbl_users").add({
      "uid": userObj.uid,
      "fname": userObj.fname,
      "mname": userObj.mname,
      "lname": userObj.lname,
      "dob": userObj.dob,
      "cno": userObj.cno,
      "email": userObj.email,
      "password": userObj.password,
      "utype": userObj.utype
    });
  }

  signInWithEmailAndPassword(String email, String pwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      print("singed in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  // Future<QuerySnapshot> checkUser(String uname, String pwd) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("tbl_users")
  //       .where("uname", isEqualTo: uname)
  //       .where("password", isEqualTo: pwd)
  //       .get();
  //   return querySnapshot;
  // }
}
