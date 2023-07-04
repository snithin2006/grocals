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
import '../person.dart';
import '../shared_preferences.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Center(
          child: FutureBuilder<List<Produce>>(
            future: getMyProduces(),
            builder: (BuildContext context, AsyncSnapshot<List<Produce>> snapshot) {
              List<Widget> children;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                children = <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: myFilteredProduces.length,
                        itemBuilder: (context, index) {

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                tileColor: Colors.white,
                                onTap: () {Navigator.pushNamed(context, '/produceDetails', arguments: myFilteredProduces[index]);},
                                title: Text(
                                  myFilteredProduces[index].produceName,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Value: \$' + myFilteredProduces[index].price.toString() + '\nQuantity: ' + myFilteredProduces[index].quantity.toString() + " " + myFilteredProduces[index].uom + '\nProducer: ' + myFilteredProduces[index].producerName,
                                  ),
                                trailing: Image.network(myFilteredProduces[index].imageUrl),
                              ),
                          ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kPrimaryColor,
                            ),
                            child:TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/addProduce').then((_){
                                  getMyProduces().then((_) {setState(() {});});});
                                },
                              child: const Text(
                                'New Post',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
          currentIndex: 1,
          onTap: (index) => setState(() {
            if(index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/myInterests');
            }
            else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/inbox');
            }
            else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/account');
            }
          }),
          items: [const BottomNavigationBarItem(
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
          ]),
    );
  }
}
