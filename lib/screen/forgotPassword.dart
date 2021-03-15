import './homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/userProvider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  TextEditingController emailCon = TextEditingController();

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
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                      "Please enter your email address,we will email you a link to reaset your password"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    "  Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      hintText: "abc@gmail.com",
                    ),
                    controller: emailCon,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue,
                        onPressed: () async {
                          try {
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .passwordReset(emailCon.text);
                            Navigator.of(context).pop();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          "Send Email",
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
