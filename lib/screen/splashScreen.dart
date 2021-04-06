import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adminHome.dart';
import 'studentHome.dart';
import 'homeScreen.dart';
import 'teachingHome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String utype = "";

// checkConnection(BuildContext context) async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.none) {
//     isInternetOn = false;
//     _showDialog(context);
//   } else if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     isInternetOn = true;
//     fetchutypeFromSP();
//     Timer(
//       Duration(seconds: 3),
//       () => Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (BuildContext context) => checkPlatform()),
//       ),
//     );
//   }
// }

fetchutypeFromSP() async {
  print('called');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  utype = prefs.getString('utype') ?? "";

  // await checkPlatform();
}

 checkPlatform() {
  if (utype == "Admin") {
    return AdminHome();
  } else if (utype == "TeachingStaff") {
    return TeachingHome();
  } else if (utype == "Student") {
    return StudentHome();
  } else {
    return HomeScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchutypeFromSP();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => checkPlatform()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 239, 241, 1.0),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/tmtlogo.JPG',
                width: MediaQuery.of(context).size.width * 0.20,
              ),
              Text(
                "\nWELCOME TO TMTBCA...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
