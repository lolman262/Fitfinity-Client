import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logintest/pages/login_page.dart';
import 'package:logintest/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context,snapshot){

          //if logged in
          if(snapshot.hasData){
            return HomePage();
          }
          else{
            return LoginPage();
          }
        }
      ),
    );
  }
  
}