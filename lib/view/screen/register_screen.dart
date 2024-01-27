import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';

const httpRequest = HttpRequest();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegister,
  });

  final void Function(bool isRegister) onRegister;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isSubmit = false;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;
  String? resultMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      errorMessage = null;
      _isSubmit = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _isSubmit = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Password is not same!";
      });
      setState(() {
        _isSubmit = false;
      });
      return;
    }

    final data = jsonEncode({
      "email": email,
      "password": password,
      "username": username,
    });

    try {
      final response = await httpRequest.register(data);
      final result = jsonDecode(response.body);
      setState(() {
        resultMessage = result['message'];
      });
    } on Exception catch (err) {
      // print('error => $err');
      setState(() {
        errorMessage = err.toString();
      });
    }

    setState(() {
      _isSubmit = false;
    });

    _goLogin();
    _snackbarNotification('${resultMessage!}. Please Login.');
  }

  void _goLogin() {
    widget.onRegister(false);
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
                    'Register',
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
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Create Username',
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
                      hintText: 'Create password',
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
                    height: 12,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                      ),
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      enabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                      filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
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
                            _isSubmit ? 'Loading...' : 'Register',
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
                        'Have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                        onPressed: _goLogin,
                        child: Text(
                          'Login here',
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
