import 'dart:async';

import 'package:flutter/material.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/locator/locator.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/repository/user_repository.dart';

enum ChatViewState {
  Idle,
  Loaded,
  Busy,
}

class ChatViewModel with ChangeNotifier {
  List<MessageModel> _allMessage;
  ChatViewState _state = ChatViewState.Idle;
  final UserModel currentUser;
  final UserModel talkUser;
  static final numberOfElementsOnThePage = 10;
  UserRepository _userRepository = locator<UserRepository>();
  MessageModel _lastMessage;
  MessageModel _firstMessage;
  bool _hasMore = true;
  bool _newMessagesListener = false;
  StreamSubscription _streamSubscription;

  bool get hasMoreLoading => _hasMore;

  List<MessageModel> get allMessageList => _allMessage;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  ChatViewModel({this.currentUser, this.talkUser}) {
    _allMessage = [];
    getMessageWithPagination(false);
  }

  Future<bool> saveMessage(MessageModel saveMessage, UserModel currentUser) async {
    return await _userRepository.saveMessage(saveMessage, currentUser);
  }

  Future<void> getMessageWithPagination(bool bringNewMessages) async {
    if (_allMessage.length > 0) {
      _lastMessage = _allMessage.last;
    }
    if (!bringNewMessages) state = ChatViewState.Busy;
    var bringMessage = await _userRepository.getMessageWithPagination(
        currentUser.userID,
        talkUser.userID,
        _lastMessage,
        numberOfElementsOnThePage);

    if (bringMessage.length < numberOfElementsOnThePage) {
      _hasMore = false;
    }

    _allMessage.addAll(bringMessage);
    if (_allMessage.length > 0) _firstMessage = _allMessage.first;
    state = ChatViewState.Loaded;
    if (_newMessagesListener == false) {
      _newMessagesListener = true;
      createNewMessageListener();
    }
  }

  bringGetMoreMessages() async {
    if (_hasMore == true) getMessageWithPagination(true);
    await Future.delayed(Duration(seconds: 2));
  }

  void createNewMessageListener() {
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID, talkUser.userID)
        .listen((data) {
      if (data.isNotEmpty) {
        if (data[0].date != null) {
          if (_firstMessage == null) {
            _allMessage.insert(0, data[0]);
          } else if (_firstMessage.date.millisecondsSinceEpoch !=
              data[0].date.millisecondsSinceEpoch)
            _allMessage.insert(0, data[0]);
        }
        state = ChatViewState.Loaded;
      }
    });
  }
}
