import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocals/constants.dart';
import 'package:grocals/person_repository.dart';
import 'dart:developer';

import '../person.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
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

class _RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController _nameController = TextEditingController();
  late String name;
  final TextEditingController _emailController = TextEditingController();
  late String email;
  final TextEditingController _passwordController = TextEditingController();
  late String password;
  final TextEditingController _confirmPasswordController = TextEditingController();
  late String confirmPassword;
  final TextEditingController _addressLine1Controller = TextEditingController();
  late String addressLine1 = "";
  final TextEditingController _addressLine2Controller = TextEditingController();
  late String addressLine2 = "";
  final TextEditingController _neighborhoodController = TextEditingController();
  late String neighborhood = "";
  final TextEditingController _cityController = TextEditingController();
  late String city;
  final TextEditingController _countyController = TextEditingController();
  late String county ="";
  final TextEditingController _stateController = TextEditingController();
  late String state;
  final TextEditingController _zipCodeController = TextEditingController();
  late int zipCode = 12345;
  late String secretQuestion;
  final TextEditingController _secretQuestionController = TextEditingController();
  late String secretAnswer;
  final TextEditingController _secretAnswerController = TextEditingController();
  bool isVisible = false;
  bool emailVisibile = false;
  bool stateVisible = false;
  var errorMessage = "";

  @override
  Widget build(BuildContext context) {
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
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 30, 0.0, 0.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 50.0),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.josefinSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          alignLabelWithHint: true,
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
                      child: TextFormField(
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        /*
                    validator: (value) {
                      if (value == null || !value.isValidEmail()) {
                        emailVisibile = true;
                      }
                    },

                     */
                        //validator: (input) => (input == null)?null:(input.isValidEmail() ? null : "         Check your email"),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.white,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          alignLabelWithHint: true,
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
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      height: 45,
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
                        controller: _cityController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.addressBook,
                            color: Colors.white,
                          ),
                          hintText: 'City',
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
                      child: TextFormField(
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        /*
                    validator: (value) {
                      if (value == null || !value.isValidState()) {
                        stateVisible = true;
                      }
                    },

                     */
                        //validator: (input) => (input == null)?null:(input.isValidState() ? null : "         Must be 2 letter state code in CAPS"),
                        controller: _stateController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.addressBook,
                            color: Colors.white,
                          ),
                          hintText: 'State',
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
                        controller: _secretQuestionController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.userSecret,
                            color: Colors.white,
                          ),
                          hintText: 'Secret Question',
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
                        controller: _secretAnswerController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.userSecret,
                            color: Colors.white,
                          ),
                          hintText: 'Secret Answer',
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
                  Visibility(
                    visible: isVisible,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
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
                        color: kPrimaryColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          name = _nameController.text;
                          email = _emailController.text;
                          password = _passwordController.text;
                          confirmPassword = _confirmPasswordController.text;
                          city = _cityController.text;
                          state = _stateController.text;
                          secretQuestion = _secretQuestionController.text;
                          secretAnswer = _secretAnswerController.text;

                          addressLine1 = "";
                          addressLine2 = "";
                          zipCode = 12345;
                          county = "";
                          neighborhood = "";

                          //addressLine1 = _addressLine1Controller.text;
                          //addressLine2 = _addressLine2Controller.text;
                          //zipCode = int.parse(_zipCodeController.text);
                          //county = _countyController.text;
                          //neighborhood = _neighborhoodController.text;

                          final Future<Map<String, dynamic>> futureResponse = getPerson(email, password);
                          futureResponse.then((response) {
                            if(response["status"] == "NotFound") {
                              if(name == "") {
                                log("Enter a valid name");
                                setState(() {isVisible = true; errorMessage = "Enter a valid name";});
                              }
                              else if(!email.isValidEmail()) {
                                log("Enter a valid email");
                                setState(() {isVisible = true; errorMessage = "Enter a valid email";});
                              }
                              else if(password == "") {
                                log("Enter a valid password");
                                setState(() {isVisible = true; errorMessage = "Enter a valid password";});
                              }
                              else if(city ==" ") {
                                log("Enter a valid city");
                                setState(() {isVisible = true; errorMessage = "Enter a valid city";});
                              }
                              else if(name.length > 19) {
                                log("Please enter a name less than 19 characters");
                                setState(() {isVisible = true; errorMessage = "Please enter a name less than 19 characters";});
                              }
                              else if(!state.isValidState()) {
                                log("Enter a valid state");
                                setState(() {isVisible = true; errorMessage = "Enter a valid state code";});
                              }
                              else if(password != confirmPassword) {
                                log("Password does not match Confirm Password");
                                setState(() {isVisible = true; errorMessage = "Password does not match Confirm Password";});
                              }
                              else if (secretQuestion == ""){
                                log("Enter a Secret Question");
                                setState(() {isVisible = true; errorMessage = "Enter a Secret Question";});
                              }
                              else if (secretAnswer == ""){
                                log("Enter a Secret Answer");
                                setState(() {isVisible = true; errorMessage = "Enter a Secret Answer";});
                              }
                              else {
                                Person person = Person(personID: email,
                                    name: name,
                                    password: password,
                                    email: email,
                                    addressLine1: addressLine1,
                                    addressLine2: addressLine2,
                                    neighborhood: neighborhood,
                                    city: city,
                                    county: county,
                                    state: state,
                                    zipCode: zipCode);
                                final Future<Map<String, dynamic>> createFutureResponse = createPerson(person, secretQuestion, secretAnswer);
                                createFutureResponse.then((response) {
                                  Navigator.pop(context);
                                });
                              }
                            }
                            else {
                              setState(() {isVisible = true;errorMessage = "Account exists with this Email";});
                            }
                          }
                          );
                        },

                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
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
                        color: kPrimaryColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*
          body: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 30, 0.0, 0.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 50.0),
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.josefinSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
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
                  child: TextFormField(
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    /*
                    validator: (value) {
                      if (value == null || !value.isValidEmail()) {
                        emailVisibile = true;
                      }
                    },

                     */
                    //validator: (input) => (input == null)?null:(input.isValidEmail() ? null : "         Check your email"),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
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
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 45,
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
                    controller: _cityController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.addressBook,
                        color: Colors.white,
                      ),
                      hintText: 'City',
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
                  child: TextFormField(
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    /*
                    validator: (value) {
                      if (value == null || !value.isValidState()) {
                        stateVisible = true;
                      }
                    },

                     */
                    //validator: (input) => (input == null)?null:(input.isValidState() ? null : "         Must be 2 letter state code in CAPS"),
                    controller: _stateController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.addressBook,
                        color: Colors.white,
                      ),
                      hintText: 'State',
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
                    controller: _secretQuestionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.userSecret,
                        color: Colors.white,
                      ),
                      hintText: 'Secret Question',
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
                    controller: _secretAnswerController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.userSecret,
                        color: Colors.white,
                      ),
                      hintText: 'Secret Answer',
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
              Visibility(
                visible: isVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
                      name = _nameController.text;
                      email = _emailController.text;
                      password = _passwordController.text;
                      confirmPassword = _confirmPasswordController.text;
                      city = _cityController.text;
                      state = _stateController.text;
                      secretQuestion = _secretQuestionController.text;
                      secretAnswer = _secretAnswerController.text;

                      addressLine1 = "";
                      addressLine2 = "";
                      zipCode = 12345;
                      county = "";
                      neighborhood = "";

                      //addressLine1 = _addressLine1Controller.text;
                      //addressLine2 = _addressLine2Controller.text;
                      //zipCode = int.parse(_zipCodeController.text);
                      //county = _countyController.text;
                      //neighborhood = _neighborhoodController.text;

                      final Future<Map<String, dynamic>> futureResponse = getPerson(email, password);
                      futureResponse.then((response) {
                        if(response["status"] == "NotFound") {
                          if(name == "") {
                            log("Enter a valid name");
                            setState(() {isVisible = true; errorMessage = "Enter a valid name";});
                          }
                          else if(!email.isValidEmail()) {
                            log("Enter a valid email");
                            setState(() {isVisible = true; errorMessage = "Enter a valid email";});
                          }
                          else if(password == "") {
                            log("Enter a valid password");
                            setState(() {isVisible = true; errorMessage = "Enter a valid password";});
                          }
                          else if(city ==" ") {
                            log("Enter a valid city");
                            setState(() {isVisible = true; errorMessage = "Enter a valid city";});
                          }
                          else if(name.length > 19) {
                            log("Please enter a name less than 19 characters");
                            setState(() {isVisible = true; errorMessage = "Please enter a name less than 19 characters";});
                          }
                          else if(!state.isValidState()) {
                            log("Enter a valid state");
                            setState(() {isVisible = true; errorMessage = "Enter a valid state code";});
                          }
                          else if(password != confirmPassword) {
                            log("Password does not match Confirm Password");
                            setState(() {isVisible = true; errorMessage = "Password does not match Confirm Password";});
                          }
                          else if (secretQuestion == ""){
                            log("Enter a Secret Question");
                            setState(() {isVisible = true; errorMessage = "Enter a Secret Question";});
                          }
                          else if (secretAnswer == ""){
                            log("Enter a Secret Answer");
                            setState(() {isVisible = true; errorMessage = "Enter a Secret Answer";});
                          }
                          else {
                            Person person = Person(personID: email,
                                name: name,
                                password: password,
                                email: email,
                                addressLine1: addressLine1,
                                addressLine2: addressLine2,
                                neighborhood: neighborhood,
                                city: city,
                                county: county,
                                state: state,
                                zipCode: zipCode);
                            final Future<Map<String, dynamic>> createFutureResponse = createPerson(person, secretQuestion, secretAnswer);
                            createFutureResponse.then((response) {
                              Navigator.pushNamed(context, "/login");
                            });
                            }
                          }
                        else {
                            setState(() {isVisible = true;errorMessage = "Account exists with this Email";});
                          }
                        }
                      );
                    },

                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
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
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
           */
        ),
      ],
    );
  }
}
