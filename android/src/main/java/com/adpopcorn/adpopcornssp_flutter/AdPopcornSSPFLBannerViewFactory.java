package com.adpopcorn.adpopcornssp_flutter;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class AdPopcornSSPFLBannerViewFactory extends PlatformViewFactory {
    private BinaryMessenger binaryMessenger;
    private Activity activity;

    AdPopcornSSPFLBannerViewFactory(Activity activity, BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        this.activity = activity;
        this.binaryMessenger = binaryMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new AdPopcornSSPFLBannerView(activity, context, id, creationParams, this.binaryMessenger);
    }
}
