import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';
import 'package:youapp_frontend/service/utils.dart';

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

    if (username.contains(' ')) {
      setState(() {
        errorMessage = "Username has spaces!";
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
      Utils.logError('Submit Register', err);
      setState(() {
        errorMessage = err.toString();
      });
    }

    setState(() {
      _isSubmit = false;
    });

    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _usernameController.clear();

    _goLogin();
    _snackbarNotification('${resultMessage!}. Please Login.');
  }

  void _goLogin() {
    widget.onRegister(false);
  }

  void _snackbarNotification(String message) {
    Utils.snackbarNotification(context, message);
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
                    placeholder: 'Create username',
                    controller: _usernameController,
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
                    placeholder: 'Create password',
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
                    height: 12,
                  ),
                  CupertinoTextField.borderless(
                    placeholder: 'Confirm password',
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
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
                        _confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
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
                          : const Text('Register'),
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
