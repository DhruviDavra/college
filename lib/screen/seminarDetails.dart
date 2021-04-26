import 'package:flutter/material.dart';
import 'package:college_management_system/objects/seminarObject.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/seminarProvider.dart';

class SeminarDetail extends StatefulWidget {
  @override
  _SeminarDetailState createState() => _SeminarDetailState();
}

class _SeminarDetailState extends State<SeminarDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  bool _isLoading = false;
  SeminarObject seminarObject = SeminarObject();
  String time;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    time = Provider.of<SeminarProvider>(context, listen: false).detailTime;
    // print(email);
    seminarObject = await Provider.of<SeminarProvider>(context, listen: false)
        .getParticularSeminar(time);

    if (mounted)
      setState(() {
        _isLoading = false;
      });
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
            centerTitle: true,
            title: Text("Seminar Detail"),
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/teaching.png',
                            height: MediaQuery.of(context).size.height * 0.10,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          seminarObject.topic,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Description:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(seminarObject.des),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Date:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(seminarObject.date),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Time:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(seminarObject.time),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Organizer:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(seminarObject.organizer),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Speaker",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(seminarObject.speaker),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
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
