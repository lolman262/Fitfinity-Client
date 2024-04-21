import 'dart:html';

import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import '/components/login_auth.dart';
import 'package:logintest/components/my_button.dart';
import 'package:logintest/components/my_textfield.dart';
import 'package:logintest/components/square_tile.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:dio/dio.dart';

String platform = "";

class LoginPageWeb extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageWeb> {
  //LoginPage({super.key});

  var errMsg = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //final hostname = 'https://api.imnewwdomain.uk';
final hostname = 'http://localhost:443';
  void signUserIn() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errMsg = 'Please fill in all fields';
      });
    } else {
      // if(platform == "web"){
      //   String msg = signUserInLogic(hostname, emailController.text, passwordController.text) as String;
      // }
      //String msg =  signUserInLogic(hostname, emailController.text, passwordController.text) as String;
      signUserInLogic(hostname, emailController.text, passwordController.text);
    }
  }

  Future<String> signUserInLogic(hostname, username, password) async {
    var url = '${hostname}/auth/login';
    var headers = {'Content-Type': 'application/json'};
    var body = {
      'username': username,
      'password': password,
    };

    /// https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683
    /// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    try {
      BaseOptions options = BaseOptions(
        headers: {
          "Accept": "application/json",
        },
      );
      DioForBrowser _d = DioForBrowser(options);
      var adapter = BrowserHttpClientAdapter(withCredentials: true);

      adapter.withCredentials = true;
      _d.httpClientAdapter = adapter;

      var response = await _d.post(
        url,
        options: Options(headers: headers),
        data: body,
      );

      if (response.statusCode == 200) {
        String rawCookie = response.headers['set-cookie'].toString();

             showToast("Signed in successfully");
        print(rawCookie);
        return ("");
   
        // String refreshToken =
        //     (index == -1) ? rawCookie : rawCookie.substring(0, index);
        // int idx = refreshToken.indexOf("=");
        // print(refreshToken.substring(idx + 1).trim());
        //   print('Cookie: ${response.headers}');
      } else if (response.statusCode == 404) {
        // Show toast error for 404 status code
        showToast('Error: Page not found');
        return ('Error: Page not found');
      } else if (response.statusCode == 401) {
        showToast('Incorrect credentials');
        return ('Incorrect credentials');
      } else {
        showToast('Failed to sign in');
        return ('Failed to sign in');
      }
    } catch (e) {
      showToast('Incorrect credentials');
      return ('Incorrect credentials');
      // Handle error
    }
  }

  void testSession() async {
    var url = '${hostname}/api/data';
    var headers = {'Content-Type': 'application/json'};

    BaseOptions options = BaseOptions(
      headers: {
        "Accept": "application/json",
      },
    validateStatus: (int? status) {
    return status != null;
    // return status != null && status >= 200 && status < 300;
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
      showToast(response.data.toString());
      print(response.data);
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      showToast('Unauthorized');
    } else {
      showToast(response.statusCode.toString());
      print(response.statusCode);
      //throw Exception('Failed to create session');
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
    String getOSInsideWeb() {
      final userAgent = window.navigator.userAgent.toString().toLowerCase();
      if (userAgent.contains("iphone")) return "ios";
      if (userAgent.contains("ipad")) return "ios";
      if (userAgent.contains("android")) return "Android";
      return "Web";
    }

    if (kIsWeb) {
      platform = getOSInsideWeb();
    }

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
//
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
                      'Test Login session',
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
