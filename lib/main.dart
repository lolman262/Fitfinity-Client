//import 'dart:html';

//import 'package:flutter/foundation.dart';

// import 'pages/login_page.dart';
import 'pages/login_page_web.dart';
import 'package:flutter/material.dart';
//import 'pages/restapi_test.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

String platform = "";

void main() async {
  // String getOSInsideWeb() {
  //   final userAgent = window.navigator.userAgent.toString().toLowerCase();
  //   if (userAgent.contains("iphone")) return "ios";
  //   if (userAgent.contains("ipad")) return "ios";
  //   if (userAgent.contains("android")) return "Android";
  //   return "Web";
  // }

  // //platform = "";
  // if (kIsWeb) {
  //   platform = getOSInsideWeb();
  // }

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // if(platform == "web"){

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: LoginPageWeb(),

//         home: LoginPageWeb(),

      // },
    );
  }
}
