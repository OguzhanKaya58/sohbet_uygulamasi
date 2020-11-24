import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/advertisement/advertisement.dart';
import 'package:sohbet_uygulamasi/app/my_custom_botton_navigation.dart';
import 'package:sohbet_uygulamasi/app/profile_page.dart';
import 'package:sohbet_uygulamasi/app/tab_items.dart';
import 'package:sohbet_uygulamasi/app/talks_page.dart';
import 'package:sohbet_uygulamasi/app/users_page.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/notification/notification_handler.dart';
import 'package:sohbet_uygulamasi/viewmodel/all_users_view_model.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final UserModel user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Users;
 // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
    TabItem.Talks: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: ChangeNotifierProvider(
        create: (context) => AllUsersViewModel(),
        child: UsersPage(),
      ),
      TabItem.Talks: TalksPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
          navigatorKeys: navigatorKeys,
          pageCreated: allPages(),
          currentTab: _currentTab,
          onSelectedTab: (selectedTab) {
            if (Advertisement.myBannerAd != null &&
                Advertisement.myBannerAd.id != null) {
              try {
                Advertisement.myBannerAd.dispose();
                Advertisement.myBannerAd = null;
              } catch (error) {
                print("Error : $error");
              }
            }
            if (selectedTab == _currentTab) {
              navigatorKeys[selectedTab]
                  .currentState
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _currentTab = selectedTab;
              });
            }
          }),
    );
  }
}
