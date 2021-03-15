import 'package:college_management_system/objects/usersObject.dart';
import './homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/userProvider.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  UserInfoObj userObj = UserInfoObj();
  String name = ' ';
  String dob = ' ';
  String cno = ' ';
  String email = ' ';
  @override
  void initState() {
    callUserDate();
    super.initState();
  }

  callUserDate() async {
    userObj =
        await Provider.of<UserProvider>(context, listen: false).getUserDetail();
    setState(() {
      dob = userObj.dob;
      cno = userObj.cno;
      email = userObj.email;
      name = userObj.fname + ' ' + userObj.mname + ' ' + userObj.lname;
    });
    print(name);
  }

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
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
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
                    name,
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "  Date of Birth:",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text(dob),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "  Email:",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            email,
                          ),
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
                        child: Text(
                          "  Contact No:",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text(cno),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
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
