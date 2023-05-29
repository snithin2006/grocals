class Message  implements Comparable<Message> {
  int messageID;
  int produceID;
  int interestID;
  String produceName;
  double price;
  double quantity;
  String uom;
  String producerID;
  String producerName;
  String deliveryOrPickup;
  String consumerID;
  String consumerName;
  String senderID;
  String senderName;
  String receiverID;
  String receiverName;
  String message;
  String neighborhood;
  String producePostDate;
  String interestPostDate;
  String messagePostDate;
  String status;
  String refID;


  Message(
    {
      required this.messageID,
      required this.produceID,
      required this.interestID,
      required this.produceName,
      required this.price,
      required this.quantity,
      required this.uom,
      required this.producerID,
      required this.producerName,
      required this.deliveryOrPickup,
      required this.consumerID,
      required this.consumerName,
      required this.senderID,
      required this.senderName,
      required this.receiverID,
      required this.receiverName,
      required this.message,
      required this.neighborhood,
      required this.producePostDate,
      required this.interestPostDate,
      required this.messagePostDate,
      required this.status,
      this.refID = "",
    }
  );

  @override
  int compareTo(Message other) =>
      other.messagePostDate.compareTo(this.messagePostDate);
}