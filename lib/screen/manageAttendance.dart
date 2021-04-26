import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/attendanceProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/attendanceObject.dart';

class Attendence extends StatefulWidget {
  @override
  _AttendenceState createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  DateTime daySelected;
  CalendarController calcon = new CalendarController();

  List<Checkbox> checkList = [];
  static int _count = 0;
  final List<bool> _checks = List.generate(_count, (_) => false);
  List<int> rno = [];
  String selectedSem;
  String div;
  int subject;
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;
  List<String> absentEmail = [];
  AttendanceObject attendanceObject = AttendanceObject();

  getData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    selectedSem =
        Provider.of<AttendanceProvider>(context, listen: false).selectedSem;

    div = Provider.of<StudentProvider>(context, listen: false).div;

    subject =
        Provider.of<AttendanceProvider>(context, listen: false).selectedSub;

    _count = await Provider.of<StudentProvider>(context, listen: false)
        .studentSemesterWise();
    print(_count);
    for (int i = 0; i < _count; i++) {
      rno.add(i + 1);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
            title: Text("Attendence of " + subject.toString()),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: Column(
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
                    // _checks.clear();
                    daySelected = date;
                    selectedDate = date;
                    //  temp = daySelected.toString().substring(0, 10);
                  });

                  setState(() {});
                  //await getData();
                },
              ),
              Text(
                "Select Absent Numbers: ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              _isLoading
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        SpinKitChasingDots(
                          color: Colors.blueGrey,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GridView.builder(
                          itemCount: rno.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 3, crossAxisCount: 4),
                          itemBuilder: (_, i) {
                            return Stack(
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: _checks[i],
                                    onChanged: (newValue) =>
                                        setState(() => _checks[i] = newValue),
                                  ),
                                  Text(rno[i].toString()),
                                ]),
                              ],
                            );
                          }),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.blueGrey[700],
                  onPressed: () async {
                    // print(selectedSem);
                    // print(div);
                    // print(subject);
                    // print(selectedDate);
                    absentEmail.clear();
                    for (int i = 0; i < rno.length; i++) {
                      if (_checks[i] == true) {
                        // print(_checks[i]);
                        // print(i + 1);
                        StudentObject result;

                        result = await Provider.of<StudentProvider>(context,
                                listen: false)
                            .emailofStudentBySemAndRno(selectedSem, div, i + 1);
                        absentEmail.add(result.email);
                        // print(result.email);
                      }
                      // print(absentEmail);

                    }

                    attendanceObject.date =
                        selectedDate.toString().substring(0, 10);
                    attendanceObject.subCode = subject;
                    attendanceObject.email = absentEmail;
                    attendanceObject.status = "absent";

                    print(attendanceObject.date);
                    print(attendanceObject.subCode);
                    print(attendanceObject.status);
                    print(attendanceObject.email);

                    Provider.of<AttendanceProvider>(context, listen: false)
                        .addAttendance(attendanceObject);
                        
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
