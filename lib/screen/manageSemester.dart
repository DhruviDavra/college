import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/providers/semesterProvider.dart';
import 'package:college_management_system/objects/semesterObject.dart';

class Semester extends StatefulWidget {
  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  void navigateToPage(BuildContext context) async {
    semester.clear();

    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool _isLoading = false;

  List<SemesterObject> semester = [];

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
semester.clear();
    semester = await Provider.of<SemesterProvider>(context, listen: false)
        .getSemesterDetail();
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
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text('Semester'),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blueGrey,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: semester.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.01,
                                      ),
                                      Text(
                                        semester[i].sem,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[400],
                                    borderRadius: BorderRadius.circular(15),
                                   
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
        ),
      ),
    );
  }
}
