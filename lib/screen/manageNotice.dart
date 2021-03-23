import 'package:college_management_system/objects/seminarObject.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/seminarProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management_system/screen/seminarDetails.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
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
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text('Announcements'),
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
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blueGrey,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: seminarAll.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: InkWell(
                                 onTap: (){
                                   Provider.of<SeminarProvider>(context,listen: false).detailTime=seminarAll[i].time;
                                 
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SeminarDetail()));
                                 },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Text(seminarAll[i].topic),
                                      Spacer(),
                                      editDeleteButton(i),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
            onPressed: () {
              this.seminarAll.clear();
              this.speakerCon.clear();
              this.timeCon.clear();
              this.topicCon.clear();
              this.desCon.clear();
              this.organizerCon.clear();
              this.speakerCon.clear();
              this.dateCon.clear();

             
              addSeminar(context);
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
           
            topicCon.text = seminarAll[i].topic;
            desCon.text = seminarAll[i].des;
            dateCon.text = seminarAll[i].date;
            timeCon.text = seminarAll[i].seminarTime;
            organizerCon.text = seminarAll[i].organizer;
            speakerCon.text = seminarAll[i].speaker;
            selectedSem = seminarAll[i].sem;
            time = seminarAll[i].time;
            addSeminar(context);
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
                              print(
                                  seminarAll[i].time);
                              Provider.of<SeminarProvider>(context,
                                      listen: false)
                                  .deleteSeminar(seminarAll[i].time);
                              seminarAll.clear();
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

  addSeminar(BuildContext context) {
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
                  "  Seminar Topic",
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
                    hintText: "Enter the Seminar Topic",
                  ),
                  controller: topicCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Description",
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
                    hintText: "Enter Description",
                  ),
                  controller: desCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "  Semester",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: 70.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: semester.length,
                            itemBuilder: (context, i) => InkWell(
                                  onTap: () {
                                    selectedSem.add(semester[i]);
                                    print(selectedSem);
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
                                              semester[i],
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
                  " Date",
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
                    hintText: "Select the Date",
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
                  "  Time",
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
                    hintText: "Select the Time",
                  ),
                  controller: timeCon,
                  onTap: () async {
                    var time = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    timeCon.text = time.format(context);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "  Organizer",
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
                    hintText: "Enter Organizer Name",
                  ),
                  controller: organizerCon,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "  Speaker",
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
                    hintText: "Enter Speaker Name",
                  ),
                  controller: speakerCon,
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
                          seminarObject.topic = topicCon.text;
                          seminarObject.des = desCon.text;
                          seminarObject.sem = selectedSem;
                          seminarObject.date = dateCon.text;
                          seminarObject.seminarTime = timeCon.text;
                         
                          seminarObject.organizer = organizerCon.text;
                          seminarObject.speaker = speakerCon.text;
                          // print(seminarObject.topic);
                          // print(seminarObject.des);
                          // print(seminarObject.sem);
                          // print(seminarObject.date);
                          // print(seminarObject.seminarTime);
                          // print(seminarObject.time);
                          // print(seminarObject.organizer);
                          // print(seminarObject.speaker);
                          // print(seminarObject.sem);

                          Provider.of<SeminarProvider>(context,
                                      listen: false)
                                  .addSeminar(seminarObject);

                          setState(() {
                            seminarAll.clear();
                            semester.clear();
                            fetchData();
                          });
                          Navigator.of(context).pop();
                          this.topicCon.clear();
                          this.desCon.clear();
                          this.dateCon.clear();
                          this.timeCon.clear();
                          this.organizerCon.clear();
                          this.speakerCon.clear();
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
                        "Add Seminar",
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
