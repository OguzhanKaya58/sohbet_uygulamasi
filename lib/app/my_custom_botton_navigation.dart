import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sohbet_uygulamasi/app/tab_items.dart';

class MyCustomBottomNavigation extends StatefulWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreated;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigation({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.pageCreated,
    @required this.navigatorKeys,
  }) : super(key: key);

  @override
  _MyCustomBottomNavigationState createState() =>
      _MyCustomBottomNavigationState();
}

class _MyCustomBottomNavigationState extends State<MyCustomBottomNavigation> {
  BannerAd myBannerAd;

  @override
  void initState() {
    super.initState();
    /*Advertisement.advertisementInitialize();
    myBannerAd = Advertisement.buildBannerAd();
    myBannerAd
      ..load()
      ..show(anchorOffset: 0);*/
  }

  @override
  void dispose() {
    // if (myBannerAd != null) myBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Banner Reklam Kullanımı

    // myBannerAd.load();
    // myBannerAd.show(anchorOffset: 0);

    /*  myBannerAd
      ..load()
      ..show(anchorOffset: 0); */
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                items: [
                  _navItemCreate(TabItem.Users),
                  _navItemCreate(TabItem.Talks),
                  _navItemCreate(TabItem.Profile),
                ],
                onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
              ),
              tabBuilder: (context, index) {
                final showItem = TabItem.values[index];
                return CupertinoTabView(
                  navigatorKey: widget.navigatorKeys[showItem],
                  builder: (context) {
                    return widget.pageCreated[showItem];
                  },
                );
              }),
        ),
        /* SizedBox(
          height: 50,
        ),*/
      ],
    );
  }

  BottomNavigationBarItem _navItemCreate(TabItem tabItem) {
    final createdTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(createdTab.icon),
        //title: Text(createdTab.title),
        label: createdTab.title);
  }
}
