
import 'package:college_management_system/screen/leaveReport.dart';
import 'assignmentReportSubject.dart';
import './homeScreen.dart';
import 'package:flutter/material.dart';

import 'resultReportHome.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text("Reports"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectedItem = 0;
                      });
                    },
                    child: Text(
                      "Attendance",
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResultReportHome()));
                    },
                    child: Text(
                      "Result",
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                         Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AssignmentSubReport()));
                  
                      });
                    },
                    child: Text(
                      "Assignement",
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LeaveReport()));
                  
                    },
                    child: Text(
                      "leave",
                    ),
                  ),
                  Divider(
                    thickness: 3,
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
