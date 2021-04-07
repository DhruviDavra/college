import 'package:college_management_system/objects/leaveObject.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/leaveProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/screen/leaveDetail.dart';
import 'package:college_management_system/screen/leaveForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homeScreen.dart';

class StudentLeave extends StatefulWidget {
  @override
  _StudentLeaveState createState() => _StudentLeaveState();
}

class _StudentLeaveState extends State<StudentLeave> {
  bool _isLoading = false;
  void navigateToPage(BuildContext context) async {
    leaveData.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  TextEditingController toDateCon = TextEditingController();
  TextEditingController fromDateCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  DateTime currentDate = DateTime.now();
  Future<void> selectToDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        toDateCon.text = currentDate.toString().substring(0, 10);
      });
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        fromDateCon.text = currentDate.toString().substring(0, 10);
      });
  }

  String email;

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    leaveData.clear();
//studentObject.clear();

    email = Provider.of<StudentProvider>(context, listen: false).profileEmail;
    // print(email);
    studentObject = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularStudent(email);
    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);
    leaveData = await Provider.of<LeaveProvider>(context, listen: false)
        .getLeaveDetailForStudent();
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  StudentObject studentObject = StudentObject();
  UserInfoObj userInfoObj = UserInfoObj();
  List<LeaveObject> leaveData = [];
  @override
  void initState() {
    super.initState();

    leaveData.clear();
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
            title: Text("Apply for Leave"),
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(1),
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: leaveData.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  // print(leaveData[i].applytime);
                                  Provider.of<LeaveProvider>(context,
                                          listen: false)
                                      .time = leaveData[i].applytime;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LeaveDetail()));
                                },
                                child: Container(
                                  child: ListTile(
                                    isThreeLine: true,
                                    title: Row(
                                      children: [
                                        Text(
                                          leaveData[i].title,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(Provider.of<LeaveProvider>(context,
                                                listen: false)
                                            .epochToLocal(
                                                leaveData[i].applytime)),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(" "),
                                        Text("Apply Date: " +
                                            Provider.of<LeaveProvider>(context,
                                                    listen: false)
                                                .epochToLocal(
                                                    leaveData[i].applytime)),
                                        Text(" "),
                                        Text("Status: " + leaveData[i].status),
                                      ],
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.blueGrey[700],
                      onPressed: () {
                        // titleCon.clear();
                        // desCon.clear();
                        // toDateCon.clear();
                        // fromDateCon.clear();
                        //showBottomSheet();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LeaveForm()));
                      },
                      child: Text(
                        "Apply for Leave",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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

  // showBottomSheet() {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: Container(
  //           margin: EdgeInsets.all(5),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.0,
  //               ),
  //               Center(
  //                 child: Text(
  //                   "Student Leave",
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //               Text(
  //                 "  Title",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               TextField(
  //                 decoration: InputDecoration(
  //                   border: new OutlineInputBorder(
  //                     borderRadius: new BorderRadius.circular(25.0),
  //                     borderSide: new BorderSide(),
  //                   ),
  //                   hintText: "Enter the Title",
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //               Text(
  //                 "  Description",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               TextField(
  //                 decoration: InputDecoration(
  //                   border: new OutlineInputBorder(
  //                     borderRadius: new BorderRadius.circular(25.0),
  //                     borderSide: new BorderSide(),
  //                   ),
  //                   hintText: "Enter Description",
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //               Text(
  //                 "  To Date",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   selectToDate(context);
  //                 },
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     hintText: "Select date",
  //                     border: new OutlineInputBorder(
  //                       borderRadius: new BorderRadius.circular(25.0),
  //                       borderSide: new BorderSide(),
  //                     ),
  //                   ),
  //                   controller: toDateCon,
  //                   enabled: false,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //               Text(
  //                 "  From Date",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   selectFromDate(context);
  //                 },
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     hintText: "Select date",
  //                     border: new OutlineInputBorder(
  //                       borderRadius: new BorderRadius.circular(25.0),
  //                       borderSide: new BorderSide(),
  //                     ),
  //                   ),
  //                   controller: fromDateCon,
  //                   enabled: false,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.06,
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //                 child: Center(
  //                   child: RaisedButton(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                     ),
  //                     color: Colors.blueGrey[700],
  //                     onPressed: () {
  //                       print(titleCon.text);
  //                       print(desCon.text);
  //                       print(toDateCon.text);
  //                       print(fromDateCon.text);
  //                       // Navigator.of(context).push(
  //                       //     MaterialPageRoute(builder: (context) => ForgotPassword()));
  //                     },
  //                     child: Text(
  //                       "Apply for Leave ",
  //                       style: TextStyle(color: Colors.white, fontSize: 18),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
