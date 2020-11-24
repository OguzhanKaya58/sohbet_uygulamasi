import 'package:image_picker/image_picker.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/locator/locator.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/model/talk.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/services/auth_base.dart';
import 'package:sohbet_uygulamasi/services/fake_auth_service.dart';
import 'package:sohbet_uygulamasi/services/firebase_auth_service.dart';
import 'package:sohbet_uygulamasi/services/firebase_storage_service.dart';
import 'package:sohbet_uygulamasi/services/firestore_db_servive.dart';
import 'package:sohbet_uygulamasi/services/sending_notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { Debug, Release }

class UserRepository implements AuthBase {
  FirebaseAutoService _firebaseAutoService = locator<FirebaseAutoService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  SendingNotificationService _sendingNotificationService =
      locator<SendingNotificationService>();

  AppMode appMode = AppMode.Release;
  List<UserModel> allUsersList = [];
  Map<String, String> userToken = Map<String, String>();

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      UserModel _user = await _firebaseAutoService.currentUser();
      if (_user != null) {
        return await _fireStoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> singInAnonymously() async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAutoService.singInAnonymously();
    }
  }

  @override
  Future<bool> singOut() async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.singOut();
    } else {
      return await _firebaseAutoService.singOut();
    }
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.singInWithGoogle();
    } else {
      UserModel _user = await _firebaseAutoService.singInWithGoogle();
      bool docExists = await _fireStoreDBService.checkUser(_user.userID);
      if (_user != null) {
        if(docExists == true){
          return await _fireStoreDBService.readUser(_user.userID);
        }else {
          bool _result = await _fireStoreDBService.saveUser(_user);
          if (_result == true) {
            return await _fireStoreDBService.readUser(_user.userID);
          } else {
            await _firebaseAutoService.singOut();
            return null;
          }
        }
      } else
        return null;
    }
  }

  @override
  Future<UserModel> singInWithFacebook() async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.singInWithFacebook();
    } else {
      UserModel _user = await _firebaseAutoService.singInWithFacebook();
      if (_user != null) {
        bool _result = await _fireStoreDBService.saveUser(_user);
        if (_result == true) {
          return await _fireStoreDBService.readUser(_user.userID);
        } else {
          await _firebaseAutoService.singOut();
          return null;
        }
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.createUserWithEmailAndPassword(
          email, password);
    } else {
      UserModel _user = await _firebaseAutoService
          .createUserWithEmailAndPassword(email, password);
      bool _result = await _fireStoreDBService.saveUser(_user);
      if (_result == true) {
        return await _fireStoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> singInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.Debug) {
      return await _fakeAuthenticationService.singInWithEmailAndPassword(
          email, password);
    } else {
      UserModel _user = await _firebaseAutoService.singInWithEmailAndPassword(
          email, password);
      return await _fireStoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.Debug) {
      return false;
    } else {
      return await _fireStoreDBService.upDataUserName(userID, newUserName);
    }
  }

  Future<String> upDateProfilePhoto(
      String userID, String fileType, PickedFile profilePhoto) async {
    if (appMode == AppMode.Debug) {
      return "Dusya indirme linki";
    } else {
      var profilePhotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, profilePhoto);
      await _fireStoreDBService.upDateProfilePhoto(userID, profilePhotoUrl);
      return profilePhotoUrl;
    }
  }

  Stream<List<MessageModel>> getMessages(
      String currentUserID, String talkUserID) {
    if (appMode == AppMode.Debug) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(currentUserID, talkUserID);
    }
  }

  Future<bool> saveMessage(
      MessageModel saveMessage, UserModel currentUser) async {
    if (appMode == AppMode.Debug) {
      return true;
    } else {
      var dbWriteProses = await _fireStoreDBService.saveMessages(saveMessage);
      if (dbWriteProses == true) {
        var token = "";
        if (userToken.containsKey(saveMessage.toFrom)) {
          token = userToken[saveMessage.toFrom];
        } else {
          token = await _fireStoreDBService.bringToken(saveMessage.toFrom);
          if (token != null) {
            userToken[saveMessage.toFrom] = token;
          }
        }
        if (token != null)
          await _sendingNotificationService.sendNotification(
              saveMessage, currentUser, token);
        return true;
      } else
        return false;
    }
  }

  /* Future<List<UserModel>> getAllUser() async {
    if (appMode == AppMode.Debug) {
      return [];
    } else {
      allUsersList = await _fireStoreDBService.getAllUser();
      return allUsersList;
    }
  } */

  Future<List<TalkModel>> getAllConversation(String userID) async {
    if (appMode == AppMode.Debug) {
      return [];
    } else {
      DateTime _date = await _fireStoreDBService.showHour(userID);
      var talkList = await _fireStoreDBService.getAllConversation(userID);
      for (var nowTalk in talkList) {
        var userInUserList = findUser(nowTalk.whoAreYouTalking);
        if (userInUserList != null) {
          nowTalk.talkUser = userInUserList.userName;
          nowTalk.talkUserProfileUrl = userInUserList.profileUrl;
          nowTalk.email = userInUserList.email;
        } else {
          var _bringFirebaseUser =
              await _fireStoreDBService.readUser(nowTalk.whoAreYouTalking);
          nowTalk.talkUser = _bringFirebaseUser.userName;
          nowTalk.talkUserProfileUrl = _bringFirebaseUser.profileUrl;
          nowTalk.email = _bringFirebaseUser.email;
        }
        timeAgoCalculate(nowTalk, _date);
      }
      return talkList;
    }
  }

  UserModel findUser(String userID) {
    for (int i = 0; i < allUsersList.length - 1; i++) {
      if (allUsersList[i].userID == userID) {
        return allUsersList[i];
      }
    }
    return null;
  }

  void timeAgoCalculate(TalkModel nowTalk, DateTime _date) {
    nowTalk.lastReadTime = _date;
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    var duration = _date.difference(nowTalk.date.toDate());
    nowTalk.timeDifference =
        timeago.format(_date.subtract(duration), locale: "tr");
  }

  Future<List<UserModel>> getUserWithPagination(
      UserModel lastUser, int numberOfElementsOnThePage) async {
    if (appMode == AppMode.Debug) {
      return [];
    } else {
      List<UserModel> _userList = await _fireStoreDBService
          .getUserWithPagination(lastUser, numberOfElementsOnThePage);
      allUsersList.addAll(_userList);
      return _userList;
    }
  }

  Future<List<MessageModel>> getMessageWithPagination(
      String currentUserID,
      String talkUserID,
      MessageModel lastMessage,
      int numberOfElementsOnThePage) async {
    if (appMode == AppMode.Debug) {
      return [];
    } else {
      return await _fireStoreDBService.getMessageWithPagination(
          currentUserID, talkUserID, lastMessage, numberOfElementsOnThePage);
    }
  }
}
