import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocals/constants.dart';
import '../person.dart';
import '../person_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart' as globals;


import '../shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  String email = "dummy";
  final TextEditingController _passwordController = TextEditingController();
  late String password;
  late String loginStatus;
  bool isVisible = false;
  var errorMessage = "";

  @override

  Widget build(BuildContext context) {
    final Future<Person> futureResponse = PersonPreferences().getPerson();
    print("future response: " + futureResponse.toString());
    futureResponse.then((response) async {
      Person person = response;
      if(person == null) {
        return Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/grocals_home.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Flexible(
                    child: Center(
                      child: Text(
                        'Grocals',
                        style: GoogleFonts.josefinSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.lock,
                            color: Colors.white,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                    child: Container(
                      height: 45,
                      width: 200,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          email = _emailController.text;
                          password = _passwordController.text;
                          final Future<Map<String, dynamic>> futureResponse = getPerson(email, password);
                          futureResponse.then((response) {
                            if(response["status"] == "Found") {
                              Person person = response["person"];
                              globals.thisPerson = person;

                              Navigator.pushReplacementNamed(context, '/home');
                            }
                            else {
                              setState(() {isVisible = true; errorMessage = "Invalid Email or Password";});
                            }
                          });
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Container(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          email = _emailController.text;
                          //final Future<int> futureResponse = sendEmail(email);
                          final Future<Map<String, dynamic>> futureResponse = getSecretQuestion(email);

                          futureResponse.then((response) {
                            if(response["secretQuestion"] != "") {
                              Navigator.pushReplacementNamed(context, '/resetPassword', arguments: response).then((_) {
                                setState(() {});
                              });
                            }
                            else {
                              setState(() {isVisible = true; errorMessage = "Invalid Email";});
                            }
                          });
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 120.0),
                    child: Container(
                      width: 300,
                      height: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register').then((_) {setState(() {});});
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
      else {
        globals.thisPerson = person;
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/grocals_home.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Text(
                    'Grocals',
                    style: GoogleFonts.josefinSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[500]?.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      prefixIcon: Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[500]?.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.white,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                child: Container(
                  height: 45,
                  width: 250,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                    ),
                    onPressed: () {
                      email = _emailController.text;
                      password = _passwordController.text;
                      final Future<Map<String, dynamic>> futureResponse = getPerson(email, password);
                      futureResponse.then((response) async {
                        if(response["status"] == "Found") {
                          Person person = response["person"];
                          globals.thisPerson = person;

                          Navigator.pushReplacementNamed(context, '/home');
                        }
                        else {
                          setState(() {isVisible = true; errorMessage = "Invalid Email or Password";});
                        }
                      });
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Container(
                  width: 250,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                    ),
                    onPressed: () {
                      email = _emailController.text;
                      //final Future<int> futureResponse = sendEmail(email);
                      final Future<Map<String, dynamic>> futureResponse = getSecretQuestion(email);

                      futureResponse.then((response) {
                        if(response["secretQuestion"] != "") {
                          Navigator.pushReplacementNamed(context, '/resetPassword', arguments: response).then((_) {
                            setState(() {});
                          });
                        }
                        else {
                          setState(() {isVisible = true; errorMessage = "Invalid Email";});
                        }
                      });
                    },
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: Container(
                  width: 250,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/guest');
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 120.0),
                child: Container(
                  width: 250,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register').then((_) {setState(() {});});
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}

