import 'package:college_management_system/objects/leaveObject.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/teachingStaffObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/leaveProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/providers/teachingStaffProvider.dart';
import 'package:college_management_system/screen/studentLeave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveForm extends StatefulWidget {
  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  void navigateToPage(BuildContext context) async {
    titleCon.clear();
    desCon.clear();
    toDateCon.clear();
    fromDateCon.clear();
    Navigator.of(context).pop();
  }

  LeaveObject leaveObject = LeaveObject();
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

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String email;
  bool _isLoading = false;
  bool _isTeaching = false;
  bool _isToDateValid = true;
  bool _isFromDateValid = true;

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    _isTeaching =
        Provider.of<LeaveProvider>(context, listen: false).isTeachingStaff;

    _isTeaching ? getStaffData() : getStudentData();

    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);

    // print(email);

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  getStudentData() async {
    email = Provider.of<StudentProvider>(context, listen: false).profileEmail;
    studentObject = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularStudent(email);
  }

  getStaffData() async {
    email = Provider.of<TeachingStaffProvider>(context, listen: false)
        .teachingEmail;
    teachingStaffObject =
        await Provider.of<TeachingStaffProvider>(context, listen: false)
            .getParticularStaff(email);
  }

  StudentObject studentObject = StudentObject();
  UserInfoObj userInfoObj = UserInfoObj();
  TeachingStaffObject teachingStaffObject = TeachingStaffObject();
  @override
  void initState() {
    super.initState();
    getData();
  }

  final maxLines = 7;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Leave Form"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[700],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              navigateToPage(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : Form(
                    key: _key,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userInfoObj.fname +
                                        " " +
                                        userInfoObj.mname +
                                        " " +
                                        userInfoObj.lname,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              _isTeaching
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Designation: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              teachingStaffObject.designation,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Contact No.: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              userInfoObj.cno,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              teachingStaffObject.email,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Roll Number: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              studentObject.rno.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Enrollment No: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              studentObject.enrollno,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Semester: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              studentObject.sem,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            Text(
                                              "Division: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              studentObject.div,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              studentObject.email,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.14,
                                child: Row(
                                  children: [
                                    Text(
                                      "Title: ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          hintText: "Enter Title",
                                        ),
                                        controller: titleCon,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Title';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                              Text(
                                "Description: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  maxLines: maxLines,
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText:
                                        "Respected Sir/Ma'am\n      Give your Reason Here...\n\nThank You",
                                  ),
                                  controller: desCon,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Description';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Text(
                                "  To Date",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  selectToDate(context);
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Select date",
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  controller: toDateCon,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      _isToDateValid = false;
                                      return 'Please select To Date';
                                    }
                                    return null;
                                  },
                                  enabled: _isToDateValid ? false : true,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Text(
                                "  From Date",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  selectFromDate(context);
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Select date",
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  controller: fromDateCon,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      _isFromDateValid = false;
                                      return 'Please select From Date';
                                    }
                                    return null;
                                  },
                                  enabled: _isFromDateValid ? false : true,
                                ),
                              ),
                            ],
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
                              if (!_key.currentState.validate()) {
                                if (mounted) {
                                  setState(() {
                                    autovalidateMode = AutovalidateMode.always;
                                  });
                                }
                                return;
                              }

                              leaveObject.title = titleCon.text;
                              leaveObject.des = desCon.text;
                              leaveObject.toDate = toDateCon.text;
                              leaveObject.fromDate = fromDateCon.text;
                              leaveObject.email = studentObject.email;
                              leaveObject.status = "Pending";
                              leaveObject.applytime =
                                  DateTime.now().toUtc().millisecondsSinceEpoch;

                              print(leaveObject.title);
                              print(leaveObject.des);
                              print(leaveObject.toDate);
                              print(leaveObject.fromDate);
                              print(leaveObject.email);
                              print(leaveObject.status);
                              print(leaveObject.applytime);

                              Provider.of<LeaveProvider>(context, listen: false)
                                  .addLeave(leaveObject);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StudentLeave()));
                            },
                            child: Text(
                              "Apply",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
