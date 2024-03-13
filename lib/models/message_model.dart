class Message {
  String message;
  String sentbyme;

  Message({
    required this.message,
    required this.sentbyme,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(message: json['message'], sentbyme: json["sentbyme"]);
  }
}
