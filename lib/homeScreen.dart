import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "welcome to Smt. Tanuben & Dr. Manubhai Trivedi Colllege of Computer Science",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
