import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocals/message_repository.dart';
import 'package:grocals/produce.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifications;
import 'package:faunadb_http/query.dart';
import 'package:grocals/produce_repository.dart';
import 'package:grocals/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import '../message.dart';
import '../person.dart';
import '../shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String search = "";
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/logo_cropped.png'),
      ),
    ),
  );
  String? mtoken = " ";
  late notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = notifications.FlutterLocalNotificationsPlugin();
  bool noti = false;

  void getNotifications() async {
    total = await getTotal();
    for(Message msg in total) {
      if(msg.status == "Unread") {
        setState(() {
          noti = true;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
    getNotifications();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    /** Enable Foreground Messaging**/
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

  }

  void getToken() async  {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            mtoken = token;
          });
          saveToken(token!);
        }
    );
  }

  void saveToken(String token) async {
    final Person person = await PersonPreferences().getPerson();
    await FirebaseFirestore.instance.collection("UserTokens").doc(person.personID).set({
      'token' : token,
    });
  }

  initInfo() {
    var androidInitialize = const notifications.AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const notifications.DarwinInitializationSettings();
    var initializationsSettings = notifications.InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      notifications.BigTextStyleInformation bigTextStyleInformation = notifications.BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );
      notifications.AndroidNotificationDetails androidPlatformChannelSpecifics = notifications.AndroidNotificationDetails(
        'dbfood', 'dbfood', importance: notifications.Importance.high,
        styleInformation: bigTextStyleInformation, priority: notifications.Priority.high, playSound: false,
      );
      notifications.NotificationDetails platformChannelSpecifics = notifications.NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const notifications.DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    //getNotifications();

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        flexibleSpace: customSearchBar,
        backgroundColor:kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
        actions: <Widget>[
          Visibility(
            visible: noti,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(Icons.notifications_sharp, size: 18,),)
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if(customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = SafeArea(
                    child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        onChanged: (String value){
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Produce Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                else {
                  setState(() {
                    search = "";
                  });
                  customIcon = const Icon(Icons.search);
                  customSearchBar = Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo_cropped.png'),
                      ),
                    ),
                  );
                  filteredProduces = [];
                }
              });
            },
            icon: customIcon,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Produce>>(
          future: getProduces(search),
          builder: (BuildContext context, AsyncSnapshot<List<Produce>> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              children = <Widget>[
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ListView.builder(
                        itemCount: filteredProduces.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                tileColor: Colors.white,
                                onTap: () {Navigator.pushNamed(context, '/produceDetails', arguments: filteredProduces[index]);},
                                title: Text(
                                  filteredProduces[index].produceName,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                'Value: \$' + filteredProduces[index].price.toString() + '\nQuantity: ' + filteredProduces[index].quantity.toString() + " " + filteredProduces[index].uom + '\nProducer: ' + filteredProduces[index].producerName,
                              ),
                                trailing: Image.network(filteredProduces[index].imageUrl),
                            ),
                            ),
                          );
                        },
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) => setState(() {
          if(index == 1) {
            Navigator.pushReplacementNamed(context, '/myPosts');
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
          ),BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: kPrimaryColor,
          ),
      ]),
    );
  }
}