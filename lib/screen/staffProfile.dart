import 'package:college_management_system/objects/teachingStaffObject.dart';
import 'package:college_management_system/objects/usersObject.dart';

import './homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/teachingStaffProvider.dart';

class StaffProfile extends StatefulWidget {
  @override
  _StaffProfileState createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  String email;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    email =
        Provider.of<TeachingStaffProvider>(context, listen: false).profileEmail;
       // print(email);
    teachingStaffObject =
        await Provider.of<TeachingStaffProvider>(context, listen: false)
            .getParticularStaff(email);
    userInfoObj =
        await Provider.of<TeachingStaffProvider>(context, listen: false)
            .getParticularUser(email);
     print(teachingStaffObject.qualification);
    // print(teachingStaffObject.designation);
    // print(teachingStaffObject.experience);
    // print(teachingStaffObject.specialinterest);
   // print(teachingStaffObject.qualification);
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  TeachingStaffObject teachingStaffObject = TeachingStaffObject();
  UserInfoObj userInfoObj = UserInfoObj();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: _isLoading
                  ? Center(
                    child: CircularProgressIndicator(),
                  )
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Icon(
                          Icons.account_circle_sharp,
                          color: Colors.blue,
                          size: 100,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          userInfoObj.fname +
                              " " +
                              userInfoObj.mname +
                              " " +
                              userInfoObj.lname,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Qualification:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                                child: Text(
                                    teachingStaffObject.qualification.toString()),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Designation:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(teachingStaffObject.designation),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Date of Birth:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(
                                userInfoObj.dob,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Contact No:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(userInfoObj.cno),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Email:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(userInfoObj.email),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Experience:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(teachingStaffObject.experience),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                      flex:1,

                              child: Text(
                                "  Special Interest:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                      flex:1,

                              child: Text(teachingStaffObject.specialinterest),
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
}
