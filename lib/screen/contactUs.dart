import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _launchURL() async =>
      await canLaunch("https://www.facebook.com/tmtbcacollege/")
          ? await launch("https://www.facebook.com/tmtbcacollege/")
          : throw 'Could not launch ';
  void _insta() async => await canLaunch("https://www.instagram.com/_tmtians_/")
      ? await launch("https://www.instagram.com/_tmtians_/")
      : throw 'Could not launch ';
  void _mail() async => await canLaunch(
          "http://tmtbcasurat.org/New%20Template/new_guest/index.html")
      ? await launch(
          "http://tmtbcasurat.org/New%20Template/new_guest/index.html")
      : throw 'Could not launch ';

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
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: BlinkText(
                            'Contact Us',
                            style: TextStyle(fontSize: 30),
                            beginColor: Colors.blue[600],
                            endColor: Colors.blueGrey,
                            times: 500,
                            //durtaion: Duration(milliseconds: 500)
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "We welcome your valuable suggestions, Complains and inquiries. You can write to the following address or email to us. We assure you to reply for your mails.",
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          "Wadia Womens' College Campus \nAthawalines, Surat - 3Gujarat, India.95001. \n ",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          "Contact No",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          "+91 - 261 - 2460995 ",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                         SizedBox(
                           height: MediaQuery.of(context).size.height * 0.10,
                         ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                'assets/images/facebook.JPG',
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              onPressed: _launchURL,
                            ),
                            IconButton(
                              icon: Image.asset(
                                'assets/images/instragram.JPG',
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              onPressed: _insta,
                            ),
                            IconButton(
                              icon: Image.asset(
                                'assets/images/mail.JPG',
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              onPressed: _mail,
                            ),
                          ],
                        ),
                      ],
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