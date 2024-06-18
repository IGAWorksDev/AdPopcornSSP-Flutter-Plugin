package com.adpopcorn.adpopcornssp_flutter;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.igaworks.ssp.SSPErrorCode;
import com.igaworks.ssp.part.custom.AdPopcornSSPReactNativeAd;
import com.igaworks.ssp.part.custom.listener.IReactNativeAdEventCallbackListener;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import java.util.HashMap;
import java.util.Map;

public class AdPopcornSSPFLNativeView implements PlatformView, IReactNativeAdEventCallbackListener {
    private AdPopcornSSPReactNativeAd nativeView;
    private MethodChannel channel;
    private String placementId;
    private int width = 0;
    private int height = 0;
    AdPopcornSSPFLNativeView(Activity activity, @NonNull Context context, int id, @Nullable Map<String, Object> creationParams, BinaryMessenger binaryMessenger) {
        if(creationParams != null)
        {
            placementId = (String)creationParams.get("placementId");
            if(creationParams.containsKey("width"))
                width = (int)creationParams.get("width");
            if(creationParams.containsKey("height"))
                height = (int)creationParams.get("height");
        }
        if(placementId == null)
            return;

        channel = new MethodChannel(binaryMessenger, "adpopcornssp/" + placementId);
        nativeView = new AdPopcornSSPReactNativeAd(activity);
        if(width > 0)
            nativeView.setReactNativeWidth(width);
        if(height > 0)
            nativeView.setReactNativeHeight(height);
        nativeView.setReactNativeAdEventCallbackListener(this);
        nativeView.setPlacementId(placementId);
        nativeView.loadAd();
    }

    @NonNull
    @Override
    public View getView() {
        return nativeView;
    }

    @Override
    public void dispose() {
        if(channel != null)
        {
            channel.setMethodCallHandler(null);
            channel = null;
        }
    }

    @Override
    public void onReactNativeAdLoadSuccess(int adNetworkNo, int width, int height) {
        if(channel != null){
            channel.invokeMethod("APSSPNativeAdLoadSuccess", argumentsMap("placementId", placementId));
        }
    }

    @Override
    public void onReactNativeAdLoadFailed(SSPErrorCode sspErrorCode) {
        if(channel != null) {
            channel.invokeMethod("APSSPNativeAdLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
        }
    }

    @Override
    public void onImpression() {
        if(channel != null){
            channel.invokeMethod("APSSPNativeAdImpression", argumentsMap("placementId", placementId));
        }
    }

    @Override
    public void onClicked() {
        if(channel != null){
            channel.invokeMethod("APSSPNativeAdClicked", argumentsMap("placementId", placementId));
        }
    }

    private Map<String, Object> argumentsMap(Object... args) {
        Map<String, Object> arguments = new HashMap<>();
        for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
        return arguments;
    }
}
