import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

typedef void OnInitialized();

typedef void InterstitialAdLoadSuccess(String placementId);

typedef void InterstitialAdLoadFail(String placementId, int errorCode);

typedef void InterstitialAdShowSuccess(String placementId);

typedef void InterstitialAdShowFail(String placementId);

typedef void InterstitialAdClicked(String placementId);

typedef void InterstitialAdClosed(String placementId);

typedef void InterstitialVideoAdLoadSuccess(String placementId);

typedef void InterstitialVideoAdLoadFail(String placementId, int errorCode);

typedef void InterstitialVideoAdShowSuccess(String placementId);

typedef void InterstitialVideoAdShowFail(String placementId);

typedef void InterstitialVideoAdClosed(String placementId);

typedef void RewardVideoAdLoadSuccess(String placementId);

typedef void RewardVideoAdLoadFail(String placementId, int errorCode);

typedef void RewardVideoAdShowSuccess(String placementId);

typedef void RewardVideoAdShowFail(String placementId);

typedef void RewardVideoAdClosed(String placementId);

typedef void RewardVideoAdCompleted(String placementId, int adNetworkNo, bool completed);

class AdPopcornSSP {
  static const MethodChannel _channel = const MethodChannel('adpopcornssp');

  static OnInitialized? onInitializeListener;

  static InterstitialAdLoadSuccess? interstitialAdLoadSuccessListener;

  static InterstitialAdLoadFail? interstitialAdLoadFailListener;

  static InterstitialAdShowSuccess? interstitialAdShowSuccessListener;
  
  static InterstitialAdShowFail? interstitialAdShowFailListener;
  
  static InterstitialAdClicked? interstitialAdClickedListener;
  
  static InterstitialAdClosed? interstitialAdClosedListener;
  
  static InterstitialVideoAdLoadSuccess? interstitialVideoAdLoadSuccessListener;

  static InterstitialVideoAdLoadFail? interstitialVideoAdLoadFailListener;

  static InterstitialVideoAdShowSuccess? interstitialVideoAdShowSuccessListener;
  
  static InterstitialVideoAdShowFail? interstitialVideoAdShowFailListener;
  
  static InterstitialVideoAdClosed? interstitialVideoAdClosedListener;
  
  static RewardVideoAdLoadSuccess? rewardVideoAdLoadSuccessListener;

  static RewardVideoAdLoadFail? rewardVideoAdLoadFailListener;

  static RewardVideoAdShowSuccess? rewardVideoAdShowSuccessListener;
  
  static RewardVideoAdShowFail? rewardVideoAdShowFailListener;
  
  static RewardVideoAdClosed? rewardVideoAdClosedListener;

  static RewardVideoAdCompleted? rewardVideoAdCompletedListener;
  
  static void init(String appKey) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    _channel.invokeMethod('init', <String, dynamic>{
      'appKey': appKey,
    });
  }
  
  static void setLogLevel(String logLevel) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    _channel.invokeMethod('setLogLevel', <String, dynamic>{
      'logLevel': logLevel,
    });
  }
  
  static void loadInterstitial(String appKey, String placementId) {
    _channel.invokeMethod('loadInterstitial', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }
  
  static void showInterstitial(String appKey, String placementId) {
    _channel.invokeMethod('showInterstitial', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }
  
  static void loadInterstitialVideo(String appKey, String placementId) {
    _channel.invokeMethod('loadInterstitialVideo', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }
  
  static void showInterstitialVideo(String appKey, String placementId) {
    _channel.invokeMethod('showInterstitialVideo', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }

  static void loadRewardVideo(String appKey, String placementId) {
    _channel.invokeMethod('loadRewardVideo', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }
  
  static void showRewardVideo(String appKey, String placementId) {
    _channel.invokeMethod('showRewardVideo', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }

  static Future<dynamic> _handleMethod(MethodCall call) {
    print('adpopcornssp.dart _handleMethod: ${call.method}, ${call.arguments}');
    final Map<dynamic, dynamic> arguments = call.arguments;
    final String method = call.method;

    if (method == 'AdPopcornSSPSDKDidInitialize') {
      if (onInitializeListener != null) {
            onInitializeListener!();
      }
    } else {
      final String placementId = arguments['placementId'];
      if (method == 'APSSPInterstitialAdLoadSuccess') {
        if (interstitialAdLoadSuccessListener != null) {
            interstitialAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdLoadFail') {
        final int errorCode = arguments['errorCode'];
        if (interstitialAdLoadFailListener != null) {
            interstitialAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPInterstitialAdShowSuccess') {
        if (interstitialAdShowSuccessListener != null) {
            interstitialAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdShowFail') {
        if (interstitialAdShowFailListener != null) {
            interstitialAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdClicked') {
        if (interstitialAdClickedListener != null) {
            interstitialAdClickedListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdClosed') {
        if (interstitialAdClosedListener != null) {
            interstitialAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdLoadSuccess') {
        if (interstitialVideoAdLoadSuccessListener != null) {
            interstitialVideoAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdLoadFail') {
        final int errorCode = arguments['errorCode'];
        if (interstitialVideoAdLoadFailListener != null) {
            interstitialVideoAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPInterstitialVideoAdShowSuccess') {
        if (interstitialVideoAdShowSuccessListener != null) {
            interstitialVideoAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdShowFail') {
        if (interstitialVideoAdShowFailListener != null) {
            interstitialVideoAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdClosed') {
        if (interstitialVideoAdClosedListener != null) {
            interstitialVideoAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdLoadSuccess') {
        if (rewardVideoAdLoadSuccessListener != null) {
            rewardVideoAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdLoadFail') {
        final int errorCode = arguments['errorCode'];
        if (rewardVideoAdLoadFailListener != null) {
            rewardVideoAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPRewardVideoAdShowSuccess') {
        if (rewardVideoAdShowSuccessListener != null) {
            rewardVideoAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdShowFail') {
        if (rewardVideoAdShowFailListener != null) {
            rewardVideoAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdClosed') {
        if (rewardVideoAdClosedListener != null) {
            rewardVideoAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdPlayCompleted') {
        final int adNetworkNo = arguments['adNetworkNo'];
        final bool completed = arguments['completed'];
        if (rewardVideoAdCompletedListener != null){
            rewardVideoAdCompletedListener!(placementId, adNetworkNo, completed);
        }
      } else {
        throw new MissingPluginException("Method not implemented, $method");
      }
    }
    return Future<dynamic>.value(null);
  }
}
