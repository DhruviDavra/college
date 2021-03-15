import './homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'adminHome.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool _showPassword = false;
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  TextEditingController oldPwdCon = TextEditingController();
  TextEditingController newPwdCon = TextEditingController();
  TextEditingController reNewPwdCon = TextEditingController();

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
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Center(
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                      "To Change Your Password, Please fill in the fields below:"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "  Current Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextField(
                    obscureText: !this._showPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showPassword ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                              () => this._showPassword = !this._showPassword);
                        },
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      hintText: "Enter Current Password",
                    ),
                    controller: oldPwdCon,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    "  New Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextField(
                    obscureText: !this._showPassword1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color:
                              this._showPassword1 ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                              () => this._showPassword1 = !this._showPassword1);
                        },
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      hintText: "Enter New Password",
                    ),
                    controller: newPwdCon,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    "  Re-Enter Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextField(
                    obscureText: !this._showPassword2,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color:
                              this._showPassword2 ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                              () => this._showPassword2 = !this._showPassword2);
                        },
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      hintText: "Re-enter Password",
                    ),
                    controller: reNewPwdCon,
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
                        onPressed: () {
                          print(oldPwdCon.text);

                          print(newPwdCon.text);

                          print(reNewPwdCon.text);
                          if (newPwdCon.text != reNewPwdCon.text) {
                            print("no match");
                          } else {
                            Provider.of<UserProvider>(context, listen: false)
                                .changePassword(newPwdCon.text);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdminHome(),
                            ));
                          }
                        },
                        child: Text(
                          "Submit",
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