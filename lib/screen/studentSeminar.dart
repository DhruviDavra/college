import 'package:college_management_system/objects/seminarObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/seminarProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/screen/seminarDetails.dart';

class StudentSeminar extends StatefulWidget {
  @override
  _StudentSeminarState createState() => _StudentSeminarState();
}

class _StudentSeminarState extends State<StudentSeminar> {
  void navigateToPage(BuildContext context) async {
    semester.clear();
    seminarAll.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool _isLoading = false;

  String time;
  SeminarObject seminarObject = SeminarObject();
  TextEditingController topicCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  TextEditingController timeCon = TextEditingController();
  TextEditingController organizerCon = TextEditingController();
  TextEditingController speakerCon = TextEditingController();
  List<dynamic> semester = [];
  List<dynamic> selectedSem = [];
  List<SeminarObject> seminarAll = [];

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

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  QuerySnapshot semData;
  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    semData = await FirebaseFirestore.instance
        .collection("tbl_semester")
        .orderBy('id')
        .get();
    print(semData.docs.length);

    for (int i = 0; i < semData.docs.length; i++) {
      semester.add(semData.docs[i].data()["sem"]);
    }
    print(semester);

    seminarAll = await Provider.of<SeminarProvider>(context, listen: false)
        .getSeminarDetail();

    // print(userAll.length);
    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
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
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text('Seminars'),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: _isLoading
                        ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                      ),
                      SpinKitChasingDots(
                        color:Colors.blueGrey,
                      ),
                    ],
                  )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: seminarAll.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<SeminarProvider>(context,
                                            listen: false)
                                        .detailTime = seminarAll[i].time;

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeminarDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Text(
                                        seminarAll[i].topic,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(seminarAll[i].date + " "),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.01,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
