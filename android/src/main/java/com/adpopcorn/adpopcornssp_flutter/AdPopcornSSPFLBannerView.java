package com.adpopcorn.adpopcornssp_flutter;

import android.app.Activity;
import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.igaworks.ssp.AdSize;
import com.igaworks.ssp.SSPErrorCode;
import com.igaworks.ssp.part.banner.AdPopcornSSPBannerAd;
import com.igaworks.ssp.part.banner.listener.IBannerEventCallbackListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class AdPopcornSSPFLBannerView implements PlatformView, IBannerEventCallbackListener {
    private AdPopcornSSPBannerAd bannerView;
    private MethodChannel channel;
    private String placementId;
    AdPopcornSSPFLBannerView(Activity activity, @NonNull Context context, int id, @Nullable Map<String, Object> creationParams, BinaryMessenger binaryMessenger) {
        String bannerSize = "320x50";
        if(creationParams != null)
        {
            placementId = (String)creationParams.get("placementId");
            bannerSize = (String)creationParams.get("bannerSize");
        }

        if(placementId == null)
            return;
        channel = new MethodChannel(binaryMessenger, "adpopcornssp/" + placementId);
        bannerView = new AdPopcornSSPBannerAd(activity);
        bannerView.setBannerEventCallbackListener(this);
        bannerView.setPlacementId(placementId);

        if(bannerSize.equals("320x50"))
            bannerView.setAdSize(AdSize.BANNER_320x50);
        else if(bannerSize.equals("300x250"))
            bannerView.setAdSize(AdSize.BANNER_300x250);
        else if(bannerSize.equals("320x100"))
            bannerView.setAdSize(AdSize.BANNER_320x100);
        else
            bannerView.setAdSize(AdSize.BANNER_ADAPTIVE_SIZE);
        bannerView.loadAd();
    }

    @NonNull
    @Override
    public View getView() {
        return bannerView;
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
    public void OnBannerAdReceiveSuccess() {
        if(channel != null){
            channel.invokeMethod("APSSPBannerViewLoadSuccess", argumentsMap("placementId", placementId));
        }
    }

    @Override
    public void OnBannerAdReceiveFailed(SSPErrorCode sspErrorCode) {
        if(channel != null) {
            channel.invokeMethod("APSSPBannerViewLoadFail", argumentsMap("placementId", placementId, "errorCode", sspErrorCode.getErrorCode()));
        }
    }

    @Override
    public void OnBannerAdClicked() {
        if(channel != null){
            channel.invokeMethod("APSSPBannerViewClicked", argumentsMap("placementId", placementId));
        }
    }

    private Map<String, Object> argumentsMap(Object... args) {
        Map<String, Object> arguments = new HashMap<>();
        for (int i = 0; i < args.length; i += 2) arguments.put(args[i].toString(), args[i + 1]);
        return arguments;
    }
}
