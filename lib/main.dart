import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/view/splashscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "myTutor",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme:
            GoogleFonts.anaheimTextTheme(Theme.of(context).textTheme.apply()),
      ),
      home: const MySplashScreen(title: "myTutor"),
    );
  }
}
