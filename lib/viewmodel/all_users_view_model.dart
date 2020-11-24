import 'package:flutter/material.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/repository/user_repository.dart';

import '../locator/locator.dart';

enum AllUserViewState {
  Idle,
  Loaded,
  Busy,
}

class AllUsersViewModel with ChangeNotifier {
  List<UserModel> _allUsers;
  UserModel _lastUser;
  AllUserViewState _state = AllUserViewState.Idle;
  static final numberOfElementsOnThePage = 8;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();

  List<UserModel> get allUsersList => _allUsers;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUsersViewModel() {
    _allUsers = [];
    _lastUser = null;
    getUserWithPagination(_lastUser, false);
  }

  getUserWithPagination(UserModel lastUser, bool bringComeNewUsers) async {
    if (_allUsers.length > 0) {
      _lastUser = _allUsers.last;
    }
    if (bringComeNewUsers == true) {
    } else {
      state = AllUserViewState.Busy;
    }
    var newList = await _userRepository.getUserWithPagination(
        _lastUser, numberOfElementsOnThePage);
    if (newList.length < numberOfElementsOnThePage) {
      _hasMore = false;
    }

    _allUsers.addAll(newList);
    state = AllUserViewState.Loaded;
  }

  Future<void> bringGetMoreUser() async {
    if (_hasMore == true) getUserWithPagination(_lastUser, true);
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _lastUser = null;
    _allUsers = [];
    getUserWithPagination(_lastUser, true);
  }
}
