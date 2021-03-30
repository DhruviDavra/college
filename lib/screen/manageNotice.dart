import 'dart:io';
import 'package:college_management_system/screen/noticeDetail.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/noticeProvider.dart';
import 'package:college_management_system/objects/noticeObject.dart';
import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminNotice extends StatefulWidget {
  @override
  _AdminNoticeState createState() => _AdminNoticeState();
}

class _AdminNoticeState extends State<AdminNotice> {
  bool _isLoading = false;

  void navigateToPage(BuildContext context) async {
    noticeAll.clear();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  File file1;
  NoticeObject noticeObject = NoticeObject();
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

  List<NoticeObject> noticeAll = [];

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
    noticeAll = await Provider.of<NoticeProvider>(context, listen: false)
        .getNoticeDetail();

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
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text("Notices"),
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
                                    Provider.of<NoticeProvider>(context,
                                            listen: false)
                                        .particularNotice = noticeAll[i];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoticeDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            epochToLocal(noticeAll[i].time),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text("\n" + noticeAll[i].docname),
                                        ],
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Provider.of<NoticeProvider>(context,
                                                  listen: false)
                                              .deleteNotice(noticeAll[i]);
                                              fetchData();
                                        },
                                        child: Image.asset(
                                          'assets/images/delete.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey[700],
            child: Icon(Icons.add),
            onPressed: () {
              filenameCon.clear();
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.0,
                            ),
                            Text(
                              "Upload File Here",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            InkWell(
                              onTap: () async {
                                await getPdfAndUpload();
                              },
                              child: TextField(
                                decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Tap Here to Load PDF",
                                  enabled: false,
                                ),
                                controller: filenameCon,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  filepath = await Provider.of<NoticeProvider>(
                                          context,
                                          listen: false)
                                      .uploadFile(filename, file1);
                                  if (filepath != null) {
                                    noticeObject.docname = filename;
                                    noticeObject.spath = filepath;

                                    noticeObject.time = DateTime.now()
                                        .toUtc()
                                        .millisecondsSinceEpoch;

                                    // print(noticeObject.docname);
                                    // print(noticeObject.spath);
                                    // print(noticeObject.time);

                                    Provider.of<NoticeProvider>(context,
                                            listen: false)
                                        .addNotice(noticeObject);
                                    Navigator.of(context).pop();
                                    fetchData();
                                  }
                                },
                                child: Text(
                                  "Upload Document",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                  });
            },
          ),
        ),
      ),
    );
  }
}
