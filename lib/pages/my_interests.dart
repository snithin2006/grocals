import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocals/produce.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'package:grocals/produce_repository.dart';
import '../constants.dart';
import '../interest.dart';
import '../interest_repository.dart';
import '../person.dart';
import '../shared_preferences.dart';

class MyInterests extends StatefulWidget {
  const MyInterests({Key? key}) : super(key: key);

  @override
  _MyInterestsState createState() => _MyInterestsState();
}

class _MyInterestsState extends State<MyInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interests'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Center(
          child: FutureBuilder<List<Interest>>(
            future: getMyInterests(),
            builder: (BuildContext context, AsyncSnapshot<List<Interest>> snapshot) {
              List<Widget> children;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                children = <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: myInterests.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              tileColor: Colors.white,
                              onTap: () {Navigator.pushNamed(context, '/interestDetails', arguments: myInterests[index]);},
                              title: Text(
                                myInterests[index].produceName,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Value: \$' + myInterests[index].price.toString() + '\nQuantity: ' + myInterests[index].quantity.toString() + " " + myInterests[index].uom + '\nProducer: ' + myInterests[index].producerName,
                              ),
                            ),
                          ),
                          );
                        },
                      ),
                    ),
                  ),
                ];
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    width: 80,
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Retrieving Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) => setState(() {
          if(index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/myPosts');
          }
          else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/inbox');
          }
          else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        }),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: kPrimaryColor,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Posts",
            backgroundColor: kPrimaryColor,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Interests",
            backgroundColor: kPrimaryColor,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: "Inbox",
            backgroundColor: kPrimaryColor,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
