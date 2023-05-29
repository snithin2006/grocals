import 'package:flutter/material.dart';
import 'package:grocals/interest.dart';
import 'package:grocals/interest_repository.dart';
import 'package:grocals/produce.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../person.dart';
import '../produce_repository.dart';
import '../shared_preferences.dart';
class AddInterest extends StatefulWidget {
  const AddInterest({Key? key}) : super(key: key);

  @override
  _AddInterestState createState() => _AddInterestState();
}

class _AddInterestState extends State<AddInterest> {
  final TextEditingController _commentsController = TextEditingController();

  Produce? selectedItem;

  late String comments;
  bool isVisible = false;

  /*
  DropdownMenuItem<Produce> buildMenuItem(Produce item) => DropdownMenuItem(
    value: item,
    child: Text(
      item.produceName,
      style: TextStyle(fontSize: 20),
    ),
  );
  */

  @override
  Widget build(BuildContext context) {
    Produce produce = ModalRoute.of(context)?.settings.arguments as Produce;

    /*
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Start Conversation'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: Container(
                height: 60,
                width: 350,
                child: Padding(
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
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'You cannot be interested in your own produce',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(160, 20, 160, 20),
              child: Container(
                height: 40,
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
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),),
                    onPressed: () async {
                      comments = _commentsController.text;
                      print(comments);
                      final Person person = await PersonPreferences().getPerson();
                      var now = new DateTime.now();
                      var formatter = new DateFormat('yyyy-MM-dd');
                      String interestPostDate = formatter.format(now);

                      print(produce.producerID);
                      print(person.personID);

                      if(produce.producerID == person.personID) {
                        print("hello");
                        setState(() {isVisible = true;});
                        print("isVisible value: " + isVisible.toString());
                      }
                      else {
                        Interest newInterest = Interest(interestID: DateTime.now().millisecondsSinceEpoch, produceID: produce.produceID, produceName: produce.produceName, price: produce.price, quantity: produce.quantity, uom: produce.uom, producerID: produce.producerID, producerName: produce.producerName, deliveryOrPickup: produce.deliveryOrPickup, consumerID: person.personID, consumerName: '', comments: comments, neighborhood: produce.neighborhood, producePostDate: produce.producePostDate, interestPostDate: interestPostDate);
                        print(newInterest.produceID);
                        createInterest(newInterest);
                        Navigator.pop(context, true);
                      }
                    },
                      child: const Text(
                          'Send',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18.0),
                          textAlign: TextAlign.center,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    */

    myFilteredProduces = [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Start Conversation'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: FutureBuilder<List<Produce>>(
          future: getMyProduces(),
          builder: (BuildContext context, AsyncSnapshot<List<Produce>> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {

              List<String> options = [];
              for(Produce item in myFilteredProduces) {
                options.add(item.produceName);
              }

              children = <Widget>[
                Container(
                  height: 60,
                  width: 350,
                  child: Padding(
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
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: DropdownButton<Produce?>(
                    value: selectedItem,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 15,
                    ),
                    hint: Text(
                      "Optional: Exchange Produce",
                      style: TextStyle(
                        fontSize: 15,
                        color: kPrimaryColor,
                        decorationColor: kPrimaryColor,
                      ),
                    ),
                    iconDisabledColor: kPrimaryColor,
                    iconEnabledColor: kPrimaryColor,
                    items: myFilteredProduces.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.produceName,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),

                    //items: options.map(buildMenuItem).toList(),
                    onChanged: (Produce? newValue) => setState(() {
                      selectedItem = newValue;
                    }),
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'You cannot be interested in your own produce',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
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
                      final Person person = await PersonPreferences().getPerson();
                      var now = new DateTime.now();
                      var formatter = new DateFormat('yyyy-MM-dd');
                      String interestPostDate = formatter.format(now);

                      var produceID;
                      var produceName;
                      var producePrice;
                      var produceQuantity;
                      var produceUOM;

                      if(selectedItem == null) {
                        produceID = 0;
                        produceName = "N/A";
                        producePrice = 0.0;
                        produceQuantity = 0.0;
                        produceUOM = "N/A";
                      } else {
                        Produce p = selectedItem as Produce;
                        produceID = p.produceID;
                        produceName = p.produceName;
                        producePrice = p.price;
                        produceQuantity = p.quantity;
                        produceUOM = p.uom;
                      }


                      if(produce.producerID == person.personID) {
                        print("hello");
                        setState(() {isVisible = true;});
                        print("isVisible value: " + isVisible.toString());
                      }
                      else {
                        Interest newInterest = Interest(interestID: DateTime.now().millisecondsSinceEpoch, produceID: produce.produceID, produceName: produce.produceName, price: produce.price, quantity: produce.quantity, uom: produce.uom, producerID: produce.producerID, producerName: produce.producerName, deliveryOrPickup: produce.deliveryOrPickup, consumerID: person.personID, consumerName: '', comments: comments, neighborhood: produce.neighborhood, producePostDate: produce.producePostDate, interestPostDate: interestPostDate, interestProduceID: produceID, interestProduceName: produceName, interestProducePrice: producePrice, interestProduceQuantity: produceQuantity, interestProduceUOM: produceUOM);
                        createInterest(newInterest);
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15.0),
                      textAlign: TextAlign.center,
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
    );
  }
}
