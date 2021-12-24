import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initalization;
  AdState(this.initalization);
  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-4198859463987808/1536454435'
      : 'ca-app-pub-4198859463987808/4266559555';
//
  Function(Ad) onLoadedAd;
  // for ios production: ca-app-pub-6541784016286605/5255414035
  // for android production:  ca-app-pub-6541784016286605/6464569833

  BannerAd createBannerAd(bannerAdUnitID) {
    BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdUnitID,
        listener: BannerAdListener(onAdLoaded: (Ad ad) {
          print('add loaded');
          if (onLoadedAd != null) onLoadedAd(ad);
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdOpened: (Ad ad) {
          print("Ad opened");
        }, onAdClosed: (Ad ad) {
          print("Ad closed");
        }),
        request: AdRequest());
    return ad;
  }

  BannerAdListener get adListner => _adListener;
  BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (Ad ad) {
      print("ad Loaded");
    },
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
    },
    onAdOpened: (Ad ad) {
      print("Ad opened");
    },
    onAdClosed: (Ad ad) {
      print("Ad closed");
    },
  );
}
