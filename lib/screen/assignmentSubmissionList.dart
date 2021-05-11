import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/semesterObject.dart';
import 'package:college_management_system/objects/subjectObject.dart';
import 'package:college_management_system/providers/semesterProvider.dart';
import 'package:college_management_system/providers/subjectProvider.dart';
import 'package:college_management_system/screen/AssignmentSubmittedDetail.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/assignmentSubmissionProvider.dart';
import 'package:college_management_system/objects/assignmentSubmissionObject.dart';

class AssignmentSubmission extends StatefulWidget {
  @override
  _AssignmentSubmissionState createState() => _AssignmentSubmissionState();
}

class _AssignmentSubmissionState extends State<AssignmentSubmission> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool _isLoading = false;
  TextEditingController filenameCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  TextEditingController asnoCon = TextEditingController();

  File file1;
  // NoticeObject noticeObject = NoticeObject();
  String filename;
  String filepath;
  String dateFromInt;
  String sem;
  String subject;

  AssignmentSubmissionObject assignmentObject = AssignmentSubmissionObject();

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

  List<SemesterObject> semester = [];
  List<SubjectObject> subjectList = [];
  List<String> semesterDetail = [];
  List<String> subjectDetail = [];
  List<AssignmentSubmissionObject> assignmentDetail = [];

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  QuerySnapshot semData;
  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    semesterDetail.clear();
    semester.clear();
    assignmentDetail.clear();
    assignmentDetail =
        await Provider.of<AssignmentSubmissionProvider>(context, listen: false)
            .getAssignmentDetail();

    semester = await Provider.of<SemesterProvider>(context, listen: false)
        .getSemesterDetail(); 

    for (int i = 0; i < semester.length; i++) {
      semesterDetail.add(semester[i].sem);
    }

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  fetchSubject() async {
    subjectList.clear();
    subjectDetail.clear();
    subjectList = await Provider.of<SubjectProvider>(context, listen: false)
        .getSubjectDetailSemWise(sem);

    for (int i = 0; i < subjectList.length; i++) {
      subjectDetail.add(subjectList[i].subName);
    }
  }

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
            title: Text("Assignment Submission"),
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.96,
                    child: _isLoading
                        ? Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              SpinKitChasingDots(
                                color: Colors.blueGrey,
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: assignmentDetail.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                padding: const EdgeInsets.all(7.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<AssignmentSubmissionProvider>(
                                                context,
                                                listen: false)
                                            .particularAssignment =
                                        assignmentDetail[i];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AssignmentSubmittedDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Title: " +
                                                assignmentDetail[i].title,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "Email: " +
                                                assignmentDetail[i].email,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "Subject: " +
                                                assignmentDetail[i].subject,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.16,
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
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}
