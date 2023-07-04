import 'package:faunadb_http/query.dart';

class Produce implements Comparable<Produce> {
  int produceID;
  String produceName;
  double price;
  double quantity;
  String uom;
  String producerID;
  String producerName;
  String deliveryOrPickup;
  String neighborhood;
  String producePostDate;
  bool produceStatus;
  String imageUrl;


  Produce(
    {
      required this.produceID,
      required this.produceName,
      required this.price,
      required this.quantity,
      required this.uom,
      required this.producerID,
      required this.producerName,
      required this.deliveryOrPickup,
      required this.neighborhood,
      required this.producePostDate,
      required this.produceStatus,
      required this.imageUrl
    }
  );

  bool operator == (dynamic other) =>
      other != null && other is Produce && this.produceID == other.produceID;

  @override
  int get hashCode => super.hashCode;

  int compareTo(Produce other) =>
      other.producePostDate.compareTo(this.producePostDate);

}