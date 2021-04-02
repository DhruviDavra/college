import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'package:college_management_system/screen/studentHome.dart';
import 'package:college_management_system/screen/teachingHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './adminHome.dart';
import 'nonTeachingHome.dart';
import './forgotPassword.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

 FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  String utype;
  final RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//  fetchutypeFromSP() async {
//     print('called');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     utype = prefs.getString('utype') ?? '';

//      await checkPlatform();
//   }

//    checkPlatform() {
//      print(utype);
//     if (utype == "Admin") {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => AdminHome()));
//     }
//     if (utype == "TeachingStaff") {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => TeachingHome()));
//     }
//     if (utype == "NonTeachingStaff") {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => NonTeachingHome()));
//     }
//     if (utype == "Student") {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => StudentHome()));
//     }
//   }

  bool _forgotPressed = false;
  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();
  QuerySnapshot checkuser;
  // String utype = " ";
  String uid = " ";
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('utype', utype);
    prefs.setString('uid', uid);
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                Image.asset(
                  "assets/images/logo.png",
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.height * 0.09,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "  Email Address",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailNode,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Enter Email Address",
                          ),
                          controller: emailCon,
                          validator: (value) {
                            if (!emailRegex.hasMatch(value)) {
                              // return 'Please enter valid email';
                              throw "Please enter valid email";
                            }
                            return null;
                          },
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          "  Password",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          obscureText: !this.showPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this.showPassword
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() =>
                                    this.showPassword = !this.showPassword);
                              },
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Enter Password",
                          ),
                          controller: pwdCon,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Spacer(),
                            Expanded(
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _forgotPressed = !_forgotPressed;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                                },
                                child: Text(
                                  'Forgot Password',
                                ),
                                color: Colors.white10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blueGrey,
                            onPressed: () async {
                              try {
                                // print(emailCon.text);
                                // print(pwdCon.text);

                                dynamic result =
                                    await Provider.of<UserProvider>(context,
                                            listen: false)
                                        .signIn(emailCon.text, pwdCon.text);

                                if (result == null) {
                                  print("Something went wrong!");
                                } else {
                                  print("Signed in");
                                  await Provider.of<UserProvider>(context,
                                          listen: false)
                                      .fetchUserType();

                                  utype = Provider.of<UserProvider>(context,
                                          listen: false)
                                      .utype;
                                  // print(utype);
                                  await addStringToSF();
                                  if (utype == "Admin") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AdminHome()));
                                  }
                                  if (utype == "TeachingStaff") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeachingHome()));
                                  }
                                  if (utype == "NonTeachingFaculty") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NonTeachingHome()));
                                  }
                                  if (utype == "Student") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentHome()));
                                  }
                                }
                              } catch (e) {
                                String eMsg;
                                print(e.toString());
                                eMsg = e.toString();
                                if (eMsg.isEmpty) {
                                  eMsg = "Something Went Wrong!!!";
                                }
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Alert!"),
                                    content: Text(
                                      eMsg,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
