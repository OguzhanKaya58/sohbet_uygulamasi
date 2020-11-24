import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/services/auth_base.dart';

class FirebaseAutoService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> currentUser() async {
    User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  UserModel _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return UserModel(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<UserModel> singInAnonymously() async {
    UserCredential sonuc = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<bool> singOut() async {
    final _googleSingIn = GoogleSignIn();
    await _googleSingIn.signOut();
    final _facebookSingIn = FacebookLogin();
    await _facebookSingIn.logOut();
    await _firebaseAuth.signOut();
    return true;
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    GoogleSignIn _googleSingIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSingIn.signIn();
    //String _googleUserEmail = _googleUser.email;
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = result.user;
        //result.user.updateEmail(_googleUserEmail);
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> singInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceResult =
        await _facebookLogin.logIn(['public_profile', 'email']);
    switch (_faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_faceResult.accessToken != null) {
          UserCredential _firebaseResult = await _firebaseAuth
              .signInWithCredential(FacebookAuthProvider.credential(
                  _faceResult.accessToken.token));
          User _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print("Hata çıktı : ${_faceResult.errorMessage}");
        break;
    }
    return null;
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user);
  }

  @override
  Future<UserModel> singInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user);
  }
}
