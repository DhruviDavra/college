import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/screen/studentLeave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveForm extends StatefulWidget {
  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  void navigateToPage(BuildContext context) async {
    titleCon.clear();
    desCon.clear();
    toDateCon.clear();
    fromDateCon.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => StudentLeave()));
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
  bool _isLoading;

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    email = Provider.of<StudentProvider>(context, listen: false).profileEmail;
    // print(email);
    studentObject = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularStudent(email);
    userInfoObj = await Provider.of<StudentProvider>(context, listen: false)
        .getParticularUser(email);

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  StudentObject studentObject = StudentObject();
  UserInfoObj userInfoObj = UserInfoObj();

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
            child:
            _isLoading?Center(child: CircularProgressIndicator())
             :Column(
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Roll Number: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Enrollment No: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Semester: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            studentObject.sem,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            "Division: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Email: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            studentObject.email,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Row(
                        children: [
                          Text(
                            "Title: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextField(
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: "Enter Title",
                              ),
                              controller: titleCon,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        "Description: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          maxLines: maxLines,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            hintText:
                                "Respected Sir/Ma'am\n      I want to take leave.\n\nThank You",
                          ),
                          controller: desCon,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Select date",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          controller: toDateCon,
                          enabled: false,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Select date",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          controller: fromDateCon,
                          enabled: false,
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
                      print(titleCon.text);
                      print(desCon.text);
                      print(toDateCon.text);
                      print(fromDateCon.text);
                    },
                    child: Text(
                      "Apply",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
