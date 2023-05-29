import 'package:flutter/material.dart';
import 'package:grocals/produce.dart';
import '../constants.dart';
import '../person.dart';
import '../produce_repository.dart';
import '../shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

class AddProduce extends StatefulWidget {
  const AddProduce({Key? key}) : super(key: key);

  @override
  _AddProduceState createState() => _AddProduceState();
}

class _AddProduceState extends State<AddProduce> {
  String? dop;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _uomController = TextEditingController();
  late String name;
  late double price;
  late double quantity;
  late String uom;

  bool nameVisible = false;
  bool valueVisible = false;
  bool quantityVisible = false;
  bool uomVisible = false;
  bool visible = false;

  String error = "";

  @override
  Widget build(BuildContext context) {
    final options = ['Pickup', 'Delivery', 'Pickup & Delivery'];

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 20),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Produce'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,5,0,5),
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name of Produce',
                        hintStyle: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: nameVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "The name of your produce must be less than 18 characters",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,5),
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Value',
                        hintStyle: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: valueVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "The value of your produce must be less than 10 characters",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,5),
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Quantity',
                        hintStyle: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: quantityVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "The quantity of your produce must be less than 10 characters",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,5),
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: TextField(
                      controller: _uomController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Unit of Measurement',
                        hintStyle: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: uomVisible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "The unit of measurement of your produce must be less than 10 characters",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,4,0),
                        child: DropdownButton<String>(
                          value: dop,
                          underline: Container(),
                          alignment: Alignment.center,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 8,
                          ),
                          hint: Text(
                            "Pickup or Delivery",
                            style: TextStyle(
                              fontSize: 17,
                              color: kPrimaryColor,
                              decorationColor: kPrimaryColor,
                            ),
                          ),
                          iconDisabledColor: kPrimaryColor,
                          iconEnabledColor: kPrimaryColor,
                          items: options.map(buildMenuItem).toList(),
                          onChanged: (String? newValue) => setState(() {
                            //print(newValue);
                            dop = newValue;
                            print("new val: " + newValue.toString());
                            print("options: " + options.toString());
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visible,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kPrimaryColor,
                  ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      ),
                      onPressed: () async {
                        try {
                          name = _nameController.text;
                        } on FormatException {
                          setState(() {
                            visible = true;
                            error = "Make sure you are entering a valid name";
                          });
                        }

                        try {
                          price = double.parse(_priceController.text);
                        } on FormatException {
                          print(_priceController.text);
                          if(_priceController.text.toString() == "") {
                            price = 0;
                          }
                          setState(() {
                            visible = true;
                            error = "Make sure you are entering a valid number";
                          });
                        }

                        try {
                          quantity = double.parse(_quantityController.text);
                        } on FormatException {
                          setState(() {
                            visible = true;
                            error = "Make sure you are entering a valid number";
                          });
                        }

                        try {
                          uom = _uomController.text;
                        } on FormatException {
                          setState(() {
                            visible = true;
                            error = "Make sure you are entering a valid measurement";
                          });
                        }

                        if(name.length > 18) {
                          setState(() {nameVisible = true;});
                          print(nameVisible);
                        }
                        else if(price.toString().length > 10) {
                          setState(() {valueVisible = true;});
                        }
                        else if(quantity.toString().length > 10) {
                          setState(() {quantityVisible = true;});
                        }
                        else if(uom.length > 10) {
                          setState(() {uomVisible = true;});
                        }


                        else {
                          final Person person = await PersonPreferences().getPerson();
                          var now = new DateTime.now();
                          var formatter = new DateFormat('yyyy-MM-dd');
                          String producePostDate = formatter.format(now);

                          Produce newProduce = Produce(produceID: DateTime.now().millisecondsSinceEpoch, produceName: name, price: price, quantity: quantity, uom: uom, producerID: person.personID, producerName: '', deliveryOrPickup: dop as String, neighborhood: person.city.toUpperCase().removeAllWhitespace(), producePostDate: producePostDate, produceStatus: true);
                          createProduce(newProduce);


                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ),
        ),
            ],
          ),
        ),
      ),
    );
  }
}
