import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocals/person.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';

List<Produce> filteredProduces = [];
List<Produce> myFilteredProduces = [];
List<Produce> guestProduces = [];
List<Produce> produces = [];

extension ExtendedString on String {
  /// The string without any whitespace.
  String removeAllWhitespace() {
    // Remove all white space.
    return this.replaceAll(RegExp(r"\s+"), "");
  }
}

Future<List<Produce>> getProduces(String search) async {
  filteredProduces = [];
  //List<Produce> responseProduces = [];
  final getProducesQuery;
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  getProducesQuery = Paginate(Match(Index('produces_by_city'), terms:[person.city.toUpperCase().removeAllWhitespace()]));
  final result = await client.query(getProducesQuery);
  if (result.hasErrors) {
    print('getProduces: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    filteredProduces = [];

    for (var item in itemlist){
      Produce produce = Produce(produceID: item[0],
          produceName: item[1],
          price: item[2],
          quantity: item[3],
          uom: item[4],
          producerID: item[5],
          producerName: item[6],
          deliveryOrPickup: item[7],
          neighborhood: item[8],
          producePostDate: item[9],
          produceStatus: item[10]);
      if(search == "" && produce.produceStatus == true) {
        filteredProduces.add(produce);
      }
      else {
        if (produce.produceName.toLowerCase().contains(search.toLowerCase()) && produce.produceStatus == true) {
          filteredProduces.add(produce);
        }
      }
    }
  }

  filteredProduces.sort();

  client.close();
  return filteredProduces;
}

Future<List<Produce>> getGuestProduces(String search, String city) async {
  //List<Produce> responseProduces = [];
  final getProducesQuery;
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  getProducesQuery = Paginate(Match(Index('produces_by_city'), terms:[city.toUpperCase().removeAllWhitespace()]));
  final result = await client.query(getProducesQuery);
  if (result.hasErrors) {
    print('getProduces: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    guestProduces = [];

    for (var item in itemlist){
      Produce produce = Produce(produceID: item[0],
          produceName: item[1],
          price: item[2],
          quantity: item[3],
          uom: item[4],
          producerID: item[5],
          producerName: item[6],
          deliveryOrPickup: item[7],
          neighborhood: item[8],
          producePostDate: item[9],
          produceStatus: item[10]);
      if(search == "") {
        guestProduces.add(produce);
      }
      else {
        if (produce.produceName.toLowerCase().contains(search.toLowerCase())) {
          guestProduces.add(produce);
        }
      }
    }
  }

  guestProduces.sort();

  client.close();
  return guestProduces;
}

Future<List<Produce>> getMyProduces() async {
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  final getProducesQuery = Paginate(Match(Index('produces_by_id'), terms:[person.personID]));

  final result = await client.query(getProducesQuery);
  if (result.hasErrors) {
    print('getProduces: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    myFilteredProduces = [];

    for (var item in itemlist){
      if(person.personID == item[5]) {
        Produce produce = Produce(produceID: item[0], produceName: item[1], price: item[2], quantity: item[3], uom: item[4], producerID: item[5], producerName: item[6], deliveryOrPickup: item[7], neighborhood: item[8], producePostDate: item[9], produceStatus: item[10]);
        myFilteredProduces.add(produce);
      }
    }
  }

  myFilteredProduces.sort();

  client.close();
  return myFilteredProduces;
}

Future<void> createProduce(Produce produce) async {
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Future<Person> futureResponse = PersonPreferences().getPerson();
  futureResponse.then((response) async {
    Person person = response;
    produce.producerName = person.name;
    produce.producerID = person.personID;

    final createDocumentQuery = Create(
      Collection('produces'),
      Obj({
        'data': { 'produceID': DateTime.now().millisecondsSinceEpoch, 'produceName': produce.produceName, 'price': produce.price, 'quantity': produce.quantity, 'uom': produce.uom, 'producerID': produce.producerID, 'producerName': produce.producerName, 'deliveryOrPickup': produce.deliveryOrPickup, 'neighborhood': produce.neighborhood, 'producePostDate': produce.producePostDate, 'produceStatus': produce.produceStatus }
      }),
    );

    final result = await client.query(createDocumentQuery);

    client.close();
  });
}

Future<String> getProduceRef(int produceID) async {
  String refID = "";
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final getProduceRefQuery = Paginate(Match(Index('produce_ref_by_id'), terms:[produceID]));

  final result = await client.query(getProduceRefQuery);
  if (result.hasErrors) {
    print('getProduceRefQuery: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {
      return item;
    }));
    if (itemlist.isNotEmpty) {
      var item = itemlist[0];
      refID = item[1];
    }
  }

  client.close();
  return refID;
}

Future<Map<String, dynamic>> updateProduce(Produce produce) async {
  Map<String, dynamic> response = {};
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  String refID = await getProduceRef(produce.produceID);

  final updateMessageQuery = Update(
    Ref(Collection('produces'), refID),
    Obj({
      'data': {
        'produceStatus': produce.produceStatus,
      }
    }),
  );

  final result = await client.query(updateMessageQuery);
  await ProducePreferences().saveProduce(produce);

  client.close();
  return response;
}

/*
Future<Produce?> getProduce(int produceID) async {

  final getProducesQuery;
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  getProducesQuery = Paginate(Match(Index('produce_by_id'), terms:[produceID]));
  final result = await client.query(getProducesQuery);

  Produce? produce;
  if (result.hasErrors) {
    print('getProduce: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));

    var item = itemlist[0];

    produce = Produce(produceID: item[0],
      produceName: item[1],
      price: item[2],
      quantity: item[3],
      uom: item[4],
      producerID: item[5],
      producerName: item[6],
      deliveryOrPickup: item[7],
      neighborhood: item[8],
      producePostDate: item[9],
      produceStatus: item[10]);
  }

  produce = null;

  client.close();
  return produce;
}

 */

/*
Future<List<Produce>> getProduce(int produceID) async {
  produces = [];
  //List<Produce> responseProduces = [];
  final getProducesQuery;
  final config = FaunaConfig.build(secret: '**', domain: 'db.us.fauna.com');
  final client = FaunaClient(config);

  final Person person = await PersonPreferences().getPerson();
  getProducesQuery = Paginate(Match(Index('produce_by_id'), terms:[produceID]));
  final result = await client.query(getProducesQuery);
  if (result.hasErrors) {
    print('getProduce: Error');
    print(result.errors.toString());
  }
  else {
    List itemlist = List.from(result.asMap()['resource']['data'].map((item) {return item;}));
    produces = [];

    for (var item in itemlist){
      Produce produce = Produce(produceID: item[0],
          produceName: item[1],
          price: item[2],
          quantity: item[3],
          uom: item[4],
          producerID: item[5],
          producerName: item[6],
          deliveryOrPickup: item[7],
          neighborhood: item[8],
          producePostDate: item[9],
          produceStatus: item[10]);

      produces.add(produce);
    }
  }

  client.close();

  print("Finished getproduce");

  return produces;
}
 */
