import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/view/loginscreen.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(17, 153, 142, 10),
                    Color.fromRGBO(56, 239, 125, 50),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Image.asset(
                        'assets/images/logo3.png',
                      ),
                    ),
                    Text(
                      "myTutor",
                      style: GoogleFonts.macondo(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const CircularProgressIndicator(),
                const Text(
                  "Version 0.1",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}