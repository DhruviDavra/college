// import 'package:college_management_system/screen/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/semesterProvider.dart';
import 'package:college_management_system/objects/semesterObject.dart';
import 'package:college_management_system/providers/attendanceProvider.dart';
import 'manageAttendanceSubject.dart';
import 'package:college_management_system/providers/studentProvider.dart';

class AttendanceSem extends StatefulWidget {
  @override
  _AttendanceSemState createState() => _AttendanceSemState();
}

class _AttendanceSemState extends State<AttendanceSem> {
  void navigateToPage(BuildContext context) async {
    semester.clear();

    Navigator.of(context).pop();
  }

  bool _isLoading = false;
  String div;
  List<SemesterObject> semester = [];

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
    semester.clear();
    semester = await Provider.of<SemesterProvider>(context, listen: false)
        .getSemesterDetail();
    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
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
            title: Text('Students'),
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
                            itemCount: semester.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          Text(
                                            semester[i].sem,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 13,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Provider.of<AttendanceProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedSem =
                                                  semester[i].sem;
                                              Provider.of<StudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .div = "A";
                                            ///  print("A");
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendanceSub()));
                                            },
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              child: Text(
                                                "Division A",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<AttendanceProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedSem =
                                                  semester[i].sem;
                                              Provider.of<StudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .sem = semester[i].sem;

                                              Provider.of<StudentProvider>(
                                                      context,
                                                      listen: false)
                                                  .div = "B";
                                              //print("B");
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendanceSub()));
                                            },
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              child: Text(
                                                "Division B",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[400],
                                    borderRadius: BorderRadius.circular(15),
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
