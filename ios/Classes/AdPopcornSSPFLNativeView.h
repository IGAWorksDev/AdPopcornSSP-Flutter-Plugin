//
//  AdPopcornSSPFLNativeView.h
//  Pods
//
//  Created by 김민석 on 5/7/24.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <AdPopcornSSP/AdPopcornSSPSDK.h>

@interface AdPopcornSSPFLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface AdPopcornSSPFLNativeView : NSObject <FlutterPlatformView,
    APSSPReactNativeAdDelegate>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (UIView *)view;
@end
