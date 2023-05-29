import 'package:grocals/produce.dart';
import 'person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PersonPreferences {
  Future<bool> savePerson(Person person) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("personID", person.personID);
    prefs.setString("name", person.name);
    prefs.setString("password", person.password);
    prefs.setString("email", person.email);
    prefs.setString("addressLine1", person.addressLine1);
    prefs.setString("addressLine2", person.addressLine2);
    prefs.setString("neighborhood", person.neighborhood);
    prefs.setString("city", person.city);
    prefs.setString("county", person.county);
    prefs.setString("state", person.state);
    prefs.setInt("zipCode", person.zipCode);
    prefs.setString("status", person.status);

    Future commit;
    return true;
  }

  Future<Person> getPerson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String personID = prefs.getString("personID") as String;
    String name = prefs.getString("name") as String;
    String password = prefs.getString("password") as String;
    String email = prefs.getString("email") as String;
    String addressLine1 = prefs.getString("addressLine1") as String;
    String addressLine2 = prefs.getString("addressLine2") as String;
    String neighborhood = prefs.getString("neighborhood") as String;
    String city = prefs.getString("city") as String;
    String county = prefs.getString("county") as String;
    String state = prefs.getString("state") as String;
    int zipCode = prefs.getInt("zipCode") as int;
    String status = prefs.getString("status") as String;

    return Person(
      personID: personID,
      name: name,
      password: password,
      email: email,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      neighborhood: neighborhood,
      city: city,
      county: county,
      state: state,
      zipCode: zipCode,
      status: status,
    );
  }

  void removePerson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("personID");
    prefs.remove("name");
    prefs.remove("password");
    prefs.remove("email");
    prefs.remove("addressLine1");
    prefs.remove("addressLine2");
    prefs.remove("neighborhood");
    prefs.remove("city");
    prefs.remove("county");
    prefs.remove("state");
    prefs.remove("zipCode");
    prefs.remove("status");
  }

  Future<String> getPersonID(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("personID") as String;
    return token;
  }
}

class ProducePreferences {
  Future<bool> saveProduce(Produce produce) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("produceID", produce.produceID);
    prefs.setString("produceName", produce.produceName);
    prefs.setDouble("price", produce.price);
    prefs.setDouble("quantity", produce.quantity);
    prefs.setString("uom", produce.uom);
    prefs.setString("producerID", produce.producerID);
    prefs.setString("producerName", produce.producerName);
    prefs.setString("deliveryOrPickup", produce.deliveryOrPickup);
    prefs.setString("neighborhood", produce.neighborhood);
    prefs.setString("producePostDate", produce.producePostDate);
    prefs.setBool("produceStatus", produce.produceStatus);

    Future commit;
    return true;
  }
}
