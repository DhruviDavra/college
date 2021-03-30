import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserProvider extends ChangeNotifier {
  UserProvider() {
   // fetchutypeFromSP();
  }
  static createUserTable() {
    FirebaseFirestore.instance.collection("tbl_users");
  }

  String eMsg = " ";
  String userId;
  String utype = " ";
  // fetchutypeFromSP() async {
  //   print('called');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   utype = prefs.getString('utype') ?? '';
  //   print(utype);
  // }

  addUser(UserInfoObj userObj) {
   try{
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
   catch(e){
     throw e;
   }
  }

  Future<dynamic> signIn(String email, String pwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        eMsg = 'No user found for that email.';
        print(eMsg);
      } else if (e.code == 'wrong-password') {
        eMsg = 'Wrong password provided for that user.';
        print(eMsg);
      }
      throw eMsg;
    } catch (e) {
      print(e.toString());
      // return null;
      throw e;
    }
  }

  Future<String> createUser(String email, String pwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        eMsg = 'The password provided is too weak.';
        print(eMsg);
      } else if (e.code == 'email-already-in-use') {
        eMsg = 'The account already exists for that email.';
        print(eMsg);
      }
      throw eMsg;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  void changePassword(String password) async {
    //Create an instance of the current user.
    User user = FirebaseAuth.instance.currentUser;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
    });
  }

  Future<void> passwordReset(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> fetchUserType() async {
    final User user = FirebaseAuth.instance.currentUser;
    userId = user.uid;
    print(userId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("uid", isEqualTo: userId)
        .get();
    // print("length");
    print(querySnapshot.docs[0].data()["utype"]);
    utype = querySnapshot.docs[0].data()["utype"];
  }

  Future<UserInfoObj> getUserDetail() async {
    final User user = FirebaseAuth.instance.currentUser;
    userId = user.uid;
    print(userId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("tbl_users")
        .where("uid", isEqualTo: userId)
        .get();

    return userInfoObjFromJson(json.encode(querySnapshot.docs.first.data()));
    //print(querySnapshot.docs[0].data()["dob"]);
  }
}
//  Future<void> didChangeDependencies() async {
//     super.didChangeDependencies();

//     catData = await FirebaseFirestore.instance.collection("Catagory").get();

//     for (int i = 0; i < catData.docs.length; i++) {
//       catagoryList.add(catData.docs[i].data()["Title"]);
//     }
//     print(catagoryList.length);
//   }
// Future<QuerySnapshot> checkUser(String uname, String pwd) async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection("tbl_users")
//       .where("uname", isEqualTo: uname)
//       .where("password", isEqualTo: pwd)
//       .get();
//   return querySnapshot;
// }
