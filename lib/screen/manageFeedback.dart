
import 'package:college_management_system/objects/feedbackObject.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/feedbackProvider.dart';
import 'feedbackDetail.dart';

class FeedbackAdmin extends StatefulWidget {
  @override
  _FeedbackAdminState createState() => _FeedbackAdminState();
}

class _FeedbackAdminState extends State<FeedbackAdmin> {
  bool _isLoading = false;
  void navigateToPage(BuildContext context) async {
    data.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool showfab = true;
  String msg = 'No Feedback !!!';
  bool _isEmpty = false;
  //List<FeedbackObject> tasks = [];

  List<FeedbackObject> data = [];
  Future<void> getData() async {
    data.clear();
    data = await Provider.of<FeedbackProvider>(context, listen: false)
        .findFeedback(temp);

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text("Feedback"),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  TableCalendar(
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
                              height: MediaQuery.of(context).size.height * 0.06,
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
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder: (context, i) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<FeedbackProvider>(context,
                                                  listen: false)
                                              .email = data[i].email;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeedbackDetail()));
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                data[i].email,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
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
