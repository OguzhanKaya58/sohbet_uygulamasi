import 'package:cloud_firestore/cloud_firestore.dart';

class TalkModel {
  final String speaker;
  final String whoAreYouTalking;
  final bool messageSeen;
  final Timestamp date;
  final Timestamp seenDate;
  final String lastMessage;
  String email;
  String talkUser;
  String talkUserProfileUrl;
  DateTime lastReadTime;
  String timeDifference;

  TalkModel({
    this.speaker,
    this.whoAreYouTalking,
    this.messageSeen,
    this.date,
    this.seenDate,
    this.lastMessage,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'speaker': speaker,
      'whoAreYouTalking': whoAreYouTalking,
      'messageSeen': messageSeen,
      'seenDate': seenDate,
      'date': date ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage ?? FieldValue.serverTimestamp(),
      'email': email,
    };
  }

  TalkModel.fromMap(Map<String, dynamic> map)
      : speaker = map['speaker'],
        whoAreYouTalking = map['whoAreYouTalking'],
        messageSeen = map['messageSeen'],
        seenDate = (map['seenDate']),
        date = (map['date']),
        lastMessage = map['lastMessage'],
        email = (map['email']);

  @override
  String toString() {
    return 'Talk{speaker: $speaker, whoAreYouTalking: $whoAreYouTalking, messageSeen: $messageSeen, date: $date, seenDate: $seenDate, lastMessage: $lastMessage, email: $email}';
  }
}
