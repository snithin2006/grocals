import 'package:flutter/material.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/produce_repository.dart';

import '../constants.dart';
import '../interest.dart';
import '../interest_repository.dart';
import '../person.dart';
import '../shared_preferences.dart';
import '../globals.dart' as globals;

class ProduceDetails extends StatefulWidget {
  const ProduceDetails({Key? key}) : super(key: key);

  @override
  _ProduceDetailsState createState() => _ProduceDetailsState();
}

class _ProduceDetailsState extends State<ProduceDetails> {


  bool isVisible = false;
  String msg = "";


  @override
  Widget build(BuildContext context) {
    Produce produce = ModalRoute.of(context)?.settings.arguments as Produce;
    bool activeBool = produce.produceStatus;

    bool activeVisible;

    print(globals.thisPerson.personID);

    if(globals.thisPerson.personID == produce.producerID) {
      activeVisible = true;
    } else {
      activeVisible = false;
    }

    bool contactVisible;
    if(globals.thisPerson.personID == produce.producerID) {
      contactVisible = false;
    } else {
      contactVisible = true;
    }


    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: const Text('Produce Details'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        child: Center(
          child: FutureBuilder<List<Interest>>(
            future: getInterests(produce.produceID),
            builder: (BuildContext context, AsyncSnapshot<List<Interest>> snapshot) {
              List<Widget> children;

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                
                children = <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Produce',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    produce.produceName,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Quantity',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    produce.quantity.toString() + produce.uom,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Neighborhood',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    produce.neighborhood,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Value',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "\$" + produce.price.toString(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Producer',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    produce.producerName,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Delivery Method',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    produce.deliveryOrPickup,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: activeVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Active",
                          style: const TextStyle(
                            fontSize: 15.0,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Switch(
                          value: activeBool,
                          onChanged: (bool value) async {
                            produce = Produce(produceID: produce.produceID, produceName: produce.produceName, price: produce.price, quantity: produce.quantity, uom: produce.uom, producerID: produce.producerID, producerName: produce.producerName, deliveryOrPickup: produce.deliveryOrPickup, neighborhood: produce.neighborhood, producePostDate: produce.producePostDate, produceStatus: value, imageUrl: produce.imageUrl);
                            await updateProduce(produce);

                            setState(() {
                              Navigator.pushNamed(context, '/myPosts');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Image.network(produce.imageUrl),
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        cacheExtent: 0,
                        addAutomaticKeepAlives: true,
                        itemCount: interests.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                            child: Card(
                              child: ListTile(
                                tileColor: Colors.white,
                                onTap: () {Navigator.pushNamed(context, '/interestDetails', arguments: interests[index]);},
                                title: Text(
                                  interests[index].consumerName,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  interests[index].comments.toString(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Visibility(
                        visible: isVisible,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            msg,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: contactVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: kPrimaryColor,
                        ),
                        onPressed: () async {
                          if(interests.length >= 1) {
                            setState(() {
                              isVisible = true;
                              msg = 'Cannot submit a second interest';
                            });
                          }


                          if(isVisible == false) {
                            Navigator.pushNamed(context, '/addInterest', arguments: produce).then((_){
                              getInterests(produce.produceID).then((_) {setState(() {});});});
                          }
                        },
                        child: const Text('Contact Producer', style: TextStyle(color: Colors.white, fontSize: 18.0))
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
    );

  }
}
