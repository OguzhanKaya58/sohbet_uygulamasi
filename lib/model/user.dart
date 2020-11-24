import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  final String userID;
  String email;
  String userName;
  String profileUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  UserModel({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) + randomNumberGenerate(),
      'profileUrl': profileUrl ??
          'https://3.bp.blogspot.com/_tokwUEtgc18/SFp3n_9_pBI/AAAAAAAAAW8/t8XSefocfJA/s400/20060814_091110_kedi1.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.idPictureAndUserName({
    @required this.userID,
    @required this.profileUrl,
    @required this.userName,
    @required this.email,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profileUrl = map['profileUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, userName: $userName, profileUrl: $profileUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String randomNumberGenerate() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
