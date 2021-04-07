import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homeScreen.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StudentDetail extends StatefulWidget {
  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  String email;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    email = Provider.of<StudentProvider>(context, listen: false).profileEmail;
    // print(email);
    studentObject = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularStudent(email);
    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);
  
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  StudentObject studentObject = StudentObject();
  UserInfoObj userInfoObj = UserInfoObj();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: _isLoading
                  ?Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                      ),
                      SpinKitChasingDots(
                        color:Colors.blueGrey,
                      ),
                    ],
                  )
                 
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Icon(
                          Icons.account_circle_sharp,
                          color: Colors.blueGrey[700],
                          size: 100,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          userInfoObj.fname +
                              " " +
                              userInfoObj.mname +
                              " " +
                              userInfoObj.lname,
                          //                  name,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Roll No:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(studentObject.rno.toString()),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Enrollment No:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(studentObject.enrollno),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Email:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(userInfoObj.email),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Division:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                studentObject.div,
                                //       email,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Semester:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(studentObject.sem),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Academic Year:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(studentObject.acadamicYear),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Contact No:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(userInfoObj.cno),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
