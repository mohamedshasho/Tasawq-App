import 'package:delivery_app/helper/Strings.dart';

class MessageModel {
  String? id;
  final String sendID;
  final String receiverID;
  final String text;
  final String dateTime;
  final bool read;

  MessageModel(
      {required this.receiverID,
      required this.sendID,
      required this.text,
      required this.dateTime,
      required this.read,
      this.id});
  factory MessageModel.fromJson(Map<String, dynamic> json, String id) {
    return MessageModel(
      id: id,
      receiverID: json[RECEIVER_ID],
      sendID: json[SEND_ID],
      text: json[TEXT],
      read: json[READ],
      dateTime: json[DATE_TIME],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SEND_ID: sendID,
      RECEIVER_ID: receiverID,
      TEXT: text,
      DATE_TIME: dateTime,
      READ: read
    };
  }
}
