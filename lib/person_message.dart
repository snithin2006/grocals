import 'package:faunadb_http/query.dart';
import 'package:grocals/person.dart';

import 'message.dart';

class PersonMessage {
  Person person;
  List<Message> messages;

  PersonMessage(
      {
        required this.person,
        required this.messages,
      }
    );
}