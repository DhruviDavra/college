import 'dart:io';

import 'package:college_management_system/objects/usersObject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/examProvider.dart';
import 'package:college_management_system/objects/examObject.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StudentResult extends StatefulWidget {
  @override
  _StudentResultState createState() => _StudentResultState();
}

class _StudentResultState extends State<StudentResult> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  bool _isLoading = false;
  int grade;
  String sem;
  String etype;
  int total;
  double sgpa;
  int totalofInternal;
  int totalCredit = 0;
  double per;
  String status;
  int totalofExternal;
  int totalForSGPA = 0;
  List<int> subCode = [];
  List<int> credit = [];
  List<TextEditingController> marksCon = [];
  List<String> erno = [];
  String selectedErno;
  List<int> markInternal = [];
  List<int> markExternal = [];
  ExamObject internalObject = ExamObject();
  ExamObject externalObject = ExamObject();
  UserInfoObj userInfoObj = UserInfoObj();
  String msg = "";
  final pdf = pw.Document();

  Future<void> getData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    markExternal.clear();
    markInternal.clear();

    sem = await Provider.of<StudentProvider>(context, listen: false)
        .getSemester();

    subCode = await Provider.of<ExamProvider>(context, listen: false)
        .getSubCodeSemWise(sem);

    credit = await Provider.of<ExamProvider>(context, listen: false)
        .getCreditSemWise(sem);

    selectedErno = await Provider.of<StudentProvider>(context, listen: false)
        .getEnrollment();

    String email =
        Provider.of<StudentProvider>(context, listen: false).profileEmail;

    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);
    await getInternalData();
    await getExternalData();
    print(subCode);

    per = (100 * (totalofInternal + totalofExternal)) /
        ((internalObject.total * subCode.length) +
            (externalObject.total * subCode.length));

    if (per <= 99 && per >= 90) {
      grade = 10;
    }
    if (per <= 89 && per >= 80) {
      grade = 9;
    }
    if (per <= 79 && per >= 70) {
      grade = 8;
    }
    if (per <= 69 && per >= 60) {
      grade = 7;
    }
    if (per <= 59 && per >= 50) {
      grade = 6;
    }
    if (per <= 49 && per >= 36) {
      grade = 5;
    }
    if (per < 36) {
      grade = 4;
    }
    if (grade > 4) {
      status = "Pass";
    } else {
      status = "Fail";
    }

    for (int i = 0; i < subCode.length; i++) {
      double temp;
      int g;
      temp = (100 * (internalObject.marks[i] + externalObject.marks[i])) /
          (internalObject.total + externalObject.total);

      if (temp <= 99 && temp >= 90) {
        g = 10;
      }
      if (temp <= 89 && temp >= 80) {
        g = 9;
      }
      if (temp <= 79 && temp >= 70) {
        g = 8;
      }
      if (temp <= 69 && temp >= 60) {
        g = 7;
      }
      if (temp <= 59 && temp >= 50) {
        g = 6;
      }
      if (temp <= 49 && temp >= 36) {
        g = 5;
      }
      if (temp < 36) {
        g = 4;
      }

      totalForSGPA += g * credit[i];
      totalCredit += credit[i];
    }

    sgpa = totalForSGPA / totalCredit;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<dynamic> getInternalData() async {
    try {
      internalObject = await Provider.of<ExamProvider>(context, listen: false)
          .getInternalMarks(selectedErno);

      setState(() {
        markInternal.clear();
        totalofInternal = 0;
        for (int i = 0; i < internalObject.marks.length; i++) {
          markInternal.add(internalObject.marks[i]);
          totalofInternal += internalObject.marks[i];
        }
      });
    } catch (e) {
      msg = "There is No Data !!!";
    }
  }

  Future<dynamic> getExternalData() async {
    try {
      externalObject = await Provider.of<ExamProvider>(context, listen: false)
          .getExternalMarks(selectedErno);

      setState(() {
        markExternal.clear();
        totalofExternal = 0;
        for (int i = 0; i < externalObject.marks.length; i++) {
          markExternal.add(externalObject.marks[i]);
          totalofExternal += externalObject.marks[i];
        }
      });
    } catch (e) {
      msg = "There is No Data !!!";
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
            title: Text("Result"),
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
                Image.asset(
                  "assets/images/logo.png",
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
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: EdgeInsets.only(top: 15),
                                child: Center(
                                  child: msg != ""
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      ' SubCode',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Internal Total',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Internal Marks',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'External Total',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'External Marks',
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
                                                              internalObject
                                                                  .total
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              markInternal[i]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              externalObject
                                                                  .total
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              markExternal[i]
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
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.001,
                            // ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                        '    Total : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        (internalObject.total *
                                                                subCode.length)
                                                            .toString(),
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
                                                        totalofInternal
                                                            .toString(),
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
                                                        (externalObject.total *
                                                                subCode.length)
                                                            .toString(),
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
                                                        totalofExternal
                                                            .toString(),
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
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        msg != ""
                                            ? Text(msg)
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.80,
                                                    // height: MediaQuery.of(context).size.height * 0.2,

                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Percentage:  " +
                                                                per.toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "SGPA:  " +
                                                                sgpa.toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 25,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: status == "Pass"
                                                  ? Colors.green[900]
                                                  : Colors.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.07,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    makePDF();
                  },
                  child: Text(
                    "download PDF",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makePDF() async {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));
    final file = File("Result.pdf");
    await file.writeAsBytes( pdf.save());
  }
}
