import 'package:college_management_sysytem/Screen/signup.dart';
import 'package:college_management_sysytem/Screen/studentHome.dart';

import './forgotPassword.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool rememberValue = false;
  bool _forgotPressed = false;

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
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09,
                  ),
                  color: Colors.blue[100],
                  child: Text(
                    "Welcome to Smt. Tanuben & Dr. Manubhai Trivedi Colllege of Computer Science",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Icon(
                        Icons.account_circle,
                        size: MediaQuery.of(context).size.height * 0.08,
                        color: Colors.blue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.blue,
                                ),
                                hintText: " Username",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.blue,
                                ),
                                hintText: " Password",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: this.rememberValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      this.rememberValue = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Remember Me",
                                ),
                              ],
                            ),
                          ),
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
                              color:
                                  _forgotPressed ? Colors.blue : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(onPressed: () {
                        Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => signup()));
                      },
                      child: Text("Sign UP"),
                      ),
                      RaisedButton(onPressed: () {
                        Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => StudentHome()));
                      },
                      child: Text("Admin"),
                      ),
                    ],
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
