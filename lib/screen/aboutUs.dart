import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:blinking_text/blinking_text.dart';

class Aboutus extends StatefulWidget {
  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
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
                            'About Us',
                            style: TextStyle(fontSize: 30),
                            beginColor: Colors.blue[600],
                            endColor: Colors.black,
                            times: 500,
                            //durtaion: Duration(milliseconds: 500)
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "Our Aims and Objectives:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                            "1. To spread education, particularly women's education. \n2.  To take all actions necessary for the fulfillment of the said aims. \n3.  To establish and absorb educational institutions,to give and take alliance, and to unite for the attainment of the said aims.\n4.  Advancement of education as such and assist in that direction and to carry education on a higher plane thereby.\n5.  To take all necessary actions to run activities for the attainment of the above mentioned goals,in a direct or indirect manner.\n6.  To undertake every educational activity promoting all round human development."),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "Our Mission:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          "To encourage career oriented women to opt for information technology.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "To bring-out the hidden potential of women by making them aware of their inner strength. To welcome relevant education programme and  training on the professional front.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "To impart leadership training and imbibe the motto of service to society at large.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
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