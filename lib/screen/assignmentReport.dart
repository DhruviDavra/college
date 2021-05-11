// import 'package:college_management_system/screen/temp.dart';
import 'package:college_management_system/objects/assignmentSubmissionObject.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/assignmentSubmissionProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';

class AssignmentReport extends StatefulWidget {
  @override
  _AssignmentReportState createState() => _AssignmentReportState();
}

class _AssignmentReportState extends State<AssignmentReport> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  bool _isLoading = false;

  List<UserInfoObj> userData = [];
  List<StudentObject> studentdata = [];
  List<AssignmentSubmissionObject> submittedAssignments = [];
  List<StudentObject> remainingStudent = [];

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

    submittedAssignments =
        await Provider.of<AssignmentSubmissionProvider>(context, listen: false)
            .getAssignmentDetailSubjectWiswForReport();

    studentdata = await Provider.of<StudentProvider>(context, listen: false)
        .getStudentDetailOfA(submittedAssignments.first.sem);

    for (int i = 0; i < studentdata.length; i++) {
      for (int j = 0; j < submittedAssignments.length; j++) {
        if (submittedAssignments
            .any((stud) => stud.email.contains(studentdata[i].email))) {
          continue;
        } else {
          remainingStudent.add(studentdata[i]);
        }
      }
    }

    if (mounted)
      setState(() {
        _isLoading = false;
      });
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
            title: Text('Assignment Report'),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
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
                            itemCount: remainingStudent.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Roll No. : " +
                                                remainingStudent[i]
                                                    .rno
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                             Text(
                                            "Div : " +
                                                remainingStudent[i]
                                                    .div,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            remainingStudent[i].email,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    // borderRadius: BorderRadius.circular(15),
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
        ),
      ),
    );
  }
}
