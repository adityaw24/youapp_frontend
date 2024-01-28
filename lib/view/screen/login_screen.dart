import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';
import 'package:youapp_frontend/service/storage_service.dart';
import 'package:youapp_frontend/view/screen/profile_screen.dart';

const httpRequest = HttpRequest();
final storage = StorageService();

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
  dynamic userData;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    widget.onRegister(true);
  }

  void _goProfile() {
    storage.readData('user_data').then((value) {
      setState(() {
        userData = jsonDecode(value!);
      });
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userData: userData),
      ),
    );
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
        _isSubmit = false;
        errorMessage = err.toString();
      });
    }

    setState(() {
      _isSubmit = false;
    });

    _emailController.clear();
    _passwordController.clear();

    _goProfile();
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
                  CupertinoTextField.borderless(
                    placeholder: 'Enter email',
                    controller: _emailController,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                    placeholderStyle: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    enableSuggestions: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CupertinoTextField.borderless(
                    placeholder: 'Enter password',
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                    placeholderStyle: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    suffix: IconButton(
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
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _onSubmit,
                      child: _isSubmit
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : const Text('Login'),
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
