import './homeScreen.dart';
import 'package:flutter/material.dart';

class Myprofile extends StatefulWidget {
  @override
  _MyprofileState createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
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
                      color: Colors.blueGrey[700],
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
                    "name",
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Enrollment No",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Enorollment no"),
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
                          "Dob",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Dob"),
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
                          "Email",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Email"),
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
                          "Contact No",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Contact No"),
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
                          "Academic Year",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Academic No"),
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
                          "Semester",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text("Display Sem no"),
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
