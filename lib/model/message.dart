import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String fromWho;
  final String toFrom;
  final bool fromMe;
  final String message;
  final Timestamp date;
  //final String speakerPerson;

  MessageModel({this.fromWho, this.toFrom, this.fromMe, this.message, this.date});

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toFrom': toFrom,
      'fromMe': fromMe,
      'message': message,
      //'speakerPerson': speakerPerson,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toFrom = map['toFrom'],
        fromMe = map['fromMe'],
        message = map['message'],
       // speakerPerson = map['speakerPerson'],
        date = (map['date']);

  @override
  String toString() {
    return 'Message{fromWho: $fromWho, toFrom: $toFrom, fromMe: $fromMe, message: $message, date: $date}';
  }
}
