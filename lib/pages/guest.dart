import 'package:flutter/material.dart';
import 'package:grocals/produce.dart';
import 'package:grocals/produce_repository.dart';
import 'package:grocals/constants.dart';


class Guest extends StatefulWidget {
  const Guest({Key? key}) : super(key: key);

  @override
  _GuestState createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  final TextEditingController _controller = TextEditingController();
  String controller = "";
  String search = "";
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/logo_cropped.png'),
      ),
    ),
  );

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        flexibleSpace: customSearchBar,
        backgroundColor:kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        ),
        actions: <Widget>[
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
                  guestProduces = [];
                }
              });
            },
            icon: customIcon,
          ),
        ],
      ),
      /*
      body: Center(
        child: FutureBuilder<List<Produce>>(
          future: getGuestProduces(search, "Flower Mound"),
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
                        itemCount: guestProduces.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: Card(
                              child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              tileColor: Colors.white,
                              onTap: () {Navigator.pushNamed(context, '/produceDetails', arguments: guestProduces[index]);},
                              title: Text(
                                guestProduces[index].produceName,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Value: \$' + guestProduces[index].price.toString() + '\nQuantity: ' + guestProduces[index].quantity.toString() + " " + guestProduces[index].uom + '\nProducer: ' + guestProduces[index].producerName,
                              ),
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
       */
      body: Center(
        child: FutureBuilder<List<Produce>>(
          future: getGuestProduces(search, controller),
          builder: (BuildContext context, AsyncSnapshot<List<Produce>> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              children = <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 0, 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/1.3,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Enter your city',
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          setState(() {
                            controller = _controller.text;
                          });
                        },
                        color: kPrimaryColor,
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: guestProduces.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              tileColor: Colors.white,
                              onTap: () {Navigator.pushNamed(context, '/guestProduceDetails', arguments: guestProduces[index]);},
                              title: Text(
                                guestProduces[index].produceName,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Value: \$' + guestProduces[index].price.toString() + '\nQuantity: ' + guestProduces[index].quantity.toString() + " " + guestProduces[index].uom + '\nProducer: ' + guestProduces[index].producerName,
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
    );
  }
}