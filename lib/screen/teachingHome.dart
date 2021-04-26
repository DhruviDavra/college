import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/feedbackProvider.dart';
import 'package:college_management_system/providers/leaveProvider.dart';
import 'package:college_management_system/providers/noticeProvider.dart';
import 'package:college_management_system/providers/seminarProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/providers/teachingStaffProvider.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'package:college_management_system/screen/leaveForm.dart';
import 'package:college_management_system/screen/staffProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'aboutUs.dart';
import 'homeScreen.dart';
import 'manageAdminLeave.dart';
import 'manageAssignment.dart';
import 'manageEBook.dart';
import 'manageExamHome.dart';
import 'manageFeedback.dart';
import 'manageNotice.dart';
import 'manageSeminar.dart';
import 'manageAttendanceSem.dart';
import 'manageStudentHome.dart';
import 'manageSyllabus.dart';

class TeachingHome extends StatefulWidget {
  @override
  _TeachingHomeState createState() => _TeachingHomeState();
}

class _TeachingHomeState extends State<TeachingHome> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  String uname = 'User Name';
  String totalSeminar = " ";
  String totalFeedback = " ";
  String totalNotice = " ";
  String totalStudent = " ";
  String totalLeave = " ";
  bool isLoading = false;
  UserInfoObj userObj = UserInfoObj();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callUserData();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   callUserData();
  // }

  bool _isLoading = false;
  callUserData() async {
    if (mounted) {
      _isLoading = true;
    }
    userObj =
        await Provider.of<UserProvider>(context, listen: false).getUserDetail();

    totalSeminar = await Provider.of<SeminarProvider>(context, listen: false)
        .countSeminar();

    totalFeedback = await Provider.of<FeedbackProvider>(context, listen: false)
        .countFeedback();

    totalStudent = await Provider.of<StudentProvider>(context, listen: false)
        .countStudent();

    totalNotice =
        await Provider.of<NoticeProvider>(context, listen: false).countNotice();

    totalLeave =
        await Provider.of<LeaveProvider>(context, listen: false).countLeave();

    setState(() {
      uname = userObj.fname + ' ' + userObj.mname + ' ' + userObj.lname;
    });
    print(uname);

    if (mounted) {
      _isLoading = false;
    }
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
            title: Text('Teaching Staff'),
            backgroundColor: Colors.blueGrey[700],
          ),
          drawer: drawer(),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.04,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/student.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "  Student",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("79%"),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/teaching.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "  E-Book",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("139"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/notice.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Notice",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("42"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/teaching.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Seminar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("30"),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/report.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Reports",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("5"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.16,
                            width: MediaQuery.of(context).size.height * 0.21,
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
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/feedback.JPG',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      // width: MediaQuery.of(context).size.height * 0.06,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          " Feedback",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Row(
                                      children: [
                                        Text("5"),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/student.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      " Attendence",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("42"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.21,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/teaching.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Exam Detail",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text("30"),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: MediaQuery.of(context).size.height * 0.08,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    uname,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Provider.of<TeachingStaffProvider>(context, listen: false)
                  .isTeachingStaffLogin = true;
              Provider.of<TeachingStaffProvider>(context, listen: false)
                  .teachingEmail = userObj.email;
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StaffProfile()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: Text(
              'Students',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StudentAdminHome()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: Text(
              'Seminar',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Seminar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.article,
            ),
            title: Text(
              'Attendence',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AttendanceSem()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.ballot,
            ),
            title: Text(
              'Exam Detail',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ExamHome()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book_online,
            ),
            title: Text(
              'Announcement',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AdminNotice()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book_sharp,
            ),
            title: Text(
              'Syllabus',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Syllabus()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book_online,
            ),
            title: Text(
              'Assignment',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Assignment()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mobile_friendly,
            ),
            title: Text(
              'Leaves',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AdminLeave()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mobile_friendly,
            ),
            title: Text(
              'Apply for leave',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Provider.of<LeaveProvider>(context, listen: false)
                  .isTeachingStaff = true;
              Provider.of<TeachingStaffProvider>(context, listen: false)
                  .teachingEmail = userObj.email;
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LeaveForm()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark,
            ),
            title: Text(
              'E-Book',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Book()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.report,
            ),
            title: Text(
              'Feedback',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FeedbackAdmin()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.vpn_key,
            ),
            title: Text(
              'About App',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutUs()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ],
      ),
    );
  }
}
