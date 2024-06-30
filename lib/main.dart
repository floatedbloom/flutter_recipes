import 'package:flutter/material.dart';
import 'package:flutter_recipes/pages/home_page.dart';
import 'package:flutter_recipes/pages/login.dart';
import 'package:flutter_recipes/session/session_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}

//check if needs to be sent to login or homepage
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = SessionManager.instance.isLoggedIn;

    if (isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginScreen();
    }
  }
}