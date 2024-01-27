import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';

const httpRequest = HttpRequest();

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onRegister,
  });

  final void Function(bool isLogin) onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  bool _isSubmit = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    widget.onRegister(true);
  }

  void _onSubmit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      errorMessage = null;
      _isSubmit = true;
    });

    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (password.isEmpty || email.isEmpty) {
      setState(() {
        _isSubmit = false;
      });
      return;
    }

    final data = jsonEncode({
      "email": email,
      "username": email,
      "password": password,
    });

    try {
      await httpRequest.login(data);
    } on Exception catch (err) {
      // print('error => $err');
      setState(() {
        errorMessage = err.toString();
      });
    }

    setState(() {
      _isSubmit = false;
    });
  }

  void _snackbarNotification(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              HexColor('#1F4247'),
              HexColor('#0D1D23'),
              HexColor('#09141A'),
            ],
            center: Alignment.topRight,
            radius: 2.3,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.inter(
                      textStyle:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                      ),
                      fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                      enabledBorder: InputBorder.none,
                      alignLabelWithHint: false,
                      filled: true,
                    ),
                    enableSuggestions: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                      ),
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      enabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _passwordVisible = !_passwordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                      filled: true,
                    ),
                    // keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade300,
                      ),
                    ),
                  const SizedBox(
                    height: 28,
                  ),
                  GestureDetector(
                    onTap: _onSubmit,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            // HexColor('#62CDCB80'),
                            // HexColor('#4599DB80'),
                            Color.fromRGBO(98, 205, 203, 0.5),
                            Color.fromRGBO(69, 153, 219, 0.5)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            _isSubmit ? 'Loading...' : 'Login',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                        onPressed: _handleRegister,
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: Colors.amber.shade200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
