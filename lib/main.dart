import 'package:college_management_system/providers/feedbackProvider.dart';
import 'package:college_management_system/providers/noticeProvider.dart';
import 'package:college_management_system/screen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/userProvider.dart';
import './providers/teachingStaffProvider.dart';
import 'providers/seminarProvider.dart';
import 'package:college_management_system/providers/semesterProvider.dart';
import 'package:college_management_system/providers/studentProvider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screen/adminHome.dart';
// import 'screen/studentHome.dart';
// import 'screen/teachingHome.dart';
// import 'screen/nonTeachingHome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String utype = "";
  // bool _isUtypeEmpty = true;
  // fetchutypeFromSP() async {
  //   print('called');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   utype = prefs.getString('utype') ?? "";
  //   if (utype == "") {
  //     _isUtypeEmpty = true;
  //   } else {
  //     _isUtypeEmpty = false;
  //   }
  //   //await checkPlatform();
  // }

  // checkPlatform() {
  //   // print(utype);
  //   if (utype == "Admin") {
  //     AdminHome();
  //   }
  //   if (utype == "TeachingStaff") {
  //     TeachingHome();
  //   }
  //   // if (utype == "NonTeachingStaff") {
  //   //   NonTeachingHome();
  //   // }
  //   if (utype == "Student") {
  //     StudentHome();
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //  // fetchutypeFromSP();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TeachingStaffProvider>(
          create: (_) => TeachingStaffProvider(),
        ),
        ChangeNotifierProvider<SeminarProvider>(
          create: (_) => SeminarProvider(),
        ),
        ChangeNotifierProvider<FeedbackProvider>(
          create: (_) => FeedbackProvider(),
        ),
        ChangeNotifierProvider<SemesterProvider>(
          create: (_) => SemesterProvider(),
        ),
        ChangeNotifierProvider<StudentProvider>(
          create: (_) => StudentProvider(),
        ),
        ChangeNotifierProvider<NoticeProvider>(
          create: (_) => NoticeProvider(),
        ),
      ],
      // child: Consumer<UserProvider>(
      //   builder: (context, userProvider, child) => MaterialApp(
      //     home: FutureBuilder<void>(
      //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //         if (snapshot.connectionState == ConnectionState.done) {
      //           fetchutypeFromSP();
      //           if (_isUtypeEmpty) {
      //             return SplashScreen();
      //           } else {
      //             return AdminHome();
      //           }
               
      //         }
      //          return SplashScreen();
      //       },
      //     ),
      //   ),
      // ),
      child: MaterialApp(
        home:SplashScreen(),
      ),
    );
  }
}
