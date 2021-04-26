import 'dart:io';
import 'AssignmentDetail.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/assignmentProvider.dart';
import 'package:college_management_system/objects/assignmentObject.dart';
import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentAssignment extends StatefulWidget {
  @override
  _StudentAssignmentState createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  bool _isLoading = false;

  void navigateToPage(BuildContext context) async {
    noticeAll.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  File file1;
  AssignmentObject assignmentObject = AssignmentObject();
  String filename;
  String filepath;
  String dateFromInt;
  TextEditingController filenameCon = TextEditingController();
  Future getPdfAndUpload() async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg'],
    );
    if (file != null) {
      setState(() {
        file1 = file;

        filename = file1.path.split("/").last;
        print("filename: " + filename);
        filenameCon.text = filename;
      });
    }
  }

  List<AssignmentObject> noticeAll = [];

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  QuerySnapshot noticeData;
  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    noticeAll.clear();
    noticeAll = await Provider.of<AssignmentProvider>(context, listen: false)
        .getAssignmentDetail();

    // print(userAll.length);
    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
  }

  String epochToLocal(int epochTime) {
    try {
      DateTime localTime =
          DateTime.fromMillisecondsSinceEpoch(epochTime, isUtc: false);
      return DateFormat("dd-MM-yyyy").format(localTime).toString();
    } catch (e) {
      return "";
    }
  }

  bool showfab = true;
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
            title: Text("Assignments"),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.90,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: noticeAll.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<AssignmentProvider>(context,
                                            listen: false)
                                        .particularAssignment = noticeAll[i];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AssignmentDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: " + noticeAll[i].title,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "\n" +
                                                "Upload Date: " +
                                                epochToLocal(noticeAll[i].time),
                                          ),
                                        ],
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
                                              // leaveData[i].status = "Approved";
                                              // print(leaveData[i].status);
                                              // await Provider.of<LeaveProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .updateLeaveStatus(
                                              //         leaveData[i].applytime,
                                              //         leaveData[i]);
                                              // setState(() {
                                              //   leaveData.clear();
                                              //   studentData.clear();
                                              //   userData.clear();
                                              //   fetchData();
                                             // });
                                            },
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Colors.green[800],
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
