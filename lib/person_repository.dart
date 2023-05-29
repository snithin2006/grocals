import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:grocals/message.dart';
import 'package:grocals/pages/add_interest.dart';
import 'package:grocals/person.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'interest.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

extension ExtendedString on String {
  /// The string without any whitespace.
  String removeAllWhitespace() {
    // Remove all white space.
    return this.replaceAll(RegExp(r"\s+"), "");
  }
}

Future<Map<String, dynamic>> getPerson(String email, String password) async {
  Map<String, dynamic> response = {};
  late Person person;
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  // just added to test firebase DB connection
  //DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child("test");
  //_dbRef.set("Hellow World! ${Random().nextInt(10000)}");

  fire.FirebaseFirestore.instance.collection('testdata').add({'data':"test"});

  final getInterestsQuery = Paginate(Match(Index('person_by_email'), terms:[email]));

  final result = await client.query(getInterestsQuery);
  if (result.hasErrors) {
    print('getPerson: Error');
    print(result.errors.toString());
    response = {
      "status": "Error",
      "person": null,
    };
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    if(itemlist.isNotEmpty) {
      var item = itemlist[0];
      person = Person(personID: item[0], name: item[1], password: item[2], email: item[3], addressLine1: item[4], addressLine2: item[5], neighborhood: item[6], city: item[7], county: item[8], state: item[9], zipCode: item[10], status: item[11]);

      String storedPassword = person.password;
      String hashedPassword = Crypt.sha256(password, salt: person.email).toString();

      if(storedPassword == hashedPassword) {
        PersonPreferences().savePerson(person);
        log('matched');
        response = {
          "status": "Found",
          "person": person,
        };
      }
      else {
        response = {
          "status": "Error",
          "person": null,
        };
      }
    } else {
      response = {
        "status": "NotFound",
        "person": null,
      };
    }
  }

  client.close();
  return response;
}

Future<Map<String, dynamic>> createPerson(Person person, String secretQuestion, String secretAnswer) async {
  Map<String, dynamic> response = {};
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

    String hashedPassword = Crypt.sha256(person.password, salt: person.email)
        .toString();

    final createDocumentQuery = Create(
      Collection('people'),
      Obj({
        'data': {
          'personID': person.personID,
          'name': person.name,
          'password': hashedPassword,
          'email': person.email,
          'addressLine1': person.addressLine1,
          'addressLine2': person.addressLine2,
          'neighborhood': person.neighborhood,
          'city': person.city,
          'county': person.county,
          'state': person.state,
          'zipCode': person.zipCode,
          'status': person.status,
          'secretQuestion': secretQuestion,
          'secretAnswer': secretAnswer
        }
      }),
    );

    final result = await client.query(createDocumentQuery);
    client.close();
    return response;
}

Future<Map<String, dynamic>> updatePerson(Person person) async {
  Map<String, dynamic> response = {};
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  String refID = await getPersonRef(person.email);
  log('updatePerson refID: ' + refID);

  final updateMessageQuery = Update(
    Ref(Collection('people'), refID),
    Obj({
      'data': {
        'email': person.email,
        'city': person.city,
        'state': person.state,
      }
    }),
  );

  final result = await client.query(updateMessageQuery);
  await PersonPreferences().savePerson(person);

  client.close();
  return response;
}

Future<Map<String, dynamic>> updatePassword(String email, String refID, String password) async {
  Map<String, dynamic> response = {};
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  log('updatePassword refID: ' + refID);
  //log('updatePassword email: ' + email);
  //log('updatePassword password: ' + password);
  String hashedPassword = Crypt.sha256(password, salt: email)
      .toString();

  final updateMessageQuery = Update(
    Ref(Collection('people'), refID),
    Obj({
      'data': {
        'password': hashedPassword,
      }
    }),
  );

  final result = await client.query(updateMessageQuery);
  client.close();
  return response;
}

Future<String> getPersonRef(String email) async {
  String refID = "";
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getPersonRefQuery = Paginate(Match(Index('person_ref_by_email'), terms:[email]));

  final result = await client.query(getPersonRefQuery);
  if (result.hasErrors) {
    print('getPersonRefQuery: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {
      return item;
    }));
    if (itemlist.isNotEmpty) {
      var item = itemlist[0];
      refID = item[1];
      log(refID);
    }
  }

  log('getPersonRef ' + refID);
  client.close();
  return refID;
}

Future<String> getSecretAnswer(String email) async {
  String secretAnswer = "";
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getPersonRefQuery = Paginate(Match(Index('person_secret_by_email'), terms:[email]));

  final result = await client.query(getPersonRefQuery);
  if (result.hasErrors) {
    print('getPersonRefQuery: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {
      return item;
    }));
    if (itemlist.isNotEmpty) {
      var item = itemlist[0];
      secretAnswer = item[1];
      //log(secretAnswer);
    }
  }

  //log('getSecretAnswer ' + secretAnswer);
  client.close();
  return secretAnswer;
}

Future<int> sendEmail(String email) async {

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_y3akjn5';
  const templateId = 'template_abrjbex';

  Random random = new Random();
  int resetCode = random.nextInt(2000000) + 1000000;
  String message = "You have submitted request to reset your password. Please enter the following code on the Reset Password screen in the Grocals App. Code=" + resetCode.toString();

  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},//This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': 'jElk6unHOjfMQQ34J',
        'template_params': {
          'to_email': email,
          'message': message
        }
      }));

  log('sendEmail ' + response.statusCode.toString());
  return response.statusCode;
}

Future<Map<String, dynamic>> getSecretQuestion(String email) async {
  Map<String, dynamic> response = {
    "email": "",
    "secretQuestion": "",
  };

  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getPersonRefQuery = Paginate(Match(Index('person_question_by_email'), terms:[email]));

  final result = await client.query(getPersonRefQuery);
  if (result.hasErrors) {
    print('getPersonRefQuery: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {
      return item;
    }));
    if (itemlist.isNotEmpty) {
      var item = itemlist[0];

      var email = item[0];
      var secretAnswer = item[1];
      log('getSecretQuestion ' + email);
      //log('getSecretQuestion ' + secretAnswer);

      response = {
        "email": email,
        "secretQuestion": secretAnswer,
      };
    }
  }

  client.close();
  return response;
}

void deletePerson(Person person) async {
  Map<String, dynamic> response = {};
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  String refID = await getPersonRef(person.email);
  log('deletePerson refID: ' + refID);

  final updateMessageQuery = Delete(
    Ref(Collection('people'), refID),
  );

  final result = await client.query(updateMessageQuery);

  client.close();
}
