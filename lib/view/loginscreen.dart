import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/constant.dart';
import 'package:mytutor/view/mainscreen.dart';
import 'package:mytutor/view/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Declare screen size
  late double screenHeight, screenWidth, ctrwidth;

  //For rememver checkbox usage
  bool remember = false;

  //Input for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }

    return Scaffold(
      body: Stack(
        children: [
          //Change background
          backgroundSetting(),
          SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: ctrwidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //Logo ecoshop
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                logoMytutor(),
                                Text(
                                  "myTutor",
                                  style: GoogleFonts.macondo(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            spaceBlank(),
                            // Email TextField Column bar
                            emailTextField(),
                            spaceBlank(),
                            // Password TextField Column bar
                            passwordTextField(),
                            spaceBlank(),
                            //Remember me Checkbox
                            checkRememberMe(),
                            //Login Button
                            loginButton(),
                            //Switch to register
                            textLoginHere(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget backgroundSetting() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(17, 153, 142, 10),
              Color.fromRGBO(56, 239, 125, 50),
            ]),
      ),
    );
  }

  Widget logoMytutor() {
    return SizedBox(
      height: screenHeight / 2.5,
      width: screenWidth,
      child: Image.asset("assets/images/logo3.png"),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),

      //验证方式
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter valid email';
        }
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);

        if (!emailValid) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),

      //验证密码
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  Widget checkRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: remember,
          //Remeber me的操作，不明白
          onChanged: (bool? value) {
            _oncheckRememberMeChanged(value!);
          },
        ),
        const Text("Remeber Me"),
      ],
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: screenWidth,
      height: 50.0,
      child: ElevatedButton(
        child: Text("LOGIN",
            style: GoogleFonts.macondo(
              fontSize: 18.0,
              color: Colors.white,
            )),
        onPressed: _loginUser,
      ),
    );
  }

  Widget spaceBlank() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget textLoginHere() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        //child: Text('Don\'t have an account? Create'),
        child: Text.rich(TextSpan(children: [
          const TextSpan(text: "Don't have an account ? "),
          TextSpan(
            text: 'Register Here',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ])),
      ),
    );
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        _emailController.text = "";
        _passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _oncheckRememberMeChanged(bool value) {
    remember = value;
    setState(() {
      setState(() {
        if (remember) {
          _saveRemovePref(true);
        } else {
          _saveRemovePref(false);
        }
      });
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill in the login credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0,
      );
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/login_user.php"),
        body: {"email": email, "password": password}).then(
      (response) {
        // print(response.body);
        var data = jsonDecode(response.body);
        // print(data);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            fontSize: 16.0,
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            fontSize: 16.0,
          );
        }
      },
    );
  }
}
