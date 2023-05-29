class Interest  implements Comparable<Interest> {
  int interestID;
  int produceID;
  String produceName;
  double price;
  double quantity;
  String uom;
  String producerID;
  String producerName;
  String deliveryOrPickup;
  String consumerID;
  String consumerName;
  String comments;
  String neighborhood;
  String producePostDate;
  String interestPostDate;

  int interestProduceID;
  String interestProduceName;
  double interestProducePrice;
  double interestProduceQuantity;
  String interestProduceUOM;

  Interest(
    {
      required this.interestID,
      required this.produceID,
      required this.produceName,
      required this.price,
      required this.quantity,
      required this.uom,
      required this.producerID,
      required this.producerName,
      required this.deliveryOrPickup,
      required this.consumerID,
      required this.consumerName,
      required this.comments,
      required this.neighborhood,
      required this.producePostDate,
      required this.interestPostDate,

      required this.interestProduceID,
      required this.interestProduceName,
      required this.interestProducePrice,
      required this.interestProduceQuantity,
      required this.interestProduceUOM,
    }
  );

  @override
  int compareTo(Interest other) =>
      other.interestPostDate.compareTo(this.interestPostDate);
}