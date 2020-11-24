import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohbet_uygulamasi/app/sing_in/sing_in_page.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/app/home_page.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SingInPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
