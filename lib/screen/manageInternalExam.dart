import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/examProvider.dart';
import 'package:college_management_system/objects/examObject.dart';

class Internal extends StatefulWidget {
  @override
  _InternalState createState() => _InternalState();
}

class _InternalState extends State<Internal> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  String sem;
  String etype;
  int total;
  List<int> subCode = [];
  List<TextEditingController> marksCon = [];
  List<String> erno = [];
  String selectedErno;
  List<int> marks = [];
  ExamObject examObject = ExamObject();

  Future<void> getData() async {
    marks.clear();
    sem = Provider.of<ExamProvider>(context, listen: false).sem;
    etype = Provider.of<ExamProvider>(context, listen: false).etype;

    subCode = await Provider.of<ExamProvider>(context, listen: false)
        .getSubCodeSemWise(sem);

    erno = await Provider.of<ExamProvider>(context, listen: false)
        .getErnoSemWise(sem);
    // print(erno);
    print(subCode);
    setState(() {
      if (etype == "Internal") {
        total = 30;
      }
      if (etype == "External") {
        total = 70;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            backgroundColor: Colors.blueGrey[700],
            title: Text(etype + " Exam"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: Form(
            key: _key,
            autovalidateMode: autovalidateMode,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      children: [
                        Text(
                          "Enrollment No:    ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: DropdownButton<String>(
                              hint: Text("Select Enrollment "),
                              value: selectedErno,
                              items: erno.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String value) {
                                if (mounted) {
                                  setState(() {
                                    selectedErno = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width: MediaQuery.of(context).size.width * 0.10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                // height: MediaQuery.of(context).size.height * 0.2,

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '  SubCode',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '  Total Marks',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '  Obtained Marks',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: subCode.length,
                                  itemBuilder: (context, i) => Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                subCode[i].toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                total.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Marks';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    this
                                                        .marks
                                                        .add(int.parse(value));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.blueGrey[600],
                        onPressed: () {
                          _key.currentState.save();
                          if (!_key.currentState.validate()) {
                            if (mounted) {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          }
                          print(selectedErno);
                          //  print(marks);

                          if (selectedErno == null) {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text("Alert!"),
                                content: Text(
                                  "Please Select Enrollment Number!!!",
                                ),
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

                          for (int i = 0; i < marks.length; i++) {
                            if (etype == "Internal") {
                              if (marks[i] >= 30) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Alert!"),
                                    content: Text(
                                      "Please Enter Marks less than 30!!!",
                                    ),
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
                            }
                            if (etype == "External") {
                              if (marks[i] >= 70) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Alert!"),
                                    content: Text(
                                      "Please Enter Marks less than 70!!!",
                                    ),
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
                            }
                          }

                          examObject.erno = selectedErno;
                          examObject.etype = etype;
                          examObject.marks = marks;
                          examObject.sem = sem;
                          examObject.subcode = subCode;
                          examObject.time =
                              DateTime.now().toUtc().millisecondsSinceEpoch;
                          examObject.total = total;

                          if (etype == "Internal") {
                            Provider.of<ExamProvider>(context, listen: false)
                                .addInternalDetails(examObject);
                          }

                          if (etype == "External") {
                           Provider.of<ExamProvider>(context, listen: false)
                                .addExternalDetails(examObject);
                          }
                          marks.clear();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Internal()));
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
