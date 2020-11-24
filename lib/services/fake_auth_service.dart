import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "4572536";

  @override
  Future<UserModel> currentUser() async {
    return await Future.value(
        UserModel(userID: userID, email: "faceuser@fake.com"));
  }

  @override
  Future<UserModel> singInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserModel(userID: userID, email: "faceuser@fake.com"));
  }

  @override
  Future<bool> singOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            UserModel(userID: "google_user_id_1", email: "faceuser@fake.com"));
  }

  @override
  Future<UserModel> singInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserModel(
            userID: "facebook_user_id_1", email: "faceuser@fake.com"));
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            UserModel(userID: "created_user_id_1", email: "faceuser@fake.com"));
  }

  @override
  Future<UserModel> singInWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            UserModel(userID: "singIn_user_id_1", email: "faceuser@fake.com"));
  }
}
