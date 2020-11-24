import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sohbet_uygulamasi/app/error_exception.dart';
import 'package:sohbet_uygulamasi/common_widget/platform_sensitive_alert_dialog.dart';
import 'package:sohbet_uygulamasi/common_widget/social_log_in_button.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';

enum FormType { Register, LogIn }

class EmailAndPasswordLoginPage extends StatefulWidget {
  @override
  _EmailAndPasswordLoginPageState createState() =>
      _EmailAndPasswordLoginPageState();
}

class _EmailAndPasswordLoginPageState extends State<EmailAndPasswordLoginPage> {
  String _email, _password;
  final _formKey = GlobalKey<FormState>();
  var _formType = FormType.LogIn;
  String _buttonText, _linkText;

  void _formSubmit() async {
    _formKey.currentState.save();
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_formType == FormType.LogIn) {
      try {
        UserModel _loginUser =
            await _userModel.singInWithEmailAndPassword(_email, _password);
        if (_loginUser != null)
          print("Oturum Açan User : ${_loginUser.userID}");
      } on FirebaseAuthException catch (error) {
        PlatformSensitiveAlertDialog(
          head: "Giriş Yapılırken HATA",
          content: Errors.show(error.code),
          mainButtonName: "Tamam",
        ).show(context);
      }
    } else {
      try {
            await _userModel.createUserWithEmailAndPassword(_email, _password);
      } on FirebaseAuthException catch (error) {
        PlatformSensitiveAlertDialog(
          head: "Kullanıcı oluşturmada HATA",
          content: Errors.show(error.code),
          mainButtonName: "Tamam",
        ).show(context);
      }
    }
  }

  void _change() {
    setState(
      () {
        _formType =
            _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız Yok Mu? Kayıt Ol"
        : "Giriş Yap";
    final _userModel = Provider.of<UserViewModel>(context);
    if (_userModel.user != null) {
      Future.delayed(
        Duration(milliseconds: 10),
        () {
          Navigator.of(context).popUntil(ModalRoute.withName("/"));
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş/Kayıt"),
        ),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          //initialValue: "ouzky@hotmail.com",
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.emailErrorMessage != null
                                ? _userModel.emailErrorMessage
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            labelText: "E-mail",
                            hintText: "E-mail giriniz...",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String inputEmail) {
                            _email = inputEmail;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          //initialValue: "4572536",
                          decoration: InputDecoration(
                            errorText: _userModel.passwordErrorMessage != null
                                ? _userModel.passwordErrorMessage
                                : null,
                            prefixIcon: Icon(Icons.vpn_key),
                            labelText: "Şifre",
                            hintText: "Şifre giriniz...",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String inputPassword) {
                            _password = inputPassword;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SocialLogInButton(
                          buttonText: _buttonText,
                          onPressed: () => _formSubmit(),
                          buttonColor: Theme.of(context).primaryColor,
                          radius: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          onPressed: () => _change(),
                          child: Text(
                            _linkText,
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
