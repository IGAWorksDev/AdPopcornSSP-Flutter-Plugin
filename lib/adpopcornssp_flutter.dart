import 'dart:async';

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

typedef void RewardPlusCompleted(bool result, int resultCode, int reward);

typedef void ContentsAdOpenSuccess();

typedef void ContentsAdOpenFail();

typedef void ContentsAdClosed();

typedef void ContentsAdCompleted(int reward, String rewardKey);

typedef void RewardPlusSettingInfo(String connectedId, int dailyUserLimit, int dailyUserCount);

typedef void PopContentsAdOpenSuccess();

typedef void PopContentsAdOpenFail();

typedef void PopContentsAdClosed();

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
  
  static RewardPlusCompleted? rewardPlusCompletedListener;
  
  static ContentsAdOpenSuccess? contentsAdOpenSuccessListener;
  
  static ContentsAdOpenFail? contentsAdOpenFailListener;
    
  static ContentsAdClosed? contentsAdClosedListener;
  
  static ContentsAdCompleted? contentsAdCompletedListener;
  
  static RewardPlusSettingInfo? rewardPlusSettingInfoListener;
  
  static PopContentsAdOpenSuccess? popContentsAdOpenSuccessListener;
  
  static PopContentsAdOpenFail? popContentsAdOpenFailListener;
    
  static PopContentsAdClosed? popContentsAdClosedListener;
  
  static void init(String appKey) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    _channel.invokeMethod('init', <String, dynamic>{
      'appKey': appKey,
    });
  }
  
  static void setUserId(String userId) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    _channel.invokeMethod('setUserId', <String, dynamic>{
      'userId': userId,
    });
  }
  
  static void setLogLevel(String logLevel) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    _channel.invokeMethod('setLogLevel', <String, dynamic>{
      'logLevel': logLevel,
    });
  }
  
  static void setUIDIdentifier(int identityType, String identifier) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);

    String identityTypeString = 'email';
    if(identityType == 1)
        identityTypeString = 'phone';
        
    _channel.invokeMethod('setUIDIdentifier', <String, dynamic>{
      'identityType': identityTypeString,
      'identifier': identifier,
    });
  }
  
  static void tagForChildDirectedTreatment(bool tag) {
    //register callback method handler
    _channel.setMethodCallHandler(_handleMethod);
    
    String tagString = 'false';
    if(tag)
        tagString = 'true';
    _channel.invokeMethod('tagForChildDirectedTreatment', <String, dynamic>{
      'tag': tagString,
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
  
  static void openContents(String appKey, String placementId) {
    _channel.invokeMethod('openContents', <String, dynamic>{
      'appKey': appKey,
      'placementId': placementId,
    });
  }
  
  static void openRewardPlusSetting(String appKey) {
    _channel.invokeMethod('openRewardPlusSetting', <String, dynamic>{
      'appKey': appKey,
    });
  }
  
  static void getRewardPlusUserSetting(String appKey) {
    _channel.invokeMethod('getRewardPlusUserSetting', <String, dynamic>{
      'appKey': appKey,
    });
  }
  
  static void openPopContents(String appKey, String placementId) {
    _channel.invokeMethod('openPopContents', <String, dynamic>{
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
      if (method == 'APSSPInterstitialAdLoadSuccess') {
        final String placementId = arguments['placementId'];
        if (interstitialAdLoadSuccessListener != null) {
            interstitialAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdLoadFail') {
        final String placementId = arguments['placementId'];
        final int errorCode = arguments['errorCode'];
        if (interstitialAdLoadFailListener != null) {
            interstitialAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPInterstitialAdShowSuccess') {
        final String placementId = arguments['placementId'];
        if (interstitialAdShowSuccessListener != null) {
            interstitialAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdShowFail') {
        final String placementId = arguments['placementId'];
        if (interstitialAdShowFailListener != null) {
            interstitialAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdClicked') {
        final String placementId = arguments['placementId'];
        if (interstitialAdClickedListener != null) {
            interstitialAdClickedListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialAdClosed') {
        final String placementId = arguments['placementId'];
        if (interstitialAdClosedListener != null) {
            interstitialAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdLoadSuccess') {
        final String placementId = arguments['placementId'];
        if (interstitialVideoAdLoadSuccessListener != null) {
            interstitialVideoAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdLoadFail') {
        final String placementId = arguments['placementId'];
        final int errorCode = arguments['errorCode'];
        if (interstitialVideoAdLoadFailListener != null) {
            interstitialVideoAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPInterstitialVideoAdShowSuccess') {
        final String placementId = arguments['placementId'];
        if (interstitialVideoAdShowSuccessListener != null) {
            interstitialVideoAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdShowFail') {
        final String placementId = arguments['placementId'];
        if (interstitialVideoAdShowFailListener != null) {
            interstitialVideoAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPInterstitialVideoAdClosed') {
        final String placementId = arguments['placementId'];
        if (interstitialVideoAdClosedListener != null) {
            interstitialVideoAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdLoadSuccess') {
        final String placementId = arguments['placementId'];
        if (rewardVideoAdLoadSuccessListener != null) {
            rewardVideoAdLoadSuccessListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdLoadFail') {
        final String placementId = arguments['placementId'];
        final int errorCode = arguments['errorCode'];
        if (rewardVideoAdLoadFailListener != null) {
            rewardVideoAdLoadFailListener!(placementId, errorCode);
        }
      } else if (method == 'APSSPRewardVideoAdShowSuccess') {
        final String placementId = arguments['placementId'];
        if (rewardVideoAdShowSuccessListener != null) {
            rewardVideoAdShowSuccessListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdShowFail') {
        final String placementId = arguments['placementId'];
        if (rewardVideoAdShowFailListener != null) {
            rewardVideoAdShowFailListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdClosed') {
        final String placementId = arguments['placementId'];
        if (rewardVideoAdClosedListener != null) {
            rewardVideoAdClosedListener!(placementId);
        }
      } else if (method == 'APSSPRewardVideoAdPlayCompleted') {
        final String placementId = arguments['placementId'];
        final int adNetworkNo = arguments['adNetworkNo'];
        final bool completed = arguments['completed'];
        if (rewardVideoAdCompletedListener != null){
            rewardVideoAdCompletedListener!(placementId, adNetworkNo, completed);
        }
      } else if (method == 'APSSPRewardPlusCompleted') {
        final bool result = arguments['result'];
        final int resultCode = arguments['resultCode'];
        final int reward = arguments['reward'];
        if (rewardPlusCompletedListener != null){
            rewardPlusCompletedListener!(result, resultCode, reward);
        }
      }
      else if (method == 'ContentsAdOpenSuccess') {
        if (contentsAdOpenSuccessListener != null) {
            contentsAdOpenSuccessListener!();
        }
      } else if (method == 'ContentsAdOpenFail') {
        if (contentsAdOpenFailListener != null) {
            contentsAdOpenFailListener!();
        }
      } else if (method == 'ContentsAdClosed') {
        if (contentsAdClosedListener != null) {
            contentsAdClosedListener!();
        }
      } else if (method == 'ContentsAdCompleted') {
        final int reward = arguments['reward'];
        final String rewardKey = arguments['rewardKey'];
        if (contentsAdCompletedListener != null) {
            contentsAdCompletedListener!(reward, rewardKey);
        }
      } else if (method == 'APSSPRewardPlusSettingInfo') {
        final String connectedId = arguments['connectedId'];
        final int dailyUserLimit = arguments['dailyUserLimit'];
        final int dailyUserCount = arguments['dailyUserCount'];
        if (rewardPlusSettingInfoListener != null) {
              rewardPlusSettingInfoListener!(connectedId, dailyUserLimit, dailyUserCount);
        }
      } else if (method == 'PopContentsAdOpenSuccess') {
        if (popContentsAdOpenSuccessListener != null) {
              popContentsAdOpenSuccessListener!();
        }
      } else if (method == 'PopContentsAdOpenFail') {
        if (popContentsAdOpenFailListener != null) {
              popContentsAdOpenFailListener!();
        }
      } else if (method == 'PopContentsAdClosed') {
        if (popContentsAdClosedListener != null) {
              popContentsAdClosedListener!();
        }
      }
    }
    return Future<dynamic>.value(null);
  }
}
