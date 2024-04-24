//import 'dart:html';

import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/browser_client.dart';
import 'package:logintest/components/my_button.dart';
import 'package:logintest/components/my_textfield.dart';
import 'package:logintest/components/square_tile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:dio/dio.dart';

class LoginPageWeb extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();


  
}

class _LoginPageState extends State<LoginPageWeb> {
  //LoginPage({super.key});



  var errMsg = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hostname = 'https://api3.imnewwdomain.uk';

  void testSession() async {
    var url = '${hostname}/api/data';
    var headers = {'Content-Type': 'application/json'};

    BaseOptions options = BaseOptions(
      headers: {
        "Accept": "application/json",
      },
    );
    DioForBrowser _d = DioForBrowser(options);
    var adapter = BrowserHttpClientAdapter(withCredentials: true);
   
    adapter.withCredentials = true;
    _d.httpClientAdapter = adapter;

    var response = await _d.get(
      url,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print(response.statusCode);
      //throw Exception('Failed to create session');
    }
  }

  void signUserIn() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errMsg = 'Please fill in all fields';
      });
    } else {
   //   signUserInWeb();
    }
  }

  

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    
  //     String getOSInsideWeb() {
  //       final userAgent = window.navigator.userAgent.toString().toLowerCase();
  //       if( userAgent.contains("iphone"))  return "ios";
  //       if( userAgent.contains("ipad")) return "ios";
  //       if( userAgent.contains("android"))  return "Android";
  //     return "Web";
  //   }

  // String platform = "";
  //     if(kIsWeb) {
  //       platform = getOSInsideWeb();
  //     }




    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              // error message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      errMsg,
                      style: TextStyle(color: Colors.red[600]),
                    ),
                  ],
                ),
              ),

              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Pasasdsword',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // Your onTap action here
                      testSession();
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
