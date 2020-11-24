import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sohbet_uygulamasi/services/storege_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, PickedFile uploadedFile) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profile_photo.png");
    var _file;
    _file = File(uploadedFile.path);
    var uploadTask = _storageReference.putFile(_file);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }
}
