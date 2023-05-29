import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocals/person_repository.dart';
import 'dart:developer';

import '../person.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension ZipValidator on String {
  bool isValidZip() {
    return RegExp(r'^[0-9]{5}$').hasMatch(this);
  }
}

extension StateValidator on String {
  bool isValidState() {
    return RegExp(r'^[A-Z]{2}$').hasMatch(this);
  }
}

class _ResetPasswordState extends State<ResetPassword> {

  final TextEditingController _secretAnswerController = TextEditingController();
  late String secretAnswer;
  final TextEditingController _emailController = TextEditingController();
  late String email;
  final TextEditingController _passwordController = TextEditingController();
  late String password;
  final TextEditingController _confirmPasswordController = TextEditingController();
  late String confirmPassword;

  bool isVisible = false;
  var errorMessage = "";

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> contextResponse = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _secretAnswerController.text = contextResponse['secretQuestion'];
    _emailController.text = contextResponse['email'];

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 50.0),
                  child: Center(
                    child: Text(
                      'Reset Password',
                      style: GoogleFonts.josefinSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: _secretAnswerController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.userSecret,
                          color: Colors.white,
                        ),
                        helperText: 'Secret Answer',
                        helperStyle: TextStyle(color: Colors.white, fontSize: 12),
                        alignLabelWithHint: true,
                        //contentPadding: EdgeInsets.only(top: 50, left: 10),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,),
                        fillColor: Colors.white,
                        filled: false,
                        focusColor: Colors.lightGreen,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black,fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => (input == null)?null:(input.isValidEmail() ? null : "         Check your email"),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.white,
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white,),
                        alignLabelWithHint: true,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black,fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    height: 70,
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.white,
                        ),
                        hintText: 'Confirm Password',
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
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: TextButton(
                      onPressed: () {
                        secretAnswer = _secretAnswerController.text;
                        email = _emailController.text;
                        password = _passwordController.text;
                        confirmPassword = _confirmPasswordController.text;

                        final Future<String> refIDResponse = getPersonRef(email);
                        refIDResponse.then((refID) {
                          if(refID != "") {
                            if(password != confirmPassword) {
                              log("Password does not match Confirm Password");
                              setState(() {isVisible = true; errorMessage = "Password does not match Confirm Password";});
                            }
                            else {
                              final Future<String> secretResponse = getSecretAnswer(email);
                              secretResponse.then((personSecretAnswer) {
                                if(personSecretAnswer != "") {
                                  if(secretAnswer != personSecretAnswer) {
                                    log("Invalid Secret Answer");
                                    setState(() {isVisible = true; errorMessage = "Invalid Secret Answer";});
                                  }
                                  else {
                                    final Future<Map<String, dynamic>> createFutureResponse = updatePassword(email, refID, password);
                                    createFutureResponse.then((response) {
                                      Navigator.pushNamed(context, "/login");
                                    });
                                  }
                                }
                                else {
                                  setState(() {isVisible = true;errorMessage = "Invalid Email";});
                                }
                              }
                              );

                              final Future<Map<String, dynamic>> createFutureResponse = updatePassword(email, refID, password);
                              createFutureResponse.then((response) {
                                Navigator.pushNamed(context, "/login");
                              });
                              }
                            }
                          else {
                              setState(() {isVisible = true;errorMessage = "Invalid Email";});
                            }
                          }
                        );
                      },

                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                  child: Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
