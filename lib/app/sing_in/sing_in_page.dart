import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sohbet_uygulamasi/app/error_exception.dart';
import 'package:sohbet_uygulamasi/app/sing_in/email_password_login_singUp.dart';
import 'package:sohbet_uygulamasi/common_widget/platform_sensitive_alert_dialog.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';
import '../../common_widget/social_log_in_button.dart';

PlatformException myError;

class SingInPage extends StatefulWidget {
 /* Future<void> _guestLogin(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userModel.singInAnonymously();
  }*/

  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  void _googleSingIn(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    try{
      await _userModel.singInWithGoogle();
    } on PlatformException catch(error){
      myError = error;
      print("Error : $myError");
    }
  }

  void _facebookSingIn(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      await _userModel.singInWithFacebook();
    } on PlatformException catch (error) {
      myError = error;
    }
  }

  void _emailAndPasswordLogIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailAndPasswordLoginPage(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if(myError != null)
      PlatformSensitiveAlertDialog(
        head: "Kullanıcı oluşturmada HATA",
        content: Errors.show(myError.code),
        mainButtonName: "Tamam",
      ).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oturum Aç",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 18,
            ),
            SocialLogInButton(
              buttonText: "Google",
              buttonColor: Colors.black,
              textColor: Colors.white,
              buttonIcon: Image.asset("images/google-logo.png"),
              onPressed: () => _googleSingIn(context),
            ),
            SizedBox(height: 5,),
            SocialLogInButton(
              buttonColor: Color(0xFF334D92),
              buttonText: "Facebook",
              buttonIcon: Image.asset("images/facebook-logo.png"),
              onPressed: () => _facebookSingIn(context),
            ),
            SizedBox(height: 5,),
            SocialLogInButton(
              buttonText: "E-mail",
              buttonColor: Colors.red,
              buttonIcon: Icon(
                Icons.email,
                size: 32,
              ),
              onPressed: () => _emailAndPasswordLogIn(context),
            ),
           /* SocialLogInButton(
              buttonText: "Misafir",
              onPressed: () => _guestLogin(context),
              buttonColor: Colors.green,
              buttonIcon: Icon(
                Icons.supervised_user_circle,
                size: 32,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
