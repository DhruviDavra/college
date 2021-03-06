import './homeScreen.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            navigateToPage(context);
          },
        ),
      ),
      body: Container(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                ),
                hintText: "Email Address",
              ),
            ),
            // TextFormField(
            //     decoration: InputDecoration(labelText: 'E-Mail'),
            //     keyboardType: TextInputType.emailAddress,
            //     onFieldSubmitted: (value) {
            //       //Validator
            //     },
            //     validator: (value) {
            //       if (value.isEmpty ||
            //           !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            //               .hasMatch(value)) {
            //         return 'Enter a valid email!';
            //       }
            //       return null;
            //     },
            //   ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => ForgotPassword()));
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
