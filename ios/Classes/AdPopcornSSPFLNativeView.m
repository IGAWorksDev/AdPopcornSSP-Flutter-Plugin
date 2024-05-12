//
//  AdPopcornSSPFLNativeView.m
//  adpopcornssp
//
//  Created by 김민석 on 5/7/24.
//

#import "AdPopcornSSPFLNativeView.h"

@implementation AdPopcornSSPFLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
    
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[AdPopcornSSPFLNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

/// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation AdPopcornSSPFLNativeView {
    AdPopcornSSPReactNativeAd *_nativeView;
    FlutterMethodChannel *_channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      NSString* appKey = (NSString*)args[@"appKey"];
      NSString* placementId = (NSString*)args[@"placementId"];
      _nativeView = [[AdPopcornSSPReactNativeAd alloc] initWithFrame:frame appKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
      _channel = [FlutterMethodChannel
                  methodChannelWithName:[@"adpopcornssp/" stringByAppendingString:placementId]
                        binaryMessenger:messenger];
      _nativeView.delegate = self;
      [_nativeView loadRequest];
  }
  return self;
}

- (UIView*)view {
  return _nativeView;
}

#pragma mark APSSPReactNativeAdDelegate
/*!
 @abstract
 react native 광고 로드에 성공한 경우 호출된다.
 */
- (void)APSSPReactNativeAdLoadSuccess:(AdPopcornSSPReactNativeAd *)reactNativeAd adSize:(CGSize)adSize networkNo:(NSInteger)networkNo
{
    NSLog(@"AdPopcornSSPFLNativeView APSSPNativeAdLoadSuccess");
    [_channel invokeMethod:@"APSSPNativeAdLoadSuccess"
                     arguments:@{@"placementId":reactNativeAd.placementId != nil ? reactNativeAd.placementId : @""}];
}

/*!
 @abstract
 react native 광고 로드에 실패한 경우 호출된다.
 */
- (void)APSSPReactNativeAdLoadFail:(AdPopcornSSPReactNativeAd *)reactNativeAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPFLNativeView APSSPNativeAdLoadFail : %@", error);
    [_channel invokeMethod:@"APSSPNativeAdLoadFail"
                     arguments:@{@"placementId":reactNativeAd.placementId != nil ? reactNativeAd.placementId : @"",
                                 @"errorCode":@(error.code)}];
}

/*!
 @abstract
 react native 광고가 노출 될 때 호출된다.
 */
- (void)APSSPReactNativeAdImpression:(AdPopcornSSPReactNativeAd *)reactNativeAd
{
    NSLog(@"AdPopcornSSPFLNativeView APSSPNativeAdImpression");
    [_channel invokeMethod:@"APSSPNativeAdImpression"
                     arguments:@{@"placementId":reactNativeAd.placementId != nil ? reactNativeAd.placementId : @""}];
}
/*!
 @abstract
 react native 광고가 클릭 시 호출 된다.
 */
- (void)APSSPReactNativeAdClicked:(AdPopcornSSPReactNativeAd *)reactNativeAd
{
    NSLog(@"AdPopcornSSPFLNativeView APSSPNativeAdClicked");
    [_channel invokeMethod:@"APSSPNativeAdClicked"
                     arguments:@{@"placementId":reactNativeAd.placementId != nil ? reactNativeAd.placementId : @""}];
}
/*!
 @abstract
 react native 광고 사이즈 변경 시 호출(NAM)
 */
- (void)APSSPReactNativeAdSizeChanged:(AdPopcornSSPReactNativeAd *)reactNativeAd adSize:(CGSize)adSize
{
}
@end
