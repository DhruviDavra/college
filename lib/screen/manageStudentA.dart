import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/screen/studentProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'manageStudentB.dart';

class StudentA extends StatefulWidget {
  @override
  _StudentAState createState() => _StudentAState();
}

class _StudentAState extends State<StudentA> {
  bool _isEdit = false;
  String radioItem = '';
  bool _isLoading = false;
  bool _showPassword = false;

  List<int> yearList = [
    2010,
    2011,
    2012,
    2013,
    2014,
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021
  ];
  String sem;
  String selectedYear;
  void navigateToPage(BuildContext context) async {
    userOfA.clear();

    studentOfA.clear();
    Navigator.of(context)
        .pop();
  }

  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
// stdobjA.clear();
// userOfA.clear();
    selectedSem = Provider.of<StudentProvider>(context, listen: false).sem;
    getDetailOfA();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          getDocumentsNextOfA(); // Load next documents
        }
      }
    });
  }

  insert() async {
    userInfoObj.uid = await Provider.of<UserProvider>(context, listen: false)
        .createUser(emailCon.text, pwdCon.text);
    Provider.of<UserProvider>(context, listen: false).addUser(userInfoObj);

    Provider.of<StudentProvider>(context, listen: false)
        .addStudent(studentObject);
  }

  List<StudentObject> studentOfA = [];
  List<UserInfoObj> userOfA = [];

  UserInfoObj userInfoObj = UserInfoObj();
  StudentObject studentObject = StudentObject();
  TextEditingController fnameCon = TextEditingController();
  TextEditingController mnameCon = TextEditingController();
  TextEditingController lnameCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  TextEditingController cnoCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();
  TextEditingController rnoCon = TextEditingController();
  TextEditingController ernoCon = TextEditingController();
  TextEditingController ayearCon = TextEditingController();

  String selectedAddDiv;
  String selectedDiv;
  List<dynamic> division = [];
  String selectedSem;
  DateTime currentDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        dateCon.text = currentDate.toString().substring(0, 10);
      });
  }

  Future<void> selectYear(BuildContext context) async {
    Container(
      margin: EdgeInsets.all(10),
      child: DropdownButton<String>(
        hint: Text("Academic Year"),
        value: selectedYear,
        items: yearList.map((int value) {
          return DropdownMenuItem<String>(
            value: value.toString(),
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (String value) {
          if (mounted) {
            setState(() {
              selectedYear = value;
            });
          }
        },
      ),
    );
  }

  QuerySnapshot divData;

  bool showfab = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text(selectedSem + " sem Students"),
          ),
          body: Column(
            children: [
              Container(
                color: Colors.blueGrey[700],
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        color: Colors.blueGrey,
                        child: Text(
                          "Div A",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentA()));
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        color: Colors.blueGrey[700],
                        child: Text(
                          "Div B",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentB()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: stdobjA.length != 0
                        ? RefreshIndicator(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.79,
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                controller: scrollController,
                                itemCount: stdobjA.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      print("index  " + index.toString());

                                      print(stdobjA[index].email);
                                      Provider.of<StudentProvider>(context,
                                              listen: false)
                                          .profileEmail = stdobjA[index].email;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetail()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Roll No. " +
                                                    stdobjA[index]
                                                        .rno
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Spacer(),
                                              editDeleteButton(index),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Name: " +
                                                    stdobjA[index].name,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Email: " + stdobjA[index].email,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onRefresh: getDetailOfA // Refresh entire list
                            )
                        : Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              SpinKitChasingDots(
                                color: Colors.blueGrey,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
            onPressed: () {
              this.fnameCon.clear();
              this.mnameCon.clear();
              this.lnameCon.clear();
              this.dateCon.clear();
              this.cnoCon.clear();
              this.emailCon.clear();
              this.pwdCon.clear();
              this.rnoCon.clear();
              this.ernoCon.clear();
              _isEdit = false;
              addStudent(context);
            },
          ),
        ),
      ),
    );
  }

  Widget editDeleteButton(int i) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _isEdit = true;
            print("index " + i.toString());
            fnameCon.text = userObjA[i].fname;
            mnameCon.text = userObjA[i].mname;
            lnameCon.text = userObjA[i].lname;
            dateCon.text = userObjA[i].dob;
            cnoCon.text = userObjA[i].cno;
            emailCon.text = userObjA[i].email;
            pwdCon.text = userObjA[i].password;
            radioItem = stdobjA[i].div;
            rnoCon.text = stdobjA[i].rno.toString();
            ernoCon.text = stdobjA[i].enrollno;
            selectedYear = stdobjA[i].acadamicYear;

            addStudent(context);
          },
          child: Icon(
            Icons.edit,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure to delete this User?'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              // if (index == 0) {
                              //   print(userOfA[i].email);
                              //   Provider.of<StudentProvider>(context,
                              //           listen: false)
                              //       .deleteStudent(userOfA[i].email);
                              // }
                              // if (index == 1) {
                              //   print(userOfB[i].email);
                              //   Provider.of<StudentProvider>(context,
                              //           listen: false)
                              //       .deleteStudent(userOfB[i].email);
                              // }

                              setState(() {
                                userOfA.clear();
                                studentOfA.clear();
                              });
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text('Yes')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                    ],
                  );
                });
          },
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  addStudent(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    ' Student Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  "  First Name",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the First Name",
                  ),
                  controller: fnameCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Middle Name",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the Middle Name",
                  ),
                  controller: mnameCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "  Last Name",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the Last Name",
                  ),
                  controller: lnameCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Date of Birth",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    selectDate(context);
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      hintText: "Enter the Date of Birth",
                    ),
                    controller: dateCon,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Contact No",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the Contact Number",
                  ),
                  controller: cnoCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Email Address",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  enabled: _isEdit ? false : true,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the Proper Email Address",
                  ),
                  controller: emailCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  enabled: _isEdit ? false : true,
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
                    hintText: "Enter Your Password",
                  ),
                  controller: pwdCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Division",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        groupValue: radioItem,
                        title: Text('Div A'),
                        value: 'A',
                        onChanged: (val) {
                          setState(() {
                            radioItem = val;
                            print(radioItem);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        groupValue: radioItem,
                        title: Text('Div B'),
                        value: 'B',
                        onChanged: (val) {
                          setState(() {
                            radioItem = val;
                            print(radioItem);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Roll Number",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter Roll Number",
                  ),
                  controller: rnoCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Enrollment Number",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter Enrollment Number",
                  ),
                  controller: ernoCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Academic Year",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: DropdownButton<String>(
                    hint: Text("Academic Year"),
                    value: selectedYear,
                    items: yearList.map((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Center(child: Text(value.toString())),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      if (mounted) {
                        setState(() {
                          selectedYear = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blueGrey,
                      onPressed: () async {
                        try {
                          print(fnameCon.text);
                          print(mnameCon.text);
                          print(lnameCon.text);
                          print(dateCon.text);
                          print(cnoCon.text);
                          print(emailCon.text);
                          print(pwdCon.text);
                          print(selectedDiv);
                          print(rnoCon.text);
                          print(ernoCon);
                          print(selectedYear);

                          userInfoObj.email = emailCon.text;
                          userInfoObj.password = pwdCon.text;
                          userInfoObj.fname = fnameCon.text;
                          userInfoObj.mname = mnameCon.text;
                          userInfoObj.lname = lnameCon.text;
                          userInfoObj.dob = dateCon.text;
                          userInfoObj.cno = cnoCon.text;
                          userInfoObj.utype = "Student";

                          studentObject.rno = int.parse(rnoCon.text);
                          studentObject.enrollno = ernoCon.text;
                          studentObject.sem = selectedSem;
                          studentObject.div = radioItem;
                          studentObject.acadamicYear = selectedYear;
                          studentObject.email = emailCon.text;

                          _isEdit
                              ? await Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .update(
                                      emailCon.text, userInfoObj, studentObject)
                              : await insert();

                          setState(() {
                            userOfA.clear();
                            studentOfA.clear();
                          });
                          Navigator.of(context).pop();
                          this.fnameCon.clear();
                          this.mnameCon.clear();
                          this.lnameCon.clear();
                          this.dateCon.clear();
                          this.cnoCon.clear();
                          this.emailCon.clear();
                          this.pwdCon.clear();
                          this.rnoCon.clear();
                          this.ernoCon.clear();
                          this.ayearCon.clear();
                        } catch (e) {
                          print(e.toString());
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Alert!"),
                              content: Text(e.toString()),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Ok"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text(
                        _isEdit ? "Edit Student" : "Add Student",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<StudentObject> stdobjA;
  List<UserInfoObj> userObjA;

  QuerySnapshot collectionStateOfA;
  QuerySnapshot collectionStateOfB;
  // Fetch first 15 documents
  Future<void> getDetailOfA() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    stdobjA = List();
    userObjA = List();
    var studentDetailOfA = FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: selectedSem)
        .where("div", isEqualTo: "A")
        .orderBy("rno")
        .limit(15);
    await fetchDocumentsOfA(studentDetailOfA);
    await studentDetailOfA.get().then(
      (value) {
        value.docs.forEach(
          (user) async {
            int index = stdobjA
                .indexWhere((element) => element.email == user.data()["email"]);

            //   print("user email: "+element.data()["email"]);
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection("tbl_users")
                .where("email", isEqualTo: user.data()["email"])
                .get();

            setState(
              () {
                String name;
                name = querySnapshot.docs.first.data()["lname"] +
                    " " +
                    querySnapshot.docs.first.data()["fname"] +
                    " " +
                    querySnapshot.docs.first.data()["mname"];
                stdobjA[index].name = name;
                // userOfA.add(userInfoObjFromJson(
                //     json.encode(querySnapshot.docs.first.data())));
              },
            );
          },
        );
      },
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    print('getDocumentsofA');
  }

  // Fetch next 10 documents starting from the last document fetched earlier
  Future<void> getDocumentsNextOfA() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    // Get the last visible document
    var lastVisible =
        collectionStateOfA.docs[collectionStateOfA.docs.length - 1];
    print(
        'listDocumentOfA legnth: ${collectionStateOfA.size} last: $lastVisible');

    var studentDetailOfA = FirebaseFirestore.instance
        .collection("tbl_student")
        .where("sem", isEqualTo: selectedSem)
        .where("div", isEqualTo: "A")
        .orderBy("rno")
        .startAfterDocument(lastVisible)
        .limit(10);

    await fetchDocumentsOfA(studentDetailOfA);
    await studentDetailOfA.get().then(
      (value) {
        value.docs.forEach(
          (user) async {
            int index = stdobjA
                .indexWhere((element) => element.email == user.data()["email"]);

            //   print("user email: "+element.data()["email"]);
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection("tbl_users")
                .where("email", isEqualTo: user.data()["email"])
                .get();

            setState(
              () {
                String name;
                name = querySnapshot.docs.first.data()["lname"] +
                    " " +
                    querySnapshot.docs.first.data()["fname"] +
                    " " +
                    querySnapshot.docs.first.data()["mname"];
                stdobjA[index].name = name;
                // userOfA.add(userInfoObjFromJson(
                //     json.encode(querySnapshot.docs.first.data())));
              },
            );
          },
        );
      },
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    print('getDocumentsofA');
  }

  Future<void> fetchDocumentsOfA(Query collection) async {
    await collection.get().then(
      (value) {
        collectionStateOfA =
            value; // store collection state to set where to start next
        value.docs.forEach(
          (element) {
            print('getDocumentsOfA ${element.data()}');
            setState(() {
              stdobjA.add(studentObjectFromJson(json.encode(element.data())));
            });
          },
        );
      },
    );
  }
}
