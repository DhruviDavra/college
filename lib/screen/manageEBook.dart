import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/objects/semesterObject.dart';
import 'package:college_management_system/objects/subjectObject.dart';
import 'package:college_management_system/providers/semesterProvider.dart';
import 'package:college_management_system/providers/subjectProvider.dart';
import 'package:college_management_system/screen/bookDetail.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/objects/bookObject.dart';
import 'package:college_management_system/providers/bookProvider.dart';


class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool _isLoading = false;
  TextEditingController filenameCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();

  File file1;
  // NoticeObject noticeObject = NoticeObject();
  String filename;
  String filepath;
  String dateFromInt;
  String sem;
  String subject;

  BookObject bookObject =BookObject();

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

  List<SemesterObject> semester = [];
  List<SubjectObject> subjectList = [];
  List<String> semesterDetail = [];
  List<String> subjectDetail = [];
  List<BookObject> bookDetails = [];

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

    semesterDetail.clear();
    semester.clear();
    bookDetails.clear();
    bookDetails =
        await Provider.of<BookProvider>(context, listen: false)
            .getBooksDetail();

    semester = await Provider.of<SemesterProvider>(context, listen: false)
        .getSemesterDetail();

    for (int i = 0; i < semester.length; i++) {
      semesterDetail.add(semester[i].sem);
    }

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  fetchSubject() async {
    subjectList.clear();
    subjectDetail.clear();
    subjectList = await Provider.of<SubjectProvider>(context, listen: false)
        .getSubjectDetailSemWise(sem);

    for (int i = 0; i < subjectList.length; i++) {
      subjectDetail.add(subjectList[i].subName);
    }
  }

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
            title: Text("E-Books"),
            centerTitle: true,
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
             
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.96,
                    child: _isLoading
                        ? Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              SpinKitChasingDots(
                                color: Colors.blueGrey,
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: bookDetails.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                padding: const EdgeInsets.all(7.0),
                                child: InkWell(
                                  onTap: () {
                                     Provider.of<BookProvider>(context,
                                            listen: false)
                                        .particularBook = bookDetails[i];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookDetail()));
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Text("Title: "+
                                        bookDetails[i].title,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Spacer(),
                                      editDeleteButton(i),
                                    ],
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
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
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
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
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Text(
                              "Syllabus Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Text(
                              "Title",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: "Enter Title",
                              ),
                              controller: titleCon,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
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
                            Text(
                              "Semester",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: DropdownButton<String>(
                                hint: Text("Select Semester"),
                                value: sem,
                                items: semesterDetail.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  if (mounted) {
                                    setState(() {
                                      sem = value;
                                      fetchSubject();
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Text(
                              "Subject",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: DropdownButton<String>(
                                hint: Text("Select Subject"),
                                value: subject,
                                items: subjectDetail.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  if (mounted) {
                                    setState(() {
                                      subject = value;
                                    });
                                  }
                                },
                              ),
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
                                  filepath =
                                      await Provider.of<BookProvider>(
                                              context,
                                              listen: false)
                                          .uploadFile(filename, file1);
                                  if (filepath != null) {
                                    bookObject.title = titleCon.text;
                                    bookObject.subject = subject;
                                    bookObject.sem = sem;
                                    bookObject.docname = filenameCon.text;
                                    bookObject.time = DateTime.now()
                                        .toUtc()
                                        .millisecondsSinceEpoch;
                                    bookObject.path = filepath;

                                    print(bookObject.title);
                                    print(bookObject.subject);
                                    print(bookObject.sem);
                                    print(bookObject.docname);
                                    print(bookObject.time);

                                    Provider.of<BookProvider>(context,
                                            listen: false)
                                        .addBook(bookObject);
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

  Widget editDeleteButton(int i) {
    return Row(
      children: [
       
      
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
                              print(bookDetails[i].time);
                              Provider.of<BookProvider>(context,
                                      listen: false).deleteBook(bookDetails[i]);
                              bookDetails.clear();
                              semester.clear();
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
}