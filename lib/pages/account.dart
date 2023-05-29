import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import '../person.dart';
import '../person_repository.dart';
import '../produce.dart';
import '../produce_repository.dart';
import '../shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: FutureBuilder<Person>(
          future: PersonPreferences().getPerson(),
          builder: (BuildContext context, AsyncSnapshot<Person> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Person person = snapshot.data as Person;
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(30) //                 <--- border radius here
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,20,0,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                WidgetSpan(child: Icon(Icons.person, color: Colors.grey,)),
                                                TextSpan(text: 'Name'),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            person.name,
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
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                WidgetSpan(child: Icon(FontAwesomeIcons.envelope, color: Colors.grey,)),
                                                TextSpan(text: '  Email'),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            person.email,
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
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                WidgetSpan(child: Icon(FontAwesomeIcons.addressCard, color: Colors.grey,)),
                                                TextSpan(text: '  City'),
                                              ],
                                            ),
                                          ),

                                          Text(
                                            person.city,
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
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                WidgetSpan(child: Icon(FontAwesomeIcons.addressCard, color: Colors.grey,)),
                                                TextSpan(text: '  State'),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            person.state,
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),),
                            onPressed: () {
                              Navigator.pushNamed(context, '/updateProfile', arguments: person).then((_){
                                PersonPreferences().getPerson().then((_) {setState(() {});});});
                            },
                            child: const Text(
                              'Update Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: Text(
                                    "Are you sure you want to delete your account?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        deletePerson(person);
                                        PersonPreferences().removePerson();
                                        Navigator.pushReplacementNamed(context, '/login');
                                      },
                                      child: Container(
                                        color: kPrimaryColor,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("Yes", style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                )
                              );
                            },
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),),
                            onPressed: () {
                              PersonPreferences().removePerson();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
        currentIndex: 4,
        onTap: (index) => setState(() {
          if(index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/myPosts');
          }
          else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/myInterests');
          }
          else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/inbox');
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