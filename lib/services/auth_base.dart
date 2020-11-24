import 'package:sohbet_uygulamasi/model/user.dart';

abstract class AuthBase {
  Future<UserModel> currentUser();

  Future<UserModel> singInAnonymously();

  Future<bool> singOut();

  Future<UserModel> singInWithGoogle();

  Future<UserModel> singInWithFacebook();

  Future<UserModel> singInWithEmailAndPassword(String email, String password);

  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password);
}
