import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/screen/leaveDetail.dart';
import 'package:flutter/material.dart';
import 'package:college_management_system/objects/leaveObject.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/leaveProvider.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminLeave extends StatefulWidget {
  @override
  _AdminLeaveState createState() => _AdminLeaveState();
}

class _AdminLeaveState extends State<AdminLeave> {
  bool _isLoading = false;

  void navigateToPage(BuildContext context) async {
    leaveData.clear();
    studentData.clear();
    userData.clear();
    Navigator.of(context).pop();
  }

  List<LeaveObject> leaveData = [];
  List<StudentObject> studentData = [];
  List<UserInfoObj> userData = [];

  bool showfab = true;

  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    leaveData.clear();
    studentData.clear();
    userData.clear();
    leaveData = await Provider.of<LeaveProvider>(context, listen: false)
        .getLeaveDetail();

    studentData = await Provider.of<LeaveProvider>(context, listen: false)
        .getStudentDetail();

    userData = await Provider.of<LeaveProvider>(context, listen: false)
        .getUserDetail();

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    leaveData.clear();
    studentData.clear();
    userData.clear();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text('Leaves'),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: leaveData.length,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                print(studentData[i].email);
                                Provider.of<StudentProvider>(context,
                                        listen: false)
                                    .profileEmail = studentData[i].email;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LeaveDetail()));
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          " " +
                                              Provider.of<LeaveProvider>(
                                                      context,
                                                      listen: false)
                                                  .epochToLocal(
                                                      leaveData[i].applytime),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.23,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            color: Colors.white,
                                            onPressed: () async {
                                              leaveData[i].status = "Approved";
                                              print(leaveData[i].status);
                                              await Provider.of<LeaveProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateLeaveStatus(
                                                      leaveData[i].applytime,
                                                      leaveData[i]);
                                              setState(() {
                                                leaveData.clear();
                                                studentData.clear();
                                                userData.clear();
                                                fetchData();
                                              });
                                            },
                                            child: Text(
                                              "Approve",
                                              style: TextStyle(
                                                  color: Colors.green[800],
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            color: Colors.white,
                                            onPressed: () async {
                                              leaveData[i].status = "Rejected";
                                              print(leaveData[i].status);
                                              await Provider.of<LeaveProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateLeaveStatus(
                                                      leaveData[i].applytime,
                                                      leaveData[i]);
                                              setState(() {
                                                leaveData.clear();
                                                studentData.clear();
                                                userData.clear();
                                                fetchData();
                                              });
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      " Title: " + leaveData[i].title,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      " Status: " + leaveData[i].status,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      " Semester: " + studentData[i].sem,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                width: MediaQuery.of(context).size.width * 0.01,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          SpinKitChasingDots(
                            color: Colors.blueGrey,
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
