import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/noticeProvider.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'package:college_management_system/providers/seminarProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:college_management_system/providers/teachingStaffProvider.dart';
import 'package:college_management_system/providers/feedbackProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'adminProfile.dart';
import 'changePassword.dart';
import 'homeScreen.dart';
import 'manageStaff.dart';
import 'manageSeminar.dart';
import 'manageNotice.dart';
import 'manageFeedback.dart';
import 'manageAdminLeave.dart';
import 'manageStudentHome.dart';
import 'manageSemester.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String uname = 'User Name';
  String totalStaff = " ";
  String totalSeminar = " ";
  String totalFeedback = " ";
  String totalNotice = " ";
  bool isLoading = false;
  UserInfoObj userObj = UserInfoObj();

  @override
  void initState() {
    super.initState();
    callUserData();
  }

  callUserData() async {
    userObj =
        await Provider.of<UserProvider>(context, listen: false).getUserDetail();
    totalStaff =
        await Provider.of<TeachingStaffProvider>(context, listen: false)
            .countStaff();

    totalSeminar = await Provider.of<SeminarProvider>(context, listen: false)
        .countSeminar();

    totalFeedback = await Provider.of<FeedbackProvider>(context, listen: false)
        .countFeedback();

    totalNotice =
        await Provider.of<NoticeProvider>(context, listen: false).countNotice();
    setState(() {
      uname = userObj.fname + ' ' + userObj.mname + ' ' + userObj.lname;
    });
    print(uname);
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
            title: Text('TMTBCA'),
          ),
          drawer: drawer(),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.06,
                left: MediaQuery.of(context).size.width * 0.06,
                top: MediaQuery.of(context).size.height * 0.04,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.22,
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
                        child: Center(
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/student.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "  Student",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
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
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.22,
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Staff()));
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/teaching.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    // width: MediaQuery.of(context).size.height * 0.06,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "  Staff",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    children: [
                                      Text(totalStaff),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                        width: MediaQuery.of(context).size.height * 0.22,
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FeedbackAdmin()));
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/feedback.JPG',
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    // width: MediaQuery.of(context).size.height * 0.06,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "Feedback",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    children: [
                                      Text(totalFeedback),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.22,
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Seminar()));
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/teaching.JPG',
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    // width: MediaQuery.of(context).size.height * 0.06,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "Seminar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    children: [
                                      Text(totalSeminar),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
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
                        width: MediaQuery.of(context).size.height * 0.22,
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
                                  'assets/images/leaves.JPG',
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "  Leaves",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
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
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.22,
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminNotice()));
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/notice.JPG',
                                    height: MediaQuery.of(context).size.height *
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
                                      AutoSizeText(
                                        "Announcements",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    children: [
                                      Text(totalNotice),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
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
                        width: MediaQuery.of(context).size.height * 0.22,
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
                                      MediaQuery.of(context).size.height * 0.08,
                                  // width: MediaQuery.of(context).size.height * 0.06,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "Reports",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
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
                            width: MediaQuery.of(context).size.height * 0.22,
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
                                      'assets/images/sem.JPG',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      // width: MediaQuery.of(context).size.height * 0.06,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            " Semester",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
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
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: Container(
              //color: Colors.blueGrey[50],
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: MediaQuery.of(context).size.height * 0.08,
                    color: Colors.blueGrey,
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminProfile(),
              ));
            },
          ),
          
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: Text(
              'Staff',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Staff(),
              ));
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentAdminHome(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.article,
            ),
            title: Text(
              'Semester',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Semester()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.ballot,
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
              Icons.announcement,
            ),
            title: Text(
              'Announcements',
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
              Icons.bookmark,
            ),
            title: Text(
              'Feedbacks',
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
              Icons.report,
            ),
            title: Text(
              'Reports',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.vpn_key,
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePassword()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
