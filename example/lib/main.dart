import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:adpopcornssp_flutter/adpopcornssp_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel androidBannerChannel = const MethodChannel('adpopcornssp/BANNER_320x50');
  static const MethodChannel iosBannerChannel = const MethodChannel('adpopcornssp/iOS_BANNER_320x50');

  static const MethodChannel androidNativeChannel = const MethodChannel('adpopcornssp/NATIVE_TEMPLATE');
  static const MethodChannel iosNativeChannel = const MethodChannel('adpopcornssp/iOS_NATIVE_TEMPLATE');

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      AdPopcornSSP.init('663451319');
      AdPopcornSSP.setUserId('TEST_ANDROID');
      
      // 전면 연동
      AdPopcornSSP.loadInterstitial('663451319', 'INTERSTITIAL');
      AdPopcornSSP.interstitialAdLoadSuccessListener = (placementId) {
        // AdPopcornSSP.showInterstitial('663451319', placementId);
      };

      // 전면 비디오 연동
      AdPopcornSSP.loadInterstitialVideo('663451319', 'VIDEO');
      AdPopcornSSP.interstitialVideoAdLoadSuccessListener = (placementId) {
         //AdPopcornSSP.showInterstitialVideo('663451319', placementId);
      };

      // 리워드 비디오 연동
      AdPopcornSSP.loadRewardVideo('663451319', 'REWARD_VIDEO');
      AdPopcornSSP.rewardVideoAdLoadSuccessListener = (placementId) {
         //AdPopcornSSP.showRewardVideo('663451319', placementId);
      };
      
      // 콘텐츠 광고 연동(오늘의 날씨)
      /*AdPopcornSSP.openContents('800296516', 'TEST_WEATHER');
      AdPopcornSSP.contentsAdOpenSuccessListener = () {
        print('main.dart contentsAdOpenSuccessListener');
      };
      AdPopcornSSP.contentsAdClosedListener = () {
        print('main.dart contentsAdClosedListener');
      };
      AdPopcornSSP.contentsAdCompletedListener = (reward, rewardKey) {
          print('main.dart contentsAdCompletedListener : ${rewardKey}');
      };*/

      // 배너, 네이티브 이벤트 채널 연동
      androidBannerChannel.setMethodCallHandler(_eventHandleMethod);
      androidNativeChannel.setMethodCallHandler(_eventHandleMethod);
    } else if (Platform.isIOS) {
      AdPopcornSSP.init('397261446');
      AdPopcornSSP.setUserId('TEST_IOS');
      
      // 전면 연동
      AdPopcornSSP.loadInterstitial('397261446', 'iOS_INTERSTITIAL');
      AdPopcornSSP.interstitialAdLoadSuccessListener = (placementId) {
        AdPopcornSSP.showInterstitial('397261446', placementId);
      };

      // 전면 비디오 연동
      AdPopcornSSP.loadInterstitialVideo('397261446', 'iOS_VIDEO');
      AdPopcornSSP.interstitialVideoAdLoadSuccessListener = (placementId) {
        //AdPopcornSSP.showInterstitialVideo('397261446', placementId);
      };

      // 리워드 비디오 연동
      AdPopcornSSP.loadRewardVideo('397261446', 'iOS_REWARD_VIDEO');
      AdPopcornSSP.rewardVideoAdLoadSuccessListener = (placementId) {
        //AdPopcornSSP.showRewardVideo('397261446', placementId);
      };
      
      AdPopcornSSP.openContents('800296516', 'TEST_WEATHER');
      AdPopcornSSP.contentsAdOpenSuccessListener = () { };
      AdPopcornSSP.contentsAdClosedListener = () { };
      AdPopcornSSP.contentsAdCompletedListener = (reward, rewardKey) {
          print('main.dart contentsAdCompletedListener : ${rewardKey}');
      };
      
      // 배너, 네이티브 이벤트 채널 연동
      iosBannerChannel.setMethodCallHandler(_eventHandleMethod);
      iosNativeChannel.setMethodCallHandler(_eventHandleMethod);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _body(),
      ),
    );
  }
  
  Widget _body() {
    return ListView(
      children: _listItem(),
    );
  }
  
  List<Widget> _listItem() {
    List<Widget> widgets = [];
    widgets.add(_setBannerView());
    widgets.add(_setNativeView());
    return widgets;
  }
  
  Widget _setBannerView() {
    const String viewType = 'AdPopcornSSPBannerView';
    if (Platform.isAndroid) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'appKey':'663451319', 'placementId':'BANNER_320x50', 'bannerSize':'320x50'};
      return Container(
        width: double.maxFinite,
        height:50,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else if (Platform.isIOS) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'appKey':'397261446', 'placementId':'iOS_BANNER_320x50', 'bannerSize':'320x50'};
      return Container(
        width: double.maxFinite,
        height:50,
        child: UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else{
      return Container(
        width: double.maxFinite,
        height: 1
      );
    }
  }
  Widget _setNativeView() {
    const String viewType = 'AdPopcornSSPNativeView';
    if (Platform.isAndroid) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'appKey':'663451319', 'placementId':'NATIVE_TEMPLATE'};
      return Container(
        width: double.maxFinite,
        height:200,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else if (Platform.isIOS) {
      final Map<String, dynamic> creationParams = <String, dynamic>
      {'appKey':'397261446', 'placementId':'iOS_NATIVE_TEMPLATE'};
      return Container(
        width: double.maxFinite,
        height:280,
        child: UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    else{
      return Container(
          width: double.maxFinite,
          height: 1
      );
    }
  }
  
    static Future<dynamic> _eventHandleMethod(MethodCall call) {
    print('_eventHandleMethod: ${call.method}, ${call.arguments}');
    final Map<dynamic, dynamic> arguments = call.arguments;
    final String method = call.method;

    final String placementId = arguments['placementId'];
      if (method == 'APSSPBannerViewLoadSuccess') {
        print('main.dart APSSPBannerViewLoadSuccess');
      } else if (method == 'APSSPBannerViewLoadFail') {
        final int errorCode = arguments['errorCode'];
        print('main.dart APSSPBannerViewLoadFail');
      } else if (method == 'APSSPBannerViewClicked') {
        print('main.dart APSSPBannerViewClicked');
      } else if (method == 'APSSPNativeAdLoadSuccess') {
        print('main.dart APSSPNativeAdLoadSuccess');
      } else if (method == 'APSSPNativeAdLoadFail') {
        final int errorCode = arguments['errorCode'];
        print('main.dart APSSPNativeAdLoadFail');
      } else if (method == 'APSSPNativeAdImpression') {
        print('main.dart APSSPNativeAdImpression');
      } else if (method == 'APSSPNativeAdClicked') {
        print('main.dart APSSPNativeAdClicked');
      }
    return Future<dynamic>.value(null);
  }
}
