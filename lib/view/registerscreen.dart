import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/constant.dart';
import 'package:mytutor/view/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/user.png';

  //For profile image
  // ignore: prefer_typing_uninitialized_variables
  var _image;

  //For name, email, password, phone number and home address
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _homeaddrController = TextEditingController();

  bool remember = false;

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
          //Content
          SingleChildScrollView(
            child: SizedBox(
              width: ctrwidth,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Introduction sentence
                      const Text("Register account",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      //The Page Title (Login)
                      // const Text("Register", style: TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 40.0,
                      ),

                      //Profile image upload
                      profileImage(),
                      spaceBlank(),

                      //Name Field
                      nameTextField(),
                      spaceBlank(),

                      //Email address Filed
                      emailTextField(),
                      spaceBlank(),

                      //Password Field
                      passwordTextField(),
                      spaceBlank(),

                      //Phone number
                      phoneTextField(),
                      spaceBlank(),

                      //Home Address
                      homeTextField(),

                      //Remember me Checkbox
                      agreeCheckbox(),

                      //Register Button
                      registerbutton(),
                      spaceBlank(),

                      //Switch to login
                      textLoginHere(),
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

  Widget profileImage() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: _image == null
                ? Image.asset(
                    pathAsset,
                    width: 140,
                    height: 140,
                  )
                : Image.file(
                    _image,
                    width: 140,
                    height: 140,
                  ),
          ),
          Positioned(
            bottom: 5.0,
            right: 5.0,
            child: InkWell(
              onTap: () {
                _takePictureDialog();
              },
              child: const CircleAvatar(
                radius: 25.0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Username",
        prefixIcon: const Icon(
          Icons.person,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      //Validate name
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid username';
        }
        return null;
      },
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Email",
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
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

  Widget phoneTextField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Phone number",
        prefixIcon: const Icon(Icons.call),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter valid phone number';
        }
        bool phoneValid = RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value);
        if (!phoneValid) {
          return 'Please enter valid phone number';
        }
        return null;
      },
    );
  }

  Widget homeTextField() {
    return TextFormField(
      controller: _homeaddrController,
      maxLines: 2,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Home Address",
        prefixIcon: const Icon(Icons.home),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      //Validate home address
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid home address';
        }
        return null;
      },
    );
  }

  Widget agreeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: remember,
          //Remeber me的操作，不明白
          onChanged: (bool? value) {
            _agreestatement(value!);
          },
        ),
        const Text("Accept terms and conditions"),
      ],
    );
  }

  Widget registerbutton() {
    return SizedBox(
      width: screenWidth,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "REGISTER",
          style: GoogleFonts.macondo(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: _insertProfile,
      ),
    );
  }

  Widget textLoginHere() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        //child: Text('Don\'t have an account? Create'),
        child: Text.rich(TextSpan(children: [
          const TextSpan(text: "Already have account ? "),
          TextSpan(
            text: 'Login Here',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ])),
      ),
    );
  }

  Widget spaceBlank() {
    return const SizedBox(
      height: 10,
    );
  }

  void _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select from",
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  takePhoto(ImageSource.gallery),
                  // _galleryPicker(),
                },
                icon: const Icon(Icons.browse_gallery),
                label: const Text(
                  "Gallery",
                ),
              ),
              TextButton.icon(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  takePhoto(ImageSource.camera),
                  // _camrePicker(),
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  "Camera",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _agreestatement(bool value) {
    setState(() {
      remember = value;
    });
  }

  void _insertProfile() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill in the login credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0,
      );
    } else {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String phone = _phoneController.text;
      String home = _homeaddrController.text;
      String base64Image = base64Encode(_image!.readAsBytesSync());

      http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/register_user.php"),
          body: {
            "name": name,
            "email": email,
            "password": password,
            "phone": phone,
            "home": home,
            "image": base64Image,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        }
      });
    }
  }
}
