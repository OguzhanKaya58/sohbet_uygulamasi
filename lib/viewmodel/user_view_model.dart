import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/locator/locator.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/model/talk.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/repository/user_repository.dart';
import 'package:sohbet_uygulamasi/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _user;
  String emailErrorMessage;
  String passwordErrorMessage;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel get user => _user;
  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      notifyListeners();
      if (_user != null) {
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> singInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInAnonymously();
      notifyListeners();
      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.singOut();
      notifyListeners();
      _user = null;
      return result;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInWithGoogle();
      notifyListeners();
      if (_user != null) {
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> singInWithFacebook() async {
    try {
      state = ViewState.Busy;
      notifyListeners();
      _user = await _userRepository.singInWithFacebook();
      if (_user != null) {
        return _user;
      } else {
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  // ignore: missing_return
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password) async {
    if (_emailPasswordControl(email, password)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password);
        notifyListeners();
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    }
  }

  @override
  Future<UserModel> singInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (_emailPasswordControl(email, password)) {
        state = ViewState.Busy;
        _user =
            await _userRepository.singInWithEmailAndPassword(email, password);
        notifyListeners();
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailPasswordControl(String email, String password) {
    var result = true;
    if (password.length < 6) {
      passwordErrorMessage = "Lütfen en az 6 karakter giriniz...";
      result = false;
    } else
      passwordErrorMessage = null;
    if (!email.contains("@")) {
      emailErrorMessage = "Lütfen geçerli bir email adresi giriniz...";
      result = false;
    } else
      emailErrorMessage = null;
    return result;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await _userRepository.updateUserName(userID, newUserName);
    if (result == true) {
      _user.userName = newUserName;
    }
    return result;
  }

  Future<String> uploadFile(
      String userID, String fileType, PickedFile profilePhoto) async {
    var downloadLink = await _userRepository.upDateProfilePhoto(
        userID, fileType, profilePhoto);
    return downloadLink;
  }

  /*Future<List<UserModel>> getAllUser() async {
    List allUsersList = await _userRepository.getAllUser();
    return allUsersList;
  }*/

  Stream<List<MessageModel>> getMessages(String currentUserID, String talkUserID) {
    return _userRepository.getMessages(currentUserID, talkUserID);
  }

  Future<List<TalkModel>> getAllConversation(String userID) async {
    return await _userRepository.getAllConversation(userID);
  }

  Future<List<UserModel>> getUserWithPagination(
      UserModel lastUser, int numberOfElementsOnThePage) async {
    return await _userRepository.getUserWithPagination(
        lastUser, numberOfElementsOnThePage);
  }
}
