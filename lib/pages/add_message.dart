import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifications;
import 'package:grocals/message.dart';
import 'package:grocals/message_repository.dart';
import 'package:grocals/interest.dart';
import 'package:grocals/interest_repository.dart';
import 'package:grocals/produce.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../person.dart';
import '../shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddMessage extends StatefulWidget {
  const AddMessage({Key? key}) : super(key: key);

  @override
  _AddMessageState createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  final TextEditingController _commentsController = TextEditingController();
  late String comments;

  /*
  void sendPushMessage(String token, String body, String title) async {
    try {

      String bodyJSON = jsonEncode(
        <String, dynamic> {
          "to" : token,
          "notification": <String, dynamic> {
            "body" : body,
            "title" : title
          },
        },
      );

      print(bodyJSON);

      http.Response jsonResponse = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String> {
          'Content-Type' : 'application/json',
          'Authorization' : 'key=AAAAeIX1Uh0:APA91bEqVWoCZpGsNpihmHVSBGZCsH7BxF2Wx-OMudpWJhJ1vKoVDbYKYtmXNVgLbVh1YNpmRX6utjynZ-62N7fHlpJcF8LHJc6rdoUyW9Rv923pMYjqUQTmo_fJ-_c1qCoayW3xRStL',
        },
        body: bodyJSON,
      );

      print("status code: " + jsonResponse.statusCode.toString());
      print(jsonResponse.body);

    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

   */

  Widget build(BuildContext context) {

    Interest interest = ModalRoute.of(context)?.settings.arguments as Interest;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Message'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                  controller: _commentsController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    focusColor: Colors.lightGreen,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                  color: kPrimaryColor,
                ),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  ),
                  onPressed: () async {
                    comments = _commentsController.text;
                    //print('interest producer: ' + interest.producerName);
                    //print('interest consumer: ' + interest.consumerName);

                    final Person person = await PersonPreferences().getPerson();

                    var now = new DateTime.now();
                    var formatter = new DateFormat('yyyy-MM-dd');
                    String messagePostDate = formatter.format(now);
                    late String senderID;
                    late String senderName;
                    late String receiverID;
                    late String receiverName;

                    senderID = person.personID;
                    senderName = person.name;
                    if(senderID == interest.producerID){
                      receiverID = interest.consumerID;
                      receiverName = interest.consumerName;
                    }
                    else {
                      receiverID = interest.producerID;
                      receiverName = interest.producerName;
                    }


                    Message newMessage = Message(messageID: DateTime.now().millisecondsSinceEpoch, produceID: interest.produceID, interestID: interest.interestID, produceName: interest.produceName, price: interest.price, quantity: interest.quantity, uom: interest.uom, producerID: interest.producerID, producerName: interest.producerName, deliveryOrPickup: interest.deliveryOrPickup, consumerID: interest.consumerID, consumerName: interest.consumerName, senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, message: comments, neighborhood: interest.neighborhood, producePostDate: interest.producePostDate, interestPostDate: interest.interestPostDate, messagePostDate: messagePostDate, status: "Unread");
                    createMessage(newMessage);

                    print("\nreceiverID: " + receiverID);

                    /*
                    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(receiverID).get();
                    String token = snap['token'];

                    print("receiver token: " + token);
                    print("message body: " + comments);
                    print("sender name: " + senderName);
                    sendPushMessage(token, comments, senderName);

                     */

                    //setState(()  {});

                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15.0),
                    textAlign: TextAlign.center,
                  ),
              ),
      ),
            ),
          ],
        ),
      ),
    );
  }
}