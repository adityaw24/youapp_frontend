import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youapp_frontend/service/utils.dart';
import 'package:youapp_frontend/view/screen/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Utils.logInfo('Logger is working');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      title: 'YouApp',
      debugShowCheckedModeBanner: false,
      theme: MaterialBasedCupertinoThemeData(
        materialTheme: ThemeData().copyWith(
          useMaterial3: true,
          disabledColor: Colors.black,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(9, 20, 26, 1),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
    // return MaterialApp(
    //   title: 'YouApp',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData().copyWith(
    //     useMaterial3: true,
    //     disabledColor: Colors.black,
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: const Color.fromRGBO(9, 20, 26, 1),
    //     ),
    //     textTheme: GoogleFonts.interTextTheme(
    //       Theme.of(context).textTheme,
    //     ),
    //   ),
    //   home: const AuthScreen(),
    // );
  }
}
