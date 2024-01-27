import 'package:flutter/material.dart';
import 'package:youapp_frontend/view/screen/login_screen.dart';
import 'package:youapp_frontend/view/screen/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    Widget screen = LoginScreen(
      onRegister: (isRegister) {
        setState(() {
          _isRegister = isRegister;
        });
      },
    );
    if (_isRegister) {
      screen = RegisterScreen(
        onRegister: (isRegister) {
          setState(() {
            _isRegister = isRegister;
          });
        },
      );
    }

    return screen;
  }
}
