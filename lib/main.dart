import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/walk_through.dart';
import 'models/managing_directory.dart';
import 'services/shared_prefs_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Directory dir = Directory();
  ShredPrefsServices obj = ShredPrefsServices();
  Widget pageSelector = WalkThrough();
  checkFirstTime() async {
    bool check = await obj.showOnBoardingScreens();
    if (!check) {
      pageSelector = LoginPage();
    } else {
      await obj.setOnBoardingFlag();
    }
  }

  @override
  void initState() {
    dir.createFolder();
    checkFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuizModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDetails(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(primaryColor: Color(0xFF303F9F)),
          home: pageSelector),
    );
  }
}
