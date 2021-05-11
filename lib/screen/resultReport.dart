// import 'package:college_management_system/screen/temp.dart';
import 'package:college_management_system/objects/examObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/examProvider.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/objects/studentObject.dart';

class ResultReport extends StatefulWidget {
  @override
  _ResultReportState createState() => _ResultReportState();
}

class _ResultReportState extends State<ResultReport> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  bool _isLoading = false;

  List<ExamObject> internalData = [];
  List<ExamObject> externalData = [];
  List<UserDetail> userDetail = [];

  int totalForSGPA = 0;
  int totalCredit = 0;

  List<int> credit = [];
  List<double> perList = [];
  List<double> sgpaList = [];

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  String sem;

  List<int> subCode = [];
  QuerySnapshot semData;
  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    sem = Provider.of<ExamProvider>(context, listen: false).semForResult;

    subCode = await Provider.of<ExamProvider>(context, listen: false)
        .getSubCodeSemWise(sem);

    credit = await Provider.of<ExamProvider>(context, listen: false)
        .getCreditSemWise(sem);

    internalData = await Provider.of<ExamProvider>(context, listen: false)
        .allInternalSemWise();

    externalData = await Provider.of<ExamProvider>(context, listen: false)
        .allExternalSemWise();

    for (int i = 0; i < internalData.length || i < externalData.length; i++) {
      int totalofInternal = 0;
      for (int j = 0; j < internalData[i].marks.length; j++) {
        totalofInternal += internalData[i].marks[j];
      }
      int totalofExternal = 0;
      for (int k = 0; k < externalData[i].marks.length; k++) {
        totalofExternal += externalData[i].marks[k];
      }

      perList.add((100 * (totalofInternal + totalofExternal)) /
          ((internalData[i].total * subCode.length) +
              (externalData[i].total * subCode.length)));

      for (int m = 0; m < subCode.length; m++) {
        double temp;
        int g;
        temp = (100 * (internalData[i].marks[m] + externalData[i].marks[m])) /
            (internalData[i].total + externalData[i].total);

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

        totalForSGPA += g * credit[m];
        totalCredit += credit[m];
      }

      sgpaList.add(totalForSGPA / totalCredit);
    }

    for (int k = 0; k < internalData.length; k++) {
      UserDetail tempUser = UserDetail();

      tempUser.studentObject =
          await Provider.of<StudentProvider>(context, listen: false)
              .getParticularStudentForResult(internalData[k].erno);

      tempUser.userInfoObj =
          await Provider.of<StudentProvider>(context, listen: false)
              .getParticularUser(tempUser.studentObject.email);

      tempUser.per = perList[k];
      tempUser.sgpa = sgpaList[k];

      userDetail.add(tempUser);
      print(userDetail.length);
    }

    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
  }

  percentageWise() {
    Comparator<UserDetail> comparator = (b,a) => a.per.compareTo(b.per);

    setState(() {
      userDetail.sort(comparator);
      //  print(userDetail);
    });
  }

  sgpaWise() {
    Comparator<UserDetail> comparator = (b,a) => a.sgpa.compareTo(b.sgpa);

    setState(() {
      userDetail.sort(comparator);
      // print(userDetail);
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
            title: Text('Result Report'),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            percentageWise();
                          },
                          child: Text(
                            "Top 10 Percentage Wise",
                          ),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            sgpaWise();
                          },
                          child: Text(
                            "Top 10 SGPA Wise",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.94,
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
                            itemCount:11,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userDetail[i].userInfoObj.fname +
                                                " " +
                                                userDetail[i]
                                                    .userInfoObj
                                                    .mname +
                                                " " +
                                                userDetail[i].userInfoObj.lname,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Percentage: " +
                                                    userDetail[i]
                                                        .per
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "SGPA: " +
                                                    userDetail[i]
                                                        .sgpa
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
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

class UserDetail {
  StudentObject studentObject;
  UserInfoObj userInfoObj;
  double per;
  double sgpa;
}
