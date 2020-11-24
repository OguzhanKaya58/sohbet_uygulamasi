import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/model/talk.dart';
import 'package:sohbet_uygulamasi/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> upDataUserName(String userID, String newUserName);
  Future<bool> upDateProfilePhoto(String userID, String profilePhotoUrl);
  // Future<List<UserModel>> getAllUser();
  Future<List<UserModel>> getUserWithPagination(UserModel lastUser, int numberOfElementsOnThePage);
  Future<List<TalkModel>> getAllConversation(String userID);
  Stream<List<MessageModel>> getMessages(String currentUserID, String talkUserID);
  Future<bool> saveMessages(MessageModel saveMessage);
  Future<DateTime> showHour(String userID);
}
