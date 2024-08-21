package com.adpopcorn.adpopcornssp_flutter;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.igaworks.ssp.AdPopcornSSP;
import com.igaworks.ssp.SSPErrorCode;
import com.igaworks.ssp.SdkInitListener;
import com.igaworks.ssp.part.contents.AdPopcornSSPContentsAd;
import com.igaworks.ssp.part.contents.listener.IContentsAdEventCallbackListener;
import com.igaworks.ssp.part.interstitial.AdPopcornSSPInterstitialAd;
import com.igaworks.ssp.part.interstitial.listener.IInterstitialEventCallbackListener;
import com.igaworks.ssp.part.video.AdPopcornSSPInterstitialVideoAd;
import com.igaworks.ssp.part.video.AdPopcornSSPRewardVideoAd;
import com.igaworks.ssp.part.video.listener.IInterstitialVideoAdEventCallbackListener;
import com.igaworks.ssp.part.video.listener.IRewardVideoAdEventCallbackListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AdPopcornSSPPlugin */
public class AdPopcornSSPPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private FlutterPluginBinding flutterPluginBinding;
  private Map<String, AdPopcornSSPInterstitialAd> interstitialAdMap = new HashMap<>();
  private Map<String, AdPopcornSSPInterstitialVideoAd> interstitialVideoAdMap = new HashMap<>();
  private Map<String, AdPopcornSSPRewardVideoAd> rewardVideoAdMap = new HashMap<>();
  private Map<String, AdPopcornSSPContentsAd> contentsAdMap = new HashMap<>();
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    this.context = flutterPluginBinding.getApplicationContext();
    setup(this, flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding)
  {
    flutterPluginBinding.getPlatformViewRegistry()
            .registerViewFactory("AdPopcornSSPBannerView", new AdPopcornSSPFLBannerViewFactory(binding.getActivity(), flutterPluginBinding.getBinaryMessenger()));
    flutterPluginBinding.getPlatformViewRegistry()
            .registerViewFactory("AdPopcornSSPNativeView", new AdPopcornSSPFLNativeViewFactory(binding.getActivity(), flutterPluginBinding.getBinaryMessenger()));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  private static void setup(AdPopcornSSPPlugin plugin, BinaryMessenger binaryMessenger) {
    plugin.channel = new MethodChannel(binaryMessenger, "adpopcornssp");
    plugin.channel.setMethodCallHandler(plugin);
  }

  public AdPopcornSSPPlugin()
  {
    if(interstitialAdMap == null)
      interstitialAdMap = new HashMap<>();
    if(interstitialVideoAdMap == null)
      interstitialVideoAdMap = new HashMap<>();
    if(rewardVideoAdMap == null)
      rewardVideoAdMap = new HashMap<>();
    if(contentsAdMap == null)
      contentsAdMap = new HashMap<>();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try {
      if (call.method.equals("init")) {
        callInit(call, result);
      } else if (call.method.equals("setUserId")) {
        callUserId(call, result);
      } else if (call.method.equals("setLogEnable")) {
        callSetLogEnable(call, result);
      } else if (call.method.equals("loadInterstitial")) {
        callLoadInterstitial(call, result);
      } else if (call.method.equals("showInterstitial")) {
        callShowInterstitial(call, result);
      } else if (call.method.equals("loadInterstitialVideo")) {
        callLoadInterstitialVideo(call, result);
      } else if (call.method.equals("showInterstitialVideo")) {
        callShowInterstitialVideo(call, result);
      } else if (call.method.equals("loadRewardVideo")) {
        callLoadRewardVideo(call, result);
      } else if (call.method.equals("showRewardVideo")) {
        callShowRewardVideo(call, result);
      } else if (call.method.equals("openContents")) {
        callOpenContents(call, result);
      } else {
        result.notImplemented();
      }
    }catch (Exception e){}
  }

  private void callInit(@NonNull MethodCall call, @NonNull Result result)
  {
    AdPopcornSSP.init(context, new SdkInitListener() {
      @Override
      public void onInitializationFinished() {
        try {
          if (channel != null)
            channel.invokeMethod("AdPopcornSSPSDKDidInitialize", argumentsMap());
        }catch (Exception e){}
      }
    });
  }

  private void callUserId(@NonNull MethodCall call, @NonNull Result result)
  {
    final String userId = call.argument("userId");
    if (TextUtils.isEmpty(userId)) {
      result.error("no_user_id", "userId is null or empty", null);
      return;
    }
    AdPopcornSSP.setUserId(context, userId);
  }

  private void callSetLogEnable(@NonNull MethodCall call, @NonNull Result result)
  {
    final boolean enable = call.argument("enable");
    AdPopcornSSP.setLogEnable(enable);
  }

  private void callLoadInterstitial(@NonNull MethodCall call, @NonNull Result result)
  {
    try {
      final String placementId = call.argument("placementId");
      AdPopcornSSPInterstitialAd interstitialAd;
      if (interstitialAdMap.containsKey(placementId)) {
        interstitialAd = interstitialAdMap.get(placementId);
      } else {
        interstitialAd = new AdPopcornSSPInterstitialAd(context);
        interstitialAdMap.put(placementId, interstitialAd);
      }
      interstitialAd.setPlacementId(placementId);
      interstitialAd.setInterstitialEventCallbackListener(new IInterstitialEventCallbackListener() {
        @Override
        public void OnInterstitialLoaded() {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdLoadSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialReceiveFailed(SSPErrorCode sspErrorCode) {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
        }

        @Override
        public void OnInterstitialOpened() {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdShowSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialOpenFailed(SSPErrorCode sspErrorCode) {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdShowFail", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialClosed(int i) {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdClosed", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialClicked() {
          if (channel != null)
            channel.invokeMethod("APSSPInterstitialAdClicked", argumentsMap("placementId", placementId));
        }
      });
      interstitialAd.loadAd();
    }catch (Exception e){}
  }

  private void callShowInterstitial(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPInterstitialAd interstitialAd;
      if(interstitialAdMap.containsKey(placementId))
      {
        interstitialAd = interstitialAdMap.get(placementId);
      }
      else
      {
        interstitialAd = new AdPopcornSSPInterstitialAd(context);
      }
      if(interstitialAd.isLoaded()) {
        interstitialAd.showAd();
      }
      else {
        if(channel != null)
          channel.invokeMethod("APSSPInterstitialAdShowFail", argumentsMap("placementId", placementId));
      }
    }catch (Exception e){}
  }

  private void callLoadInterstitialVideo(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPInterstitialVideoAd interstitialVideoAd;
      if(interstitialVideoAdMap.containsKey(placementId))
      {
        interstitialVideoAd = interstitialVideoAdMap.get(placementId);
      }
      else
      {
        interstitialVideoAd = new AdPopcornSSPInterstitialVideoAd(context);
        interstitialVideoAdMap.put(placementId, interstitialVideoAd);
      }
      interstitialVideoAd.setPlacementId(placementId);
      interstitialVideoAd.setEventCallbackListener(new IInterstitialVideoAdEventCallbackListener() {
        @Override
        public void OnInterstitialVideoAdLoaded() {
          if(channel != null)
            channel.invokeMethod("APSSPInterstitialVideoAdLoadSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialVideoAdLoadFailed(SSPErrorCode sspErrorCode) {
          if(channel != null)
            channel.invokeMethod("APSSPInterstitialVideoAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
        }

        @Override
        public void OnInterstitialVideoAdOpened() {
          if(channel != null)
            channel.invokeMethod("APSSPInterstitialVideoAdShowSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialVideoAdOpenFalied() {
          if(channel != null)
            channel.invokeMethod("APSSPInterstitialVideoAdShowFail", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialVideoAdClosed() {
          if(channel != null)
            channel.invokeMethod("APSSPInterstitialVideoAdClosed", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnInterstitialVideoAdClicked() {

        }
      });
      interstitialVideoAd.loadAd();
    }catch (Exception e){}
  }

  private void callShowInterstitialVideo(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPInterstitialVideoAd interstitialVideoAd;
      if(interstitialVideoAdMap.containsKey(placementId))
      {
        interstitialVideoAd = interstitialVideoAdMap.get(placementId);
      }
      else
      {
        interstitialVideoAd = new AdPopcornSSPInterstitialVideoAd(context);
      }
      if(interstitialVideoAd.isReady()) {
        interstitialVideoAd.showAd();
      }
      else {
        if(channel != null)
          channel.invokeMethod("APSSPInterstitialVideoAdShowFail", argumentsMap("placementId", placementId));
      }
    }catch (Exception e){}
  }

  private void callLoadRewardVideo(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPRewardVideoAd rewardVideoAd;
      if(rewardVideoAdMap.containsKey(placementId))
      {
        rewardVideoAd = rewardVideoAdMap.get(placementId);
      }
      else
      {
        rewardVideoAd = new AdPopcornSSPRewardVideoAd(context);
        rewardVideoAdMap.put(placementId, rewardVideoAd);
      }
      rewardVideoAd.setPlacementId(placementId);
      rewardVideoAd.setRewardVideoAdEventCallbackListener(new IRewardVideoAdEventCallbackListener() {
        @Override
        public void OnRewardVideoAdLoaded() {
          if(channel != null)
            channel.invokeMethod("APSSPRewardVideoAdLoadSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnRewardVideoAdLoadFailed(SSPErrorCode sspErrorCode) {
          channel.invokeMethod("APSSPRewardVideoAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
        }

        @Override
        public void OnRewardVideoAdOpened() {
          if(channel != null)
            channel.invokeMethod("APSSPRewardVideoAdShowSuccess", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnRewardVideoAdOpenFalied() {
          if(channel != null)
            channel.invokeMethod("APSSPRewardVideoAdShowFail", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnRewardVideoAdClosed() {
          if(channel != null)
            channel.invokeMethod("APSSPRewardVideoAdClosed", argumentsMap("placementId", placementId));
        }

        @Override
        public void OnRewardVideoPlayCompleted(int adNetworkNo, boolean completed) {
          if(channel != null)
            channel.invokeMethod("APSSPRewardVideoAdPlayCompleted", argumentsMap("placementId", placementId, "adNetworkNo", adNetworkNo, "completed", completed));
        }

        @Override
        public void OnRewardVideoAdClicked() {

        }
      });
      rewardVideoAd.loadAd();
    }catch (Exception e){}
  }

  private void callShowRewardVideo(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPRewardVideoAd rewardVideoAd;
      if(rewardVideoAdMap.containsKey(placementId))
      {
        rewardVideoAd = rewardVideoAdMap.get(placementId);
      }
      else
      {
        rewardVideoAd = new AdPopcornSSPRewardVideoAd(context);
      }
      if(rewardVideoAd.isReady()) {
        rewardVideoAd.showAd();
      }
      else {
        if(channel != null)
          channel.invokeMethod("APSSPRewardVideoAdShowFail", argumentsMap("placementId", placementId));
      }
    }catch (Exception e){}
  }

  private void callOpenContents(@NonNull MethodCall call, @NonNull Result result)
  {
    try{
      final String placementId = call.argument("placementId");
      AdPopcornSSPContentsAd contentsAd;
      if(contentsAdMap.containsKey(placementId))
      {
        contentsAd = contentsAdMap.get(placementId);
      }
      else
      {
        contentsAd = new AdPopcornSSPContentsAd(context);
        contentsAdMap.put(placementId, contentsAd);
      }
      contentsAd.setPlacementId(placementId);
      contentsAd.setContentsAdEventCallbackListener(new IContentsAdEventCallbackListener() {
        @Override
        public void OnContentsAdOpened() {
          if(channel != null)
            channel.invokeMethod("ContentsAdOpenSuccess", argumentsMap());
        }

        @Override
        public void OnContentsAdOpenFailed(SSPErrorCode sspErrorCode) {
          if(channel != null)
            channel.invokeMethod("ContentsAdOpenFail", argumentsMap());
        }

        @Override
        public void OnContentsAdClosed() {
          if(channel != null)
            channel.invokeMethod("ContentsAdClosed", argumentsMap());
        }

        @Override
        public void OnContentsAdCompleted(long reward) {
          if(channel != null)
            channel.invokeMethod("ContentsAdCompleted", argumentsMap("reward", reward));
        }
      });
      contentsAd.openContents();
    }catch (Exception e){}
  }

  private Map<String, Object> argumentsMap(Object... args) {
    Map<String, Object> arguments = new HashMap<>();
    try{
      for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
    }catch (Exception e){}
    return arguments;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    context = null;
    if(channel != null) {
      channel.setMethodCallHandler(null);
      channel = null;
    }
  }
}
