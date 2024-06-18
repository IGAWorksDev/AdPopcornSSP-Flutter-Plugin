package com.adpopcorn.adpopcornssp_flutter;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.igaworks.ssp.AdPopcornSSP;
import com.igaworks.ssp.SSPErrorCode;
import com.igaworks.ssp.SdkInitListener;
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
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
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
    } else {
      result.notImplemented();
    }
  }

  private void callInit(@NonNull MethodCall call, @NonNull Result result)
  {
    AdPopcornSSP.init(context, new SdkInitListener() {
      @Override
      public void onInitializationFinished() {
        channel.invokeMethod("AdPopcornSSPSDKDidInitialize", argumentsMap());
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
    final String placementId = call.argument("placementId");
    AdPopcornSSPInterstitialAd interstitialAd;
    if(interstitialAdMap.containsKey(placementId))
    {
      interstitialAd = interstitialAdMap.get(placementId);
    }
    else
    {
      interstitialAd = new AdPopcornSSPInterstitialAd(context);
      interstitialAdMap.put(placementId, interstitialAd);
    }
    interstitialAd.setPlacementId(placementId);
    interstitialAd.setInterstitialEventCallbackListener(new IInterstitialEventCallbackListener() {
      @Override
      public void OnInterstitialLoaded() {
        channel.invokeMethod("APSSPInterstitialAdLoadSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialReceiveFailed(SSPErrorCode sspErrorCode) {
        channel.invokeMethod("APSSPInterstitialAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
      }

      @Override
      public void OnInterstitialOpened() {
        channel.invokeMethod("APSSPInterstitialAdShowSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialOpenFailed(SSPErrorCode sspErrorCode) {
        channel.invokeMethod("APSSPInterstitialAdShowFail", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialClosed(int i) {
        channel.invokeMethod("APSSPInterstitialAdClosed", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialClicked() {
        channel.invokeMethod("APSSPInterstitialAdClicked", argumentsMap("placementId", placementId));
      }
    });
    interstitialAd.loadAd();
  }

  private void callShowInterstitial(@NonNull MethodCall call, @NonNull Result result)
  {
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
    if(interstitialAd.isLoaded())
      interstitialAd.showAd();
    else
      channel.invokeMethod("APSSPInterstitialAdShowFail", argumentsMap("placementId", placementId));
  }

  private void callLoadInterstitialVideo(@NonNull MethodCall call, @NonNull Result result)
  {
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
        channel.invokeMethod("APSSPInterstitialVideoAdLoadSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialVideoAdLoadFailed(SSPErrorCode sspErrorCode) {
        channel.invokeMethod("APSSPInterstitialVideoAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
      }

      @Override
      public void OnInterstitialVideoAdOpened() {
        channel.invokeMethod("APSSPInterstitialVideoAdShowSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialVideoAdOpenFalied() {
        channel.invokeMethod("APSSPInterstitialVideoAdShowFail", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialVideoAdClosed() {
        channel.invokeMethod("APSSPInterstitialVideoAdClosed", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnInterstitialVideoAdClicked() {

      }
    });
    interstitialVideoAd.loadAd();
  }

  private void callShowInterstitialVideo(@NonNull MethodCall call, @NonNull Result result)
  {
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
    if(interstitialVideoAd.isReady())
      interstitialVideoAd.showAd();
    else
      channel.invokeMethod("APSSPInterstitialVideoAdShowFail", argumentsMap("placementId", placementId));
  }

  private void callLoadRewardVideo(@NonNull MethodCall call, @NonNull Result result)
  {
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
        channel.invokeMethod("APSSPRewardVideoAdLoadSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnRewardVideoAdLoadFailed(SSPErrorCode sspErrorCode) {
        channel.invokeMethod("APSSPRewardVideoAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
      }

      @Override
      public void OnRewardVideoAdOpened() {
        channel.invokeMethod("APSSPRewardVideoAdShowSuccess", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnRewardVideoAdOpenFalied() {
        channel.invokeMethod("APSSPRewardVideoAdShowFail", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnRewardVideoAdClosed() {
        channel.invokeMethod("APSSPRewardVideoAdClosed", argumentsMap("placementId", placementId));
      }

      @Override
      public void OnRewardVideoPlayCompleted(int adNetworkNo, boolean completed) {
        channel.invokeMethod("APSSPRewardVideoAdPlayCompleted", argumentsMap("placementId", placementId, "adNetworkNo", adNetworkNo, "completed", completed));
      }

      @Override
      public void OnRewardVideoAdClicked() {

      }
    });
    rewardVideoAd.loadAd();
  }

  private void callShowRewardVideo(@NonNull MethodCall call, @NonNull Result result)
  {
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
    if(rewardVideoAd.isReady())
      rewardVideoAd.showAd();
    else
      channel.invokeMethod("APSSPRewardVideoAdShowFail", argumentsMap("placementId", placementId));
  }

  private Map<String, Object> argumentsMap(Object... args) {
    Map<String, Object> arguments = new HashMap<>();
    for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
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
