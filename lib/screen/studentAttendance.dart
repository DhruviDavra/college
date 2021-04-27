import 'package:college_management_system/objects/attendanceObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/attendanceProvider.dart';
import 'feedbackDetail.dart';
import 'package:college_management_system/providers/studentProvider.dart';

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

  bool _isShowAll = false;
  bool showfab = true;
  String msg = 'No data!!!';
  bool _isEmpty = false;
  //List<FeedbackObject> tasks = [];

  List<AttendanceObject> data = [];
  List<AttendanceObject> allFeedback = [];
  String att;
  Future<void> getData() async {
    data.clear();
    allFeedback.clear();
    data = await Provider.of<AttendanceProvider>(context, listen: false)
        .findAttendance(temp);
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (data[i].email[j] ==
            Provider.of<StudentProvider>(context, listen: false)
                .profileEmail) {
                  msg="You were Absent!!!";
                }
      }
    }
    // allFeedback = await Provider.of<FeedbackProvider>(context, listen: false)
    //     .allFeedback();

    setState(() {
      if (data.length == 0) {
        _isEmpty = true;
      } else {
        _isEmpty = false;
      }
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
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.80,
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
                            itemCount: allFeedback.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: InkWell(
                                  // onTap: () {
                                  //   Provider.of<AttendanceProvider>(context,
                                  //           listen: false)
                                  //       .date = allFeedback[i].date;
                                  //   Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               FeedbackDetail()));
                                  // },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Date: " + allFeedback[i].date,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              "\n" + allFeedback[i].email.first,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.01,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey[800],
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
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
                                    msg,
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
                                          child: Container(
                                            child: InkWell(
                                              onTap: () {
                                                // Provider.of<AttendanceProvider>(
                                                //         context,
                                                //         listen: false)
                                                //     .email = data[i].email;
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             FeedbackDetail()));
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      data[i].email.first,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blueGrey[800],
                                                  offset:
                                                      Offset(0.0, 1.0), //(x,y)
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
