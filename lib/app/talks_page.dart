import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/advertisement/advertisement.dart';
import 'package:sohbet_uygulamasi/app/talk_page.dart';
import 'package:sohbet_uygulamasi/model/talk.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';
import 'package:firebase_admob/firebase_admob.dart';

class TalksPage extends StatefulWidget {
  @override
  _TalksPageState createState() => _TalksPageState();
}

class _TalksPageState extends State<TalksPage> {
  @override
  void initState() {
    super.initState();
    // Ödüllü Reklam Kullanımı
    /* if (Advertisement.amount % 5 == 0) {
      loadAdvertisement();
      RewardedVideoAd.instance.listener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        if (event == RewardedVideoAdEvent.rewarded) {
          print("**********Ödüllü Reklam********** Ödül Ver");
          loadAdvertisement();
        } else if (event == RewardedVideoAdEvent.loaded) {
          print(
              "**********Ödüllü Reklam********** Reklam yüklendi ve gösterilecek");
          RewardedVideoAd.instance.show();
        } else if (event == RewardedVideoAdEvent.closed) {
          print("**********Ödüllü Reklam********** Reklam Kapatıldı");
        } else if (event == RewardedVideoAdEvent.failedToLoad) {
          print("**********Ödüllü Reklam********** Reklam Yok");
          loadAdvertisement();
        } else if (event == RewardedVideoAdEvent.completed) {
          print("**********Ödüllü Reklam********** Tamamlandı");
        }
      };
    }*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadAdvertisement() {
    RewardedVideoAd.instance.load(
        adUnitId: Advertisement.prizeAdvertisementTest,
        targetingInfo: Advertisement.targetingInfo);
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: FutureBuilder<List<TalkModel>>(
          builder: (context, talkList) {
            if (!talkList.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var allTalks = talkList.data;
              if (allTalks.length > 0) {
                return RefreshIndicator(
                  onRefresh: _talkListRefresh,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var nowTalk = allTalks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => ChatViewModel(
                                    currentUser: _userModel.user,
                                    talkUser: UserModel.idPictureAndUserName(
                                        userID: nowTalk.whoAreYouTalking,
                                        profileUrl: nowTalk.talkUserProfileUrl,
                                        userName: nowTalk.talkUser,
                                        email: nowTalk.email)),
                                child: TalkPage(),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            nowTalk.talkUser,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            nowTalk.lastMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.withAlpha(40),
                            radius: 25,
                            backgroundImage:
                                NetworkImage(nowTalk.talkUserProfileUrl),
                          ),
                          trailing: Text(
                            nowTalk.timeDifference,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    },
                    itemCount: allTalks.length,
                  ),
                );
              } else {
                return RefreshIndicator(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message,
                              color: Colors.white,
                              size: 120,
                            ),
                            Text(
                              "Henüz konuşma yapılmamış...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                  onRefresh: _talkListRefresh,
                );
              }
            }
          },
          future: _userModel.getAllConversation(_userModel.user.userID),
        ),
      ),
    );
  }

  /* void _bringTalks() async {
    final _userModel = Provider.of<UserViewModel>(context);
    var talks = await FirebaseFirestore.instance
        .collection("talks")
        .where("speaker", isEqualTo: _userModel.user.userID)
        .orderBy("date", descending: true)
        .get();
    for (var talk in talks.docs) {
      print("Konuşma : ${talk.data()}");
    }
  }*/

  Future<Null> _talkListRefresh() async {
    setState(() {});
    Future.delayed(Duration(seconds: 1));
    return null;
  }
}
