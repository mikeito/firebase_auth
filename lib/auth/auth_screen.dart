import 'package:firebase_auth_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLoginScreen = true;

  void toogleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showRegisterScreen: toogleScreen);
    } else {
      return RegisterScreen(showLoginScreen: toogleScreen);
    }
  }
}
