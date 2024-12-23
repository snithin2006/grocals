import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocals/pages/add_interest.dart';
import 'package:grocals/person.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'interest.dart';
import 'package:grocals/message.dart';
import 'package:grocals/message_repository.dart';

List<Interest> interests = [];
List<Interest> myInterests = [];
List<Interest> interestIDs = [];

Future<List<Interest>> getInterests(int search) async {

  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getInterestsQuery = Paginate(Match(Index('interests_by_produce'), terms:[search]));

  final Person person = await PersonPreferences().getPerson();
  final result = await client.query(getInterestsQuery);
  if (result.hasErrors) {
    print('getInterests: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    interests = [];

    for (var item in itemlist){
      if(item[6] == person.personID || item[9] == person.personID) {
        Interest interest = Interest(interestID: item[0], produceID: item[1], produceName: item[2], price: item[3], quantity: item[4], uom: item[5], producerID: item[6], producerName: item[7], deliveryOrPickup: item[8], consumerID: item[9], consumerName: item[10], comments: item[11], neighborhood: item[12], producePostDate: item[13], interestPostDate: item[14], interestProduceID: item[15], interestProduceName: item[16], interestProducePrice: item[17], interestProduceQuantity: item[18], interestProduceUOM: item[19]);
        interests.add(interest);
      }
    }
  }
  client.close();
  return interests;
}

Future<List<Interest>> getMyInterests() async {

  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  final getInterestsQuery = Paginate(Match(Index('interests_by_id'), terms:[person.personID]));

  final result = await client.query(getInterestsQuery);
  if (result.hasErrors) {
    print('getInterests: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    myInterests = [];

    for (var item in itemlist){
      Interest interest = Interest(interestID: item[0], produceID: item[1], produceName: item[2], price: item[3], quantity: item[4], uom: item[5], producerID: item[6], producerName: item[7], deliveryOrPickup: item[8], consumerID: item[9], consumerName: item[10], comments: item[11], neighborhood: item[12], producePostDate: item[13], interestPostDate: item[14], interestProduceID: item[15], interestProduceName: item[16], interestProducePrice: item[17], interestProduceQuantity: item[18], interestProduceUOM: item[19]);
      myInterests.add(interest);
    }
  }
  myInterests.sort();

  client.close();
  return myInterests;
}

Future<List<Interest>> getInterest(int id) async {

  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getInterestsQuery = Paginate(Match(Index('interests_by_interest'), terms:[id]));

  final result = await client.query(getInterestsQuery);
  if (result.hasErrors) {
    print('getInterests: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));

    interestIDs = [];

    print("itemlist" + itemlist.toString());
    Interest interest = Interest(interestID: itemlist[0][0], produceID: itemlist[0][1], produceName: itemlist[0][2], price: itemlist[0][3], quantity: itemlist[0][4], uom: itemlist[0][5], producerID: itemlist[0][6], producerName: itemlist[0][7], deliveryOrPickup: itemlist[0][8], consumerID: itemlist[0][9], consumerName: itemlist[0][10], comments: itemlist[0][11], neighborhood: itemlist[0][12], producePostDate: itemlist[0][13], interestPostDate: itemlist[0][14], interestProduceID: itemlist[0][15], interestProduceName: itemlist[0][16], interestProducePrice: itemlist[0][17], interestProduceQuantity: itemlist[0][18], interestProduceUOM: itemlist[0][19]);
    interestIDs.add(interest);
  }

  client.close();
  return interestIDs;
}

Future<void> createInterest(Interest interest) async {
  final config = FaunaConfig.build(secret: 'fnAEba7nlhAARD6t9uU04DyCmsN9ngnTCQbh6kIC', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Future<Person> futureResponse = PersonPreferences().getPerson();
  futureResponse.then((response) async {
    Person person = response;
    interest.consumerName = person.name;
    interest.consumerID = person.personID;
    interest.interestID = DateTime.now().millisecondsSinceEpoch;

    final createDocumentQuery = Create(
      Collection('interests'),
      Obj({
        'data': {'interestID': interest.interestID, 'produceID': interest.produceID, 'produceName': interest.produceName, 'price': interest.price, 'quantity': interest.quantity, 'uom': interest.uom, 'producerID': interest.producerID, 'producerName': interest.producerName, 'deliveryOrPickup': interest.deliveryOrPickup, 'consumerID': interest.consumerID, 'consumerName': interest.consumerName, 'comments': interest.comments, 'neighborhood': interest.neighborhood, 'producePostDate': interest.producePostDate, 'interestPostDate': interest.interestPostDate, 'interestProduceID': interest.interestProduceID, 'interestProduceName': interest.interestProduceName, 'interestProducePrice': interest.interestProducePrice, 'interestProduceQuantity': interest.interestProduceQuantity, 'interestProduceUOM': interest.interestProduceUOM}
      }),
    );

    final result = await client.query(createDocumentQuery);
    client.close();

    //add a default message for the interest
    Message newMessage = Message(messageID: DateTime.now().millisecondsSinceEpoch, produceID: interest.produceID, interestID: interest.interestID, produceName: interest.produceName, price: interest.price, quantity: interest.quantity, uom: interest.uom, producerID: interest.producerID, producerName: interest.producerName, deliveryOrPickup: interest.deliveryOrPickup, consumerID: interest.consumerID, consumerName: interest.consumerName, senderID: interest.consumerID, senderName: interest.consumerName, receiverID: interest.producerID, receiverName: interest.producerName, message: interest.comments, neighborhood: interest.neighborhood, producePostDate: interest.producePostDate, interestPostDate: interest.interestPostDate, messagePostDate: interest.interestPostDate, status: "Unread");
    createMessage(newMessage);
  });
}
