import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/examProvider.dart';
import 'package:college_management_system/objects/examObject.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'result.dart';

class StudentExam extends StatefulWidget {
  @override
  _StudentExamState createState() => _StudentExamState();
}

class _StudentExamState extends State<StudentExam> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  bool _isLoading = false;
  bool _isInternalEmpty = false;
  bool _isExternalEmpty = false;
  String sem;
  String etype;
  int total;
  int totalForResult;
  List<int> subCode = [];
  List<TextEditingController> marksCon = [];
  List<String> erno = [];
  String selectedErno;
  List<int> marks = [];
  ExamObject examObject = ExamObject();
  UserInfoObj userInfoObj = UserInfoObj();
  String msg = "";
  Future<void> getData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    marks.clear();
    etype = "Internal";
    total = 30;

    sem = await Provider.of<StudentProvider>(context, listen: false)
        .getSemester();

    subCode = await Provider.of<ExamProvider>(context, listen: false)
        .getSubCodeSemWise(sem);

    selectedErno = await Provider.of<StudentProvider>(context, listen: false)
        .getEnrollment();

    String email =
        Provider.of<StudentProvider>(context, listen: false).profileEmail;

    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);
    await getInternalData();
    // print(erno);
    print(subCode);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<dynamic> getInternalData() async {
    try {
      examObject = await Provider.of<ExamProvider>(context, listen: false)
          .getInternalMarks(selectedErno);

      setState(() {
        marks.clear();
        totalForResult = 0;
        for (int i = 0; i < examObject.marks.length; i++) {
          marks.add(examObject.marks[i]);
          totalForResult += examObject.marks[i];
        }
      });
    } catch (e) {
      msg = "There is No Data !!!";
    }
    if (examObject == null) {
      _isInternalEmpty = true;
    } else {
      _isInternalEmpty = false;
    }
  }

  Future<dynamic> getExternalData() async {
    try {
      examObject = await Provider.of<ExamProvider>(context, listen: false)
          .getExternalMarks(selectedErno);

      setState(() {
        marks.clear();
        totalForResult = 0;
        for (int i = 0; i < examObject.marks.length; i++) {
          marks.add(examObject.marks[i]);
          totalForResult += examObject.marks[i];
        }
      });
    } catch (e) {
      msg = "There is No Data !!!";
    }
    if (examObject == null) {
      _isExternalEmpty = true;
    } else {
      _isExternalEmpty = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            backgroundColor: Colors.blueGrey[700],
            title: Text(" Exam Result"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blueGrey[500],
                  child: Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RaisedButton(
                          color: Colors.blueGrey[500],
                          child: Text(
                            "Internal",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              etype = "Internal";
                              total = 30;
                            });

                            await getInternalData();
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RaisedButton(
                          color: Colors.blueGrey[500],
                          child: Text(
                            "External",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              etype = "External";
                              total = 70;
                            });
                            await getExternalData();
                          },
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
                    : Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Name :  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  userInfoObj.fname +
                                      " " +
                                      userInfoObj.mname +
                                      " " +
                                      userInfoObj.lname,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Enrollment No :  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  selectedErno,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  msg != ""
                                      ? Text(msg)
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              // height: MediaQuery.of(context).size.height * 0.2,

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '       SubCode',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '    Total Marks',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '  Obtained Marks',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: subCode.length,
                                                itemBuilder: (context, i) =>
                                                    Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              subCode[i]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              total.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              marks[i]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.001,
                            // ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  msg != ""
                                      ? Text(msg)
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              // height: MediaQuery.of(context).size.height * 0.2,

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '          Total : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      (total*subCode.length).toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      totalForResult.toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          bottomSheet: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StudentResult()));
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.blueGrey[200],
              child: Center(
                child: Text(
                  "Show Your Result",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
