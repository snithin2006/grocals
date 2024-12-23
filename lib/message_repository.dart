import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocals/message.dart';
import 'package:grocals/pages/add_interest.dart';
import 'package:grocals/person.dart';
import 'package:grocals/person_message.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'interest.dart';

List<Message> messages = [];
List<Message> inbox = [];
List<Message> total = [];
PersonMessage p = PersonMessage(person: Person(personID: "", name: "", password: "", email: "", addressLine1: "", addressLine2: "", neighborhood: "", city: "", county: "", state: "", zipCode: 0), messages: []);

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
        'Authorization' : 'key=**',
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

Future<PersonMessage> getMessages(int search) async {
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);
  final getMessagesForInterestQuery = Paginate(Match(Index('messages_by_interest'), terms:[search]));

  final Person person = await PersonPreferences().getPerson();
  final result = await client.query(getMessagesForInterestQuery);
  if (result.hasErrors) {
    print('getMessages: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));

    messages = [];

    for (var item in itemlist){
      if(item[12] == person.personID || item[14] == person.personID) {
        Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
        messages.add(message);
      }
    }
  }


  p = PersonMessage(person: person, messages: messages);

  client.close();
  return p;
}

Future<List<Message>> getInbox() async {

  List uniqueList(input) {
    List unique = [];

    for(var x in input) {
      if(!unique.contains(x)) {
        unique.add(x);
      }
    }

    return unique;
  }

  inbox = [];
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  final getInboxQuery = Paginate(Match(Index('messages_by_receiverid'), terms:[person.personID]));

  final result = await client.query(getInboxQuery);
  if (result.hasErrors) {
    print('getInbox: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    //int count = 0;
    List produceList = [];

    for (var item in itemlist) {
      produceList.add(item[2]);
    }
    List newList = uniqueList(produceList);

    Iterable list = itemlist.reversed;

    for(var id in newList) {
      int high = 0;
      for(var item in list) {
        if(item[2] == id && item[0] > high) {
          high = item[0];
          //count++;
          /*
          if(count <= 25) {
            Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
            inbox.add(message);
          }

           */
          Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
          inbox.add(message);

        }
      }
    }

    /*
    for (var item in itemlist){
      count++;
      if(item[21] == "Unread" && count <= 25) {
        Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
        inbox.add(message);
      }
    }
    */

  }

  client.close();
  return inbox;
}

Future<List<Message>> getTotal() async {

  List uniqueList(input) {
    List unique = [];

    for(var x in input) {
      if(!unique.contains(x)) {
        unique.add(x);
      }
    }

    return unique;
  }
  total = [];

  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  final getInboxQuery = Paginate(Match(Index('messages_by_receiverid'), terms:[person.personID]));

  final result = await client.query(getInboxQuery);
  if (result.hasErrors) {
    print('getInbox: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    //int count = 0;
    List produceList = [];

    for (var item in itemlist) {
      produceList.add(item[2]);
    }
    List newList = uniqueList(produceList);

    Iterable list = itemlist.reversed;

    for(var id in newList) {
      int high = 0;
      for(var item in list) {
        if(item[2] == id && item[0] > high) {
          high = item[0];
          //count++;
          /*
          if(count <= 25) {
            Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
            inbox.add(message);
          }

           */
          Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
          total.add(message);

        }
      }
    }

    /*
    for (var item in itemlist){
      count++;
      if(item[21] == "Unread" && count <= 25) {
        Message message = Message(messageID: item[0], produceID: item[1], interestID: item[2], produceName: item[3], price: item[4], quantity: item[5], uom: item[6], producerID: item[7], producerName: item[8], deliveryOrPickup: item[9], consumerID: item[10], consumerName: item[11], senderID: item[12], senderName: item[13], receiverID: item[14], receiverName: item[15], message: item[16], neighborhood: item[17], producePostDate: item[18], interestPostDate: item[19], messagePostDate: item[20], status: item[21], refID: item[22]);
        inbox.add(message);
      }
    }
    */

  }

  client.close();
  return total;
}

Future<void> createMessage(Message message) async {
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  message.senderName = person.name;
  message.senderID = person.personID;

  final createDocumentQuery = Create(
    Collection('messages'),
    Obj({
      'data': {'messageID': DateTime.now().millisecondsSinceEpoch, 'produceID': message.produceID, 'interestID': message.interestID, 'produceName':  message.produceName, 'price': message.price, 'quantity': message.quantity, 'uom': message.uom, 'producerID': message.producerID, 'producerName': message.producerName, 'deliveryOrPickup': message.deliveryOrPickup, 'consumerID': message.consumerID, 'consumerName': message.consumerName, 'senderID': message.senderID, 'senderName': message.senderName, 'receiverID': message.receiverID, 'receiverName': message.receiverName, 'message': message.message, 'neighborhood': message.neighborhood, 'producePostDate': message.producePostDate, 'interestPostDate': message.interestPostDate, 'messagePostDate': message.messagePostDate, 'status': message.status, 'refID': message.refID }
    }),
  );

  final result = await client.query(createDocumentQuery);
  client.close();

  firestore.DocumentSnapshot snap = await firestore.FirebaseFirestore.instance.collection("UserTokens").doc(message.receiverID).get();
  String token = snap['token'];

  //print("receiver token: " + token);
  //print("message body: " + message.message);
  //print("sender name: " + message.senderName);
  //print("**********************************");
  //print("");
  sendPushMessage(token, message.message, message.senderName);

}

Future<void> updateMessage(String refID) async {

  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final updateMessageQuery = Update(
    Ref(Collection('messages'), refID),
    Obj({
      'data': { 'status': 'Read' }
    }),
  );

  final result = await client.query(updateMessageQuery);
  client.close();
}
