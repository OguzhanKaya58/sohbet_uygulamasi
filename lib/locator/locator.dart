import 'package:get_it/get_it.dart';
import 'package:sohbet_uygulamasi/repository/user_repository.dart';
import 'package:sohbet_uygulamasi/services/fake_auth_service.dart';
import 'package:sohbet_uygulamasi/services/firebase_auth_service.dart';
import 'package:sohbet_uygulamasi/services/firebase_storage_service.dart';
import 'package:sohbet_uygulamasi/services/firestore_db_servive.dart';
import 'package:sohbet_uygulamasi/services/sending_notification_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAutoService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => SendingNotificationService());
}
