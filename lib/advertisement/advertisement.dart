import 'package:firebase_admob/firebase_admob.dart';

class Advertisement {
  static final String appIDLive = "ca-app-pub-2263458390854721~7677538256";
  static final String appIDTest = FirebaseAdMob.testAppId;
  static final String bnr1LiveID = "ca-app-pub-2263458390854721/1744369500";
  static int amount = 0;
  static final String prizeAdvertisementTest = RewardedVideoAd.testAdUnitId;
  static final String prizeAdvertisementLive = "ca-app-pub-2263458390854721/2561777090";

  static advertisementInitialize() {
    FirebaseAdMob.instance.initialize(appId: appIDTest);
  }

  static BannerAd myBannerAd;

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutter', 'chat apps'],
    contentUrl: 'https://www.instagram.com/ouzky58/?hl=tr',
    childDirected: false,
    testDevices: <String>[],
  );

  static BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          print("Banner Yüklendi");
        }
      },
    );
  }

  static InterstitialAd buildInterstitial() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          print("Banner Yüklendi");
        }
      },
    );
  }
}
