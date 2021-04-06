import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/teachingStaffObject.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/teachingStaffProvider.dart';
import 'package:college_management_system/providers/userProvider.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'staffProfile.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  bool _isLoading = false;
  bool _isEdit = false;
  void navigateToPage(BuildContext context) async {
    teachingAll.clear();
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

    Provider.of<TeachingStaffProvider>(context, listen: false)
        .addTeachingStaff(teachingStaffObject);
  }

  List<TeachingStaffObject> teachingAll = [];
  List<UserInfoObj> userAll = [];
  UserInfoObj userInfoObj = UserInfoObj();
  TeachingStaffObject teachingStaffObject = TeachingStaffObject();
  TextEditingController fnameCon = TextEditingController();
  TextEditingController mnameCon = TextEditingController();
  TextEditingController lnameCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  TextEditingController cnoCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();
  TextEditingController experienceCon = TextEditingController();
  TextEditingController specialIntCon = TextEditingController();
  String selectedDesignation;
  bool quaSlet = false;
  bool quaMca = false;
  bool quaMscIct = false;
  List<String> designation = <String>[
    "Incharge-Principal",
    "Asst. Professor",
    "External Faculty",
  ];
  List<dynamic> selectedQua = [];
  List<dynamic> qualification = [];
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

  QuerySnapshot quaData;

  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    quaData =
        await FirebaseFirestore.instance.collection("tbl_qualification").get();
    //  print(quaData.docs.length);
    for (int i = 0; i < quaData.docs.length; i++) {
      qualification.add(quaData.docs[i].data()["name"]);
    }
    // print(qualification.length);
    teachingAll =
        await Provider.of<TeachingStaffProvider>(context, listen: false)
            .getTeachingDetail();
    userAll = await Provider.of<TeachingStaffProvider>(context, listen: false)
        .getUserDetail();
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
    return Form(
      child: SafeArea(
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
              title: Text("Teaching Staff"),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: userAll.length,
                              itemBuilder: (context, i) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    print(userAll[i].email);
                                    Provider.of<TeachingStaffProvider>(context,
                                            listen: false)
                                        .profileEmail = userAll[i].email;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StaffProfile()));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              userAll[i].fname +
                                                  " " +
                                                  userAll[i].mname +
                                                  " " +
                                                  userAll[i].lname +
                                                  "\n",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(teachingAll[i].designation),
                                          ],
                                        ),
                                        Spacer(),
                                        editDeleteButton(i),
                                      ],
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
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
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                this.fnameCon.clear();
                this.mnameCon.clear();
                this.lnameCon.clear();
                this.dateCon.clear();
                this.cnoCon.clear();
                this.emailCon.clear();
                this.pwdCon.clear();
                this.specialIntCon.clear();
                this.experienceCon.clear();
                this.selectedQua.clear();
                _isEdit = false;
                addStaff(context);
              },
            ),
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
            selectedQua = teachingAll[i].qualification;
            selectedDesignation = teachingAll[i].designation;
            experienceCon.text = teachingAll[i].experience;
            specialIntCon.text = teachingAll[i].specialinterest;
            addStaff(context);
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
                              Provider.of<TeachingStaffProvider>(context,
                                      listen: false)
                                  .deleteTeachingUser(userAll[i].email);
                              userAll.clear();
                              teachingAll.clear();
                              setState(() {
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

  addStaff(BuildContext context) {
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
                    ' Staff Details',
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
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
                TextFormField(
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
                TextFormField(
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
                TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter the Date of Birth",
                  ),
                  controller: dateCon,
                  onTap: () {
                    selectDate(context);
                  },
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
                TextFormField(
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
                TextFormField(
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
                TextFormField(
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
                  "  Qualification",
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
                            itemCount: qualification.length,
                            itemBuilder: (context, i) => InkWell(
                                  onTap: () {
                                    selectedQua.add(qualification[i]);
                                    print(selectedQua);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 50.0,
                                        color: Colors.blueGrey[600],
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              qualification[i],
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
                                )),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Experience",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Enter Experience",
                  ),
                  controller: experienceCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Designation",
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
                    hint: Text("Designation"),
                    value: selectedDesignation,
                    items: designation.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      if (mounted) {
                        setState(() {
                          selectedDesignation = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Special Interest",
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
                    hintText: "Enter Special Interest",
                  ),
                  controller: specialIntCon,
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
                          print(selectedQua);
                          print(experienceCon.text);
                          print(selectedDesignation);
                          print(specialIntCon.text);

                          userInfoObj.email = emailCon.text;
                          userInfoObj.password = pwdCon.text;
                          userInfoObj.fname = fnameCon.text;
                          userInfoObj.mname = mnameCon.text;
                          userInfoObj.lname = lnameCon.text;
                          userInfoObj.dob = dateCon.text;
                          userInfoObj.cno = cnoCon.text;
                          userInfoObj.utype = "Teaching Staff";

                          teachingStaffObject.email = emailCon.text;
                          teachingStaffObject.designation = selectedDesignation;
                          teachingStaffObject.qualification = selectedQua;
                          teachingStaffObject.specialinterest =
                              specialIntCon.text;
                          teachingStaffObject.experience = experienceCon.text;
                          print(teachingStaffObject.qualification);
                          // _isEdit
                          //     ? await Provider.of<TeachingStaffProvider>(
                          //             context,
                          //             listen: false)
                          //         .update(emailCon.text, userInfoObj,
                          //             teachingStaffObject)
                          //     : await insert();

                          setState(() {
                            userAll.clear();
                            teachingAll.clear();
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
                          this.specialIntCon.clear();
                          this.experienceCon.clear();
                          this.selectedQua.clear();
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
                        _isEdit ? "Edit Faculty" : "Add Faculty",
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
