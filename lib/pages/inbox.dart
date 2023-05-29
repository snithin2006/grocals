import 'package:flutter/material.dart';
import 'package:grocals/message.dart';
import 'package:grocals/message_repository.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/produce_repository.dart';
import '../constants.dart';
import '../interest.dart';
import '../interest_repository.dart';
import '../person.dart';
import '../shared_preferences.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Center(
          child: FutureBuilder<List<Message>>(
            future: getInbox(),
            builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
              List<Widget> children;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                children = <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: inbox.length,
                        itemBuilder: (context, index) {
                          Icon i = Icon(Icons.circle_notifications_sharp,color: Colors.grey[400], size: 40,);

                          if(inbox[index].status.toString() == "Unread") {
                            i = Icon(Icons.circle_notifications_sharp, color: kPrimaryColor, size: 40,);
                          }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Card(
                            child: ListTile(
                              leading: i,
                              contentPadding: EdgeInsets.fromLTRB(15, 1, 0, 0),
                              tileColor: Colors.white,
                              onTap: () async {
                                  await getInterest(inbox[index].interestID);
                                  print("interestIDs: " + interestIDs.toString());

                                  Interest newInterest = Interest(interestID: inbox[index].interestID, produceID: inbox[index].interestID, produceName: inbox[index].produceName, price: inbox[index].price, quantity: inbox[index].quantity, uom: inbox[index].uom, producerID: inbox[index].producerID, producerName: inbox[index].producerName, deliveryOrPickup: inbox[index].deliveryOrPickup, consumerID: inbox[index].consumerID, consumerName: inbox[index].consumerName, comments: "", neighborhood: inbox[index].neighborhood, producePostDate: inbox[index].producePostDate, interestPostDate: inbox[index].interestPostDate, interestProduceID: interestIDs[0].interestProduceID, interestProduceName: interestIDs[0].interestProduceName, interestProducePrice: interestIDs[0].interestProducePrice, interestProduceQuantity: interestIDs[0].interestProduceQuantity, interestProduceUOM: interestIDs[0].interestProduceUOM);

                                  await updateMessage(inbox[index].refID);
                                  setState(()  {});

                                  Navigator.pushNamed(context, '/interestDetails', arguments: newInterest);
                                },
                              title: Text(
                                inbox[index].senderName + " - " + inbox[index].produceName,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                inbox[index].message,
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
          currentIndex: 3,
          onTap: (index) => setState(() {
            if(index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            else if(index == 1) {
              Navigator.pushReplacementNamed(context, '/myPosts');
            }
            else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/myInterests');
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
