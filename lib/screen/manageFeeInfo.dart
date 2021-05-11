import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/usersObject.dart';
import 'package:college_management_system/providers/examProvider.dart';
import 'package:college_management_system/providers/feeProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
import 'package:college_management_system/objects/studentObject.dart';
import 'package:college_management_system/screen/studentProfile.dart';
import 'package:college_management_system/objects/feeObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class FeesInfo extends StatefulWidget {
  @override
  _FeesInfoState createState() => _FeesInfoState();
}

class _FeesInfoState extends State<FeesInfo> {
  FeeObject feeObject = FeeObject();
  bool stud = false;
  String status;
  String radioItem = '';
  bool _isLoading = false;
  String selectedErno;
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
  String div;
  String sem;
  String selectedYear;
  void navigateToPage(BuildContext context) async {
    userOfA.clear();

    studentOfA.clear();
    Navigator.of(context).pop();
  }

  var scrollController = ScrollController();
  List<String> erno = [];
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() {
    selectedDiv = Provider.of<FeeProvider>(context, listen: false).selectedDiv;

    selectedSem = Provider.of<FeeProvider>(context, listen: false).selectedSem;

    getDetailOfA();
    getSemList();
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

  getSemList() async {
    erno = await Provider.of<ExamProvider>(context, listen: false)
        .getErnoSemWise(selectedSem);
  }

  // insert() async {
  //   userInfoObj.uid = await Provider.of<UserProvider>(context, listen: false)
  //       .createUser(emailCon.text, pwdCon.text);
  //   Provider.of<UserProvider>(context, listen: false).addUser(userInfoObj);

  //   Provider.of<StudentProvider>(context, listen: false)
  //       .addStudent(studentObject);
  // }

  List<StudentObject> studentOfA = [];
  List<UserInfoObj> userOfA = [];

  UserInfoObj userInfoObj = UserInfoObj();
  StudentObject studentObject = StudentObject();
  TextEditingController fnameCon = TextEditingController();

  String selectedAddDiv;
  String selectedDiv;
  List<dynamic> division = [];
  String selectedSem;
  DateTime currentDate = DateTime.now();
  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: currentDate,
  //       firstDate: DateTime(1800),
  //       lastDate: DateTime(2050));
  //   if (pickedDate != null && pickedDate != currentDate)
  //     setState(() {
  //       currentDate = pickedDate;
  //       dateCon.text = currentDate.toString().substring(0, 10);
  //     });
  // }

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
              Column(
                children: [
                  Center(
                    child: stdobjA?.isNotEmpty ?? false
                        ? RefreshIndicator(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.84,
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
                                                ((stdobjA[index]
                                                            ?.name
                                                            ?.isEmpty ??
                                                        true)
                                                    ? ""
                                                    : stdobjA[index].name),
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Fee Status: " +
                                                ((stdobjA[index]
                                                            ?.feeStatus
                                                            ?.isEmpty ??
                                                        true)
                                                    ? ""
                                                    : stdobjA[index].feeStatus),
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
        ),
      ),
    );
  }

  Widget editDeleteButton(int index) {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.23,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.white,
            onPressed: () async {
              feeObject.email = stdobjA[index].email;
              feeObject.sem = stdobjA[index].sem;
              feeObject.erno = stdobjA[index].enrollno;

              if (stdobjA[index].feeStatus == "Paid") {
                feeObject.status = "Unpaid";
              }

              if (stdobjA[index].feeStatus == "Unpaid") {
                feeObject.status = "Paid";
              }
              print(feeObject.erno);
              print(feeObject.email);
              print(feeObject.sem);
              print(feeObject.status);

              Provider.of<FeeProvider>(context, listen: false)
                  .updateFeeStatus(feeObject.email, feeObject);
              getdata();
            },
            child: Text(
              "Change",
              style: TextStyle(color: Colors.green[800], fontSize: 14),
            ),
          ),
        ),
      ],
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
        .where("div", isEqualTo: selectedDiv)
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
            QuerySnapshot feeData = await FirebaseFirestore.instance
                .collection("tbl_feeInfo")
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
                String sts;
                sts = feeData.docs.first.data()["status"];
                if (index != null) {
                  stdobjA[index]?.name = name ?? "";
                  stdobjA[index]?.feeStatus = sts ?? "";
                }
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
        .where("div", isEqualTo: selectedDiv)
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
            QuerySnapshot feeData = await FirebaseFirestore.instance
                .collection("tbl_feeInfo")
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
                String sts;
                sts = feeData.docs.first.data()["status"];
                if (index != null) {
                  stdobjA[index]?.name = name ?? "";
                  stdobjA[index]?.feeStatus = sts ?? "";
                }
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
