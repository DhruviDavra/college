import 'package:college_management_system/objects/leaveObject.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/leaveProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/screen/studentLeave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveDetail extends StatefulWidget {
  @override
  _LeaveDetailState createState() => _LeaveDetailState();
}

class _LeaveDetailState extends State<LeaveDetail> {
  void navigateToPage(BuildContext context) async {
   
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => StudentLeave()));
  }

  LeaveObject leaveObject = LeaveObject();
  
  String email;
  bool _isLoading;

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
    leaveObject = await Provider.of<LeaveProvider>(context, listen: false)
        .getParticularLeave();
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  StudentObject studentObject = StudentObject();
  UserInfoObj userInfoObj = UserInfoObj();

  @override
  void initState() {
    super.initState();
    getData();
  }

  final maxLines = 7;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Leave Detail"),
          backgroundColor: Colors.blueGrey[700],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              navigateToPage(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  userInfoObj.fname +
                                      " " +
                                      userInfoObj.mname +
                                      " " +
                                      userInfoObj.lname,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Roll Number: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentObject.rno.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Enrollment No: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentObject.enrollno,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Semester: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentObject.sem,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Text(
                                  "Division: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentObject.div,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  studentObject.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Apply Date: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Provider.of<LeaveProvider>(context,
                                          listen: false)
                                      .epochToLocal(leaveObject.applytime),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Title: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  leaveObject.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              "Description: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              leaveObject.des,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "To Date: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  leaveObject.toDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "From Date: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  leaveObject.fromDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  leaveObject.status,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
