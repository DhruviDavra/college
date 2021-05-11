import 'package:college_management_system/objects/attendanceObject.dart';
import 'package:college_management_system/objects/attendanceReportObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/attendanceProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/providers/subjectProvider.dart';
import 'package:college_management_system/objects/subjectObject.dart';

class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  bool _isLoading = false;
  void navigateToPage(BuildContext context) async {
    data.clear();
    Navigator.of(context).pop();
  }

  bool _isLoadSub = false;
  bool _isShowAll = false;
  bool showfab = true;
  String sem;

  List<SubjectObject> subjectList = [];
//  String msg = 'No data!!!';
  bool _isEmpty = false;
  //List<FeedbackObject> tasks = [];

  List<AttendanceObject> data = [];
  List<AttendanceObject> allFeedback = [];
  String att;
  bool isAbsent;
  String subject;
  String studentEmail;
  List<double> storeAllAttendance = [];
  Future<void> getData() async {
    data.clear();
    allFeedback.clear();
    data = await Provider.of<AttendanceProvider>(context, listen: false)
        .findAttendance(temp);

    studentEmail =
        Provider.of<StudentProvider>(context, listen: false).profileEmail;
    print("student email: " + studentEmail);

    print(data.map((attuendance) => attuendance.email).toList());
    isAbsent = data.any((stud) => stud.email.contains(studentEmail));
    print("is absent " + isAbsent.toString());
    setState(() {
      if (data.length == 0) {
        _isEmpty = true;
      } else {
        _isEmpty = false;
      }
    });
  }

  getsubject() async {
    if (mounted) {
      setState(() {
        _isLoadSub = true;
      });
    }
    subject = await Provider.of<AttendanceProvider>(context, listen: false)
        .getSubjectname();
    if (mounted) {
      setState(() {
        _isLoadSub = false;
      });
    }
  }

  List<AttendanceReportObject> allSubjectAttendance = [];

  showAllData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    String sem = await Provider.of<StudentProvider>(context, listen: false)
        .getSemester();

    subjectList.clear();
    subjectList = await Provider.of<SubjectProvider>(context, listen: false)
        .getSubjectDetailSemWise(sem);

    for (int i = 0; i < subjectList.length; i++) {
      List<AttendanceObject> temp = [];

      temp = await Provider.of<AttendanceProvider>(context, listen: false)
          .getAttendanceSubjectWise(subjectList[i].subCode);
          int totalLength=0;
          totalLength=temp[i].email.length;
          print("total length: "+totalLength.toString());
      List<AttendanceReportObject> attendanceReportObject = [];
      attendanceReportObject = temp
          .where((element) => element.email.contains(studentEmail))
          .map((e) => AttendanceReportObject(e.subCode, e.email.length,totalLength)).toList();

      allSubjectAttendance.addAll(attendanceReportObject);
      print("list : "+allSubjectAttendance.map((e) => e.toString()).toList().toString());
    }
     print("list of 1st sub: " +allSubjectAttendance.map((e) => e.toString()).toList().toString());

    
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  String temp = "No date selected!!";
  DateTime daySelected;
  CalendarController calcon = new CalendarController();
  @override
  void initState() {
    super.initState();
    data.clear();
    allFeedback.clear();
    getsubject();
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
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text("Attendance"),
            actions: [
              RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.blueGrey[700],
                onPressed: () {
                  setState(() {
                    _isShowAll = !_isShowAll;
                    if (_isShowAll == true) {
                      showAllData();
                    }
                  });
                },
                child: Text(
                  "Show All",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: _isShowAll
                ? Container(
                    color: Colors.blueGrey[50],
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
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                    ),
                                    SpinKitChasingDots(
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: subjectList.length,
                                  itemBuilder: (context, i) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      child: Container(
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
                                              subjectList[i].subName + "  :  ",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[200],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _isLoadSub ? " " : subject,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 9),
                          color: Colors.blueGrey,
                          height: 2,
                        ),
                        TableCalendar(
                          calendarStyle: CalendarStyle(
                            todayColor: Colors.blueGrey[300],
                            selectedColor: Colors.blueGrey[700],
                          ),
                          calendarController: calcon,
                          initialSelectedDay: DateTime.now(),
                          initialCalendarFormat: CalendarFormat.week,
                          onDaySelected: (date, event, holiday) async {
                            daySelected = date;
                            setState(() {
                              daySelected = date;
                              temp = daySelected.toString().substring(0, 10);
                            });

                            setState(() {});
                            await getData();
                          },
                        ),
                        _isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                  ),
                                  Text(
                                    "There is No data!!",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.80,
                                child: _isLoading
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                          ),
                                          SpinKitChasingDots(
                                            color: Colors.blueGrey,
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: data.length,
                                        itemBuilder: (context, i) => Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                              ),
                                              Text(
                                                isAbsent
                                                    ? "You were absent"
                                                    : "You were present!",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: isAbsent
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
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
          bottomSheet: Container(
            color: Colors.blueGrey[100],
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 1,
            child: Center(
              child: Text(
                "Total Attendance: ",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
