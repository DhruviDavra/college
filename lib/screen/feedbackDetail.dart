import 'package:college_management_system/objects/feedbackObject.dart';

import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/feedbackProvider.dart';

class FeedbackDetail extends StatefulWidget {
  @override
  _FeedbackDetailState createState() => _FeedbackDetailState();
}

class _FeedbackDetailState extends State<FeedbackDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  FeedbackObject feedbackObject = FeedbackObject();
  String email;
  bool _isLoading = false;
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

    email = Provider.of<FeedbackProvider>(context, listen: false).email;
    // print(email);
    feedbackObject = await Provider.of<FeedbackProvider>(context, listen: false)
        .getParticularfeedback(email);

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
            title: Text("Feedback Detail"),
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/images/feedback.JPG',
                              height: MediaQuery.of(context).size.height * 0.12,
                              // width: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: Text(
                            "Feedback",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Email:",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Text(feedbackObject.email),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "  Description:",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Text(feedbackObject.des),
                            ),
                          ],
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
