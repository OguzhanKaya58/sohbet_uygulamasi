import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/advertisement/advertisement.dart';
import 'package:sohbet_uygulamasi/common_widget/platform_sensitive_alert_dialog.dart';
import 'package:sohbet_uygulamasi/common_widget/social_log_in_button.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controllerUserName;
  File _newImage;
  final ImagePicker _picker = ImagePicker();
  PickedFile _profilePhoto;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    //Advertisement.advertisementInitialize();
    Advertisement.myBannerAd = Advertisement.buildBannerAd();
    Advertisement.myBannerAd
      ..load()
      ..show(anchorOffset: 50);
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  /* Future<void> _takeAPhotoFromTheCamera() async {
    PickedFile _newImage =
        _profilePhoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _profilePhoto = _newImage;
    });
  }

  Future<void> _choosePhotoFromGallery() async {
    PickedFile _newImage =
        _profilePhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _profilePhoto = _newImage;
    });
  }*/
  _newPhotoAdd(ImageSource source) async {
    _profilePhoto = await _picker.getImage(source: source);
    //Navigator.of(context).pop();
    setState(() {
      if (_profilePhoto != null) {
        _newImage = File(_profilePhoto.path);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel = Provider.of<UserViewModel>(context,listen: false);
    _controllerUserName.text = _userModel.user.userName;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ("Profil"),
        ),
        actions: [
          FlatButton(
            onPressed: () => _permissionForSingOut(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _newPhotoAdd(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _newPhotoAdd(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withAlpha(40),
                    radius: 50,
                    backgroundImage: _newImage == null
                        ? NetworkImage(_userModel.user.profileUrl)
                        : FileImage(_newImage),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "E-mail", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  // initialValue: _userModel.user.userName,
                  decoration: InputDecoration(
                      labelText: "Kullanıcı Adı", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLogInButton(
                    buttonText: "Kaydet",
                    buttonColor: Colors.black12,
                    onPressed: () {
                      _userNameUpdate(context);
                      _profilePhotoUpdate(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _singOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.singOut();
    return result;
  }

  Future _permissionForSingOut(BuildContext context) async {
    final result = await PlatformSensitiveAlertDialog(
      head: "Çıkış Yap!",
      content: "Çıkmak istediğinizden emin misiniz?",
      mainButtonName: "Evet",
      cancelButtonName: "Vazgeç",
    ).show(context);
    if (result == true) {
      _singOut(context);
    }
  }

  void _userNameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);
      if (updateResult == true) {
        PlatformSensitiveAlertDialog(
                head: "Başarılı",
                content: "İsim değiştirildi...",
                mainButtonName: "Tamam")
            .show(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformSensitiveAlertDialog(
                head: "Hata",
                content:
                    "İsim zaten kullanımda lütfen farklı bir isim giriniz!!!",
                mainButtonName: "Tamam")
            .show(context);
      }
    }
  }

  Future<void> _profilePhotoUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_profilePhoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profile_photo", _profilePhoto);
      if (url != null) {
        PlatformSensitiveAlertDialog(
                head: "Başarılı",
                content: "Profil resminiz değiştirildi...",
                mainButtonName: "Tamam")
            .show(context);
      }
    }
  }
}
