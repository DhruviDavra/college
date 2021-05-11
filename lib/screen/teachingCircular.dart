import 'dart:io';
import 'circularDetail.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/circularProvider.dart';
import 'package:college_management_system/objects/circularObject.dart';
import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TeachingCircular extends StatefulWidget {
  @override
  _TeachingCircularState createState() => _TeachingCircularState();
}

class _TeachingCircularState extends State<TeachingCircular> {
  bool _isLoading = false;

  void navigateToPage(BuildContext context) async {
    noticeAll.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  File file1;
  CircularObject circularObject = CircularObject();
  String filename;
  String filepath;
  String dateFromInt;
  TextEditingController filenameCon = TextEditingController();
  Future getPdfAndUpload() async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg'],
    );
    if (file != null) {
      setState(() {
        file1 = file;

        filename = file1.path.split("/").last;
        print("filename: " + filename);
        filenameCon.text = filename;
      });
    }
  }

  List<CircularObject> noticeAll = [];

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  QuerySnapshot noticeData;
  fetchData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    noticeAll.clear();
    noticeAll = await Provider.of<CircularProvider>(context, listen: false)
        .getCircularForFaculty();

    // print(userAll.length);
    if (mounted)
      setState(() {
        _isLoading = false;
      });

    // print(teachingAll);
    // print(userAll);
  }

  String epochToLocal(int epochTime) {
    try {
      DateTime localTime =
          DateTime.fromMillisecondsSinceEpoch(epochTime, isUtc: false);
      return DateFormat("dd-MM-yyyy").format(localTime).toString();
    } catch (e) {
      return "";
    }
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
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text("Circular"),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.90,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: noticeAll.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<CircularProvider>(context,
                                            listen: false)
                                        .particularBook = noticeAll[i];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CircularDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                         
                                          Text(
                                            "Name: " + noticeAll[i].title,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                           Text(
                                            "\n" +
                                                "Upload Date: " +
                                                epochToLocal(noticeAll[i].time),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
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
