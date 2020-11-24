import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/model/talk.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/services/database_base.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    DocumentSnapshot _readUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();
    if (_readUser.data() == null) {
      await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUser =
        await _firebaseDB.collection("users").doc(userID).get();
    if (_readUser.data != null) {
      Map<String, dynamic> _readUserInformationMap = _readUser.data();
      UserModel _readUserObject = UserModel.fromMap(_readUserInformationMap);
      return _readUserObject;
    } else
      return null;
  }

  @override
  Future<bool> upDataUserName(String userID, String newUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> upDateProfilePhoto(String userID, String profilePhotoUrl) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({"profileUrl": profilePhotoUrl});
    return true;
  }

  Future<bool> checkUser(String userID) async {
    var collectionRef = FirebaseFirestore.instance.collection('users');
    var result = await collectionRef.doc(userID).get();
    return result.exists;
  }

  /* @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot _querySnapshot = await _firebaseDB.collection("users").get();
    List<UserModel> allUsers = [];
    for (DocumentSnapshot oneUser in _querySnapshot.docs) {
      UserModel _oneUser = UserModel.fromMap(oneUser.data());
      allUsers.add(_oneUser);
    }
    // Map Metodu ile yapılışı...
    // allUsers = _querySnapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
    return allUsers;
  } */

  @override
  Future<List<TalkModel>> getAllConversation(String userID) async {
    QuerySnapshot _querySnapshot = await _firebaseDB
        .collection("talks")
        .where("speaker", isEqualTo: userID)
        .orderBy("date", descending: true)
        .get();

    List<TalkModel> allTalk = [];
    for (DocumentSnapshot oneTalk in _querySnapshot.docs) {
      TalkModel _oneTalk = TalkModel.fromMap(oneTalk.data());
      allTalk.add(_oneTalk);
    }
    return allTalk;
  }

  /* @override
  Stream<Message> getMessage(String currentUserID, String talkUserID) {
    var snapShat = _firebaseDB
        .collection("talks")
        .doc(currentUserID + "--" + talkUserID)
        .collection("messages")
        .doc(currentUserID)
        .snapshots();
    return snapShat.map((event) => Message.fromMap(event.data()));
  }*/

  @override
  Stream<List<MessageModel>> getMessages(
      String currentUserID, String talkUserID) {
    var snapShat = _firebaseDB
        .collection("talks")
        .doc(currentUserID + "--" + talkUserID)
        .collection("messages")
        //.where("speakerPerson", isEqualTo: currentUserID)
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShat.map((messageList) => messageList.docs
        .map((message) => MessageModel.fromMap(message.data()))
        .toList());
  }

  Future<bool> saveMessages(MessageModel saveMessage) async {
    var _messageID = _firebaseDB.collection("talks").doc().id;
    var _myDocumentID = saveMessage.fromWho + "--" + saveMessage.toFrom;
    var _receiverDocumentID = saveMessage.toFrom + "--" + saveMessage.fromWho;
    var _saveMessageMap = saveMessage.toMap();
    await _firebaseDB
        .collection("talks")
        .doc(_myDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);
    await _firebaseDB.collection("talks").doc(_myDocumentID).set({
      "speaker": saveMessage.fromWho,
      "whoAreYouTalking": saveMessage.toFrom,
      "lastMessage": saveMessage.message,
      "messageSeen": false,
      "date": FieldValue.serverTimestamp(),
    });
    _saveMessageMap.update("fromMe", (value) => false);
    //_saveMessageMap.update("speakerPerson", (value) => saveMessage.toFrom);
    await _firebaseDB
        .collection("talks")
        .doc(_receiverDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);
    await _firebaseDB.collection("talks").doc(_receiverDocumentID).set({
      "speaker": saveMessage.toFrom,
      "whoAreYouTalking": saveMessage.fromWho,
      "lastMessage": saveMessage.message,
      "messageSeen": false,
      "date": FieldValue.serverTimestamp(),
    });
    return true;
  }

  @override
  Future<DateTime> showHour(String userID) async {
    await _firebaseDB.collection("server").doc(userID).set({
      "hour": FieldValue.serverTimestamp(),
    });
    var readMap = await _firebaseDB.collection("server").doc(userID).get();
    Timestamp readHour = readMap.data()["hour"];
    return readHour.toDate();
  }

  @override
  Future<List<UserModel>> getUserWithPagination(
      UserModel lastUser, int numberOfElementsOnThePage) async {
    QuerySnapshot _querySnapshot;
    List<UserModel> _allUsers = [];
    if (lastUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(numberOfElementsOnThePage)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([lastUser.userName])
          .limit(numberOfElementsOnThePage)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snapshot in _querySnapshot.docs) {
      UserModel _oneUser = UserModel.fromMap(snapshot.data());
      _allUsers.add(_oneUser);
    }
    return _allUsers;
  }

  Future<List<MessageModel>> getMessageWithPagination(
      String currentUserID,
      String talkUserID,
      MessageModel lastMessage,
      int numberOfElementsOnThePage) async {
    QuerySnapshot _querySnapshot;
    List<MessageModel> _allMessages = [];
    if (lastMessage == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("talks")
          .doc(currentUserID + "--" + talkUserID)
          .collection("messages")
          //.where("speakerPerson", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .limit(numberOfElementsOnThePage)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("talks")
          .doc(currentUserID + "--" + talkUserID)
          .collection("messages")
          //.where("speakerPerson", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .startAfter([lastMessage.date])
          .limit(numberOfElementsOnThePage)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snapshot in _querySnapshot.docs) {
      MessageModel oneMessage = MessageModel.fromMap(snapshot.data());
      _allMessages.add(oneMessage);
    }
    return _allMessages;
  }

  Future<String> bringToken(String toWho) async {
    DocumentSnapshot _token = await _firebaseDB.doc("tokens/" + toWho).get();
    if (_token != null) {
      return _token.data()['token'];
    } else
      return null;
  }
}
