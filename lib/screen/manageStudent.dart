import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/userProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  bool _isLoading = false;
  bool _isEdit = false;
  bool _isSelectedDiv = false;
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
    studentAll.clear();
    userAll.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  insert() async {
    userInfoObj.uid = await Provider.of<UserProvider>(context, listen: false)
        .createUser(emailCon.text, pwdCon.text);
    Provider.of<UserProvider>(context, listen: false).addUser(userInfoObj);

    Provider.of<StudentProvider>(context, listen: false)
        .addStudent(studentObject);
  }

  List<StudentObject> studentAll = [];
  List<UserInfoObj> userAll = [];
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
    // final DateTime pickedDate = await showDatePicker(
    //     context: context,
    //     initialDate: currentDate,
    //     initialDatePickerMode: DatePickerMode.year,
    //     firstDate: DateTime(1800),
    //     lastDate: DateTime(2050));

    // if (pickedDate != null && pickedDate != currentDate)
    //   setState(() {
    //     currentDate = pickedDate;
    //     ayearCon.text = currentDate.toString().substring(0, 10);
    //   });
  }

  QuerySnapshot divData;

  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    selectedSem = Provider.of<StudentProvider>(context, listen: false).sem;
  division.clear();
  studentAll.clear();
  userAll.clear();
    divData = await FirebaseFirestore.instance
        .collection("tbl_division")
        .where("sem", isEqualTo: selectedSem)
        .orderBy("id")
        .get();
    //  print(quaData.docs.length);
    for (int i = 0; i < divData.docs.length; i++) {
      division.add(divData.docs[i].data()["div"]);
    }
    // print(qualification.length);
    studentAll = await Provider.of<StudentProvider>(context, listen: false)
        .getStudentDetail(selectedSem);
    userAll = await Provider.of<StudentProvider>(context, listen: false)
        .getUserDetail(selectedSem);
    print(userAll.length);
    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
  }

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
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  _isLoading
                      ? Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          period: Duration(seconds: 3),
                          baseColor: Colors.blueGrey[50],
                          highlightColor: Colors.blueGrey[200],
                          child: SizedBox(
                          height: 70.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: division.length,
                            itemBuilder: (context, i) => InkWell(
                              onTap: () {
                                selectedDiv = division[i];
                                setState(() {
                                  _isSelectedDiv = !_isSelectedDiv;
                                });
                                print(selectedDiv);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 50.0,
                                    color: _isSelectedDiv
                                        ? Colors.blueGrey[300]
                                        : Colors.blueGrey[700],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Div " + division[i],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        )
                      : SizedBox(
                          height: 70.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: division.length,
                            itemBuilder: (context, i) => InkWell(
                              onTap: () {
                                selectedDiv = division[i];
                                setState(() {
                                  _isSelectedDiv = !_isSelectedDiv;
                                });
                                print(selectedDiv);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 50.0,
                                    color: _isSelectedDiv
                                        ? Colors.blueGrey[300]
                                        : Colors.blueGrey[700],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Div " + division[i],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  // CircularProgressIndicator()
                  //:
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: _isLoading
                        ? Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          period: Duration(seconds: 3),
                          baseColor: Colors.blueGrey[50],
                          highlightColor: Colors.blueGrey[200],
                          child: SizedBox(
                          height: 70.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: division.length,
                            itemBuilder: (context, i) => InkWell(
                              onTap: () {
                                selectedDiv = division[i];
                                setState(() {
                                  _isSelectedDiv = !_isSelectedDiv;
                                });
                                print(selectedDiv);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 50.0,
                                    color: _isSelectedDiv
                                        ? Colors.blueGrey[300]
                                        : Colors.blueGrey[700],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Div " + division[i],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                           fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: userAll.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  print(userAll[i].email);
                                  // Provider.of<TeachingStaffProvider>(context,
                                  //         listen: false)
                                  //     .profileEmail = userAll[i].email;
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => StaffProfile()));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Text(userAll[i].fname +
                                          " " +
                                          userAll[i].mname +
                                          " " +
                                          userAll[i].lname),
                                      Spacer(),
                                      editDeleteButton(i),
                                    ],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
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
                ],
              ),
            ),
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
              this.ayearCon.clear();
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
            //   print(teachingAll[i].qualification);
            fnameCon.text = userAll[i].fname;
            mnameCon.text = userAll[i].mname;
            lnameCon.text = userAll[i].lname;
            dateCon.text = userAll[i].dob;
            cnoCon.text = userAll[i].cno;
            emailCon.text = userAll[i].email;
            pwdCon.text = userAll[i].password;
            // selectedQua = teachingAll[i].qualification;
            // selectedDesignation = teachingAll[i].designation;
            // experienceCon.text = teachingAll[i].experience;
            // specialIntCon.text = teachingAll[i].specialinterest;
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
                              // print(
                              //     userAll[i].email);
                              Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .deleteStudent(userAll[i].email);
                              
                              setState(() {
                                userAll.clear();
                              studentAll.clear();
                                fetchData();
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
                  obscureText: true,
                  decoration: InputDecoration(
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
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: 70.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: division.length,
                          itemBuilder: (context, i) => InkWell(
                            onTap: () {
                              selectedDiv = division[i];
                              print(selectedDiv);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 50.0,
                                  color: Colors.blueGrey,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Div " + division[i],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                          studentObject.div = selectedDiv;
                          studentObject.acadamicYear = selectedYear;
                          studentObject.email = emailCon.text;

                          _isEdit
                              ? await Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .update(
                                      emailCon.text, userInfoObj, studentObject)
                              : await insert();

                          setState(() {
                            userAll.clear();
                            division.clear();
                            studentAll.clear();
                            fetchData();
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
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
