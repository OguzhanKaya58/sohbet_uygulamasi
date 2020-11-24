import 'package:flutter/material.dart';

enum TabItem {
  Users,
  Talks,
  Profile,
}

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData("Kullanıcılar", Icons.supervised_user_circle),
    TabItem.Talks: TabItemData("Sohbet", Icons.chat),
    TabItem.Profile: TabItemData("Profil", Icons.person),
  };
}
