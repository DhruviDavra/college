// import 'package:college_management_system/screen/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/subjectProvider.dart';
import 'package:college_management_system/objects/subjectObject.dart';
import 'package:college_management_system/providers/attendanceProvider.dart';
import 'manageAttendance.dart';

class AttendanceSub extends StatefulWidget {
  @override
  _AttendanceSubState createState() => _AttendanceSubState();
}

class _AttendanceSubState extends State<AttendanceSub> {
  void navigateToPage(BuildContext context) async {
    subject.clear();

    Navigator.of(context).pop();
  }

  bool _isLoading = false;

  List<SubjectObject> subject = [];

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
    subject.clear();
    subject = await Provider.of<SubjectProvider>(context, listen: false)
        .getSubjectDetail();
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
            title: Text('Subject'),
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
                            itemCount: subject.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<AttendanceProvider>(context,
                                                  listen: false)
                                              .selectedSub =
                                          subject[i].subCode;
                                      print(subject[i].subCode);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Attendence()));
                                    },
                                    child: Row(
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
                                          subject[i].subName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
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
