import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sohbet_uygulamasi/app/talk_page.dart';
import 'package:sohbet_uygulamasi/viewmodel/all_users_view_model.dart';
import 'package:sohbet_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    //final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ("Kullanıcılar"),
        ),
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.allUsersList.length == 1) {
                    return _noUserUi();
                  } else if (model.hasMoreLoading == true &&
                      index == model.allUsersList.length) {
                    return _loadingNewUsersForIndicator();
                  } else {
                    return _UserList(index);
                  }
                },
                itemCount: model.hasMoreLoading == true
                    ? model.allUsersList.length + 1
                    : model.allUsersList.length,
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  Widget _noUserUi() {
    final _userModel = Provider.of<AllUsersViewModel>(context);
    return RefreshIndicator(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                  size: 120,
                ),
                Text(
                  "Kayıtlı kullanıcı yok...",
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
      onRefresh: _userModel.refresh,
    );
  }

  // ignore: non_constant_identifier_names, missing_return
  Widget _UserList(int index) {
    final UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: false);
    final AllUsersViewModel _allUserModel =
        Provider.of<AllUsersViewModel>(context, listen: false);
    var _nowUser = _allUserModel.allUsersList[index];
    if (_nowUser.userID == _userModel.user.userID) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => ChatViewModel(
                  currentUser: _userModel.user, talkUser: _nowUser),
              child: TalkPage(),
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(
          _nowUser.userName,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          _nowUser.email,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withAlpha(40),
          radius: 25,
          backgroundImage: NetworkImage(_nowUser.profileUrl),
        ),
        trailing: Icon(
          Icons.border_color,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }

  _loadingNewUsersForIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> bringGetMoreUser() async {
    if (_isLoading == false) {
      _isLoading = true;
      final AllUsersViewModel _allUserModel =
          Provider.of<AllUsersViewModel>(context, listen: false);
      await _allUserModel.bringGetMoreUser();
      _isLoading = false;
    }
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringGetMoreUser();
    }
  }
}
