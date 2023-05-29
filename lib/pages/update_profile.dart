import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocals/produce.dart';
import '../constants.dart';
import '../person.dart';
import '../produce_repository.dart';
import '../shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import '../person.dart';
import '../person_repository.dart';
import '../shared_preferences.dart';

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

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? dop;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  late String email;
  late String city;
  late String state;
  /**
  late String secretQuestion;
  final TextEditingController _secretQuestionController = TextEditingController();
  late String secretAnswer;
  final TextEditingController _secretAnswerController = TextEditingController();
      **/

  @override
  Widget build(BuildContext context) {

    Person person = ModalRoute.of(context)?.settings.arguments as Person;
    //log(person.email);
    _emailController.text = person.email;
    _cityController.text = person.city;
    _stateController.text = person.state;
    //_secretQuestionController.text = "";
    //_secretAnswerController.text = "";

    bool isVisible = false;
    var errorMessage = "";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text(
                person.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,15,0,15),
              child: Container(
                height: 70,
                width: 350,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) => (input == null)?null:(input.isValidEmail() ? null : "         Check your email"),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: false,
                    focusColor: Colors.lightGreen,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,15),
              child: Container(
                height: 70,
                width: 350,
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: false,
                    focusColor: Colors.lightGreen,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,15),
              child: Container(
                height: 70,
                width: 350,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) => (input == null)?null:(input.isValidState() ? null : "         Must be 2 letter state code in CAPS"),
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: false,
                    focusColor: Colors.lightGreen,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),

            /**
                Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,5),
                child: Container(
                height: 70,
                width: 350,
                child: Padding(
                padding: const EdgeInsets.fromLTRB(10,10,0,0),
                child: TextField(
                controller: _secretQuestionController,
                decoration: const InputDecoration(
                labelText: 'Secret Question',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: false,
                focusColor: Colors.lightGreen,
                ),
                keyboardType: TextInputType.text,
                ),
                ),
                ),
                ),
                Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,5),
                child: Container(
                height: 70,
                width: 350,
                child: Padding(
                padding: const EdgeInsets.fromLTRB(10,10,0,0),
                child: TextField(
                controller: _secretAnswerController,
                decoration: const InputDecoration(
                labelText: 'Secret Answer',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: false,
                focusColor: Colors.lightGreen,
                ),
                keyboardType: TextInputType.text,
                ),
                ),
                ),
                ),
             */

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
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kPrimaryColor,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                ),
                onPressed: () async {
                  email = _emailController.text;
                  city = _cityController.text;
                  state = _stateController.text;

                  /**
                      secretQuestion = _secretQuestionController.text;
                      secretAnswer = _secretAnswerController.text;

                      if (secretQuestion =="Secret Question"){
                      log("Enter a Secret Question");
                      setState(() {isVisible = true; errorMessage = "Enter a Secret Question";});
                      }
                      else if (secretAnswer =="Secret Answer"){
                      log("Enter a Secret Answer");
                      setState(() {isVisible = true; errorMessage = "Enter a Secret Answer";});
                      }
                      else {
                   */

                  //print(produces);
                  final Person person = await PersonPreferences().getPerson();
                  var now = new DateTime.now();
                  var formatter = new DateFormat('yyyy-MM-dd');
                  String producePostDate = formatter.format(now);

                  person.email = email;
                  person.city = city;
                  person.state = state;

                  await updatePerson(person);
                  //produces.add(newProduce);
                  //print(produces);
                  Navigator.pop(context, true);
                  /**}*/
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
