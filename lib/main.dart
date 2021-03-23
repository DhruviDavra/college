import 'package:college_management_system/providers/feedbackProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/userProvider.dart';
import './providers/teachingStaffProvider.dart';
import 'providers/seminarProvider.dart';

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
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
