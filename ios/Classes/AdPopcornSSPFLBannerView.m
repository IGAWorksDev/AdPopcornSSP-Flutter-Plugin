//
//  AdPopcornSSPFLBannerView.m
//  flutter_adpopcornssp
//
//  Created by 김민석 on 5/7/24.
//

#import "AdPopcornSSPFLBannerView.h"

@implementation AdPopcornSSPFLBannerViewFactory {
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
  return [[AdPopcornSSPFLBannerView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

/// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation AdPopcornSSPFLBannerView {
    AdPopcornSSPBannerView *_bannerView;
    FlutterMethodChannel *_channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      NSString* appKey = (NSString*)args[@"appKey"];
      NSString* placementId = (NSString*)args[@"placementId"];
      NSString* bannerSize = (NSString*)args[@"bannerSize"];
      
      if([bannerSize isEqualToString:@"320x50"]){
          _bannerView = [[AdPopcornSSPBannerView alloc] initWithBannerViewSize:SSPBannerViewSize320x50 origin:frame.origin appKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
      }
      else if([bannerSize isEqualToString:@"300x250"]){
          _bannerView = [[AdPopcornSSPBannerView alloc] initWithBannerViewSize:SSPBannerViewSize300x250 origin:frame.origin appKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
      }
      else if([bannerSize isEqualToString:@"320x100"]){
          _bannerView = [[AdPopcornSSPBannerView alloc] initWithBannerViewSize:SSPBannerViewSize320x100 origin:frame.origin appKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
      }
      else if([bannerSize isEqualToString:@"AdaptiveSize"]){
          _bannerView = [[AdPopcornSSPBannerView alloc] initWithBannerViewSize:SSPBannerViewSizeAdaptive origin:frame.origin appKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
      }
      _channel = [FlutterMethodChannel
                  methodChannelWithName:[@"adpopcornssp/" stringByAppendingString:placementId]
                        binaryMessenger:messenger];
      _bannerView.delegate = self;
      [_bannerView loadRequest];
  }
  return self;
}

- (UIView*)view {
  return _bannerView;
}


#pragma mark APSSPBannerViewDelegate
/*!
 @abstract
 banner 광고 load 완료시(성공시), 호출된다.
 */
- (void)APSSPBannerViewLoadSuccess:(AdPopcornSSPBannerView *)bannerView
{
    NSLog(@"AdPopcornSSPFLBannerView APSSPBannerViewLoadSuccess");
    [_channel invokeMethod:@"APSSPBannerViewLoadSuccess"
                     arguments:@{@"placementId":bannerView.placementId != nil ? bannerView.placementId : @""}];
}

/*!
 @abstract
 banner 광고 load 실패시, 호출된다.
 */
- (void)APSSPBannerViewLoadFail:(AdPopcornSSPBannerView *)bannerView error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPFLBannerView APSSPBannerViewLoadFail : %@", error);
    [_channel invokeMethod:@"APSSPBannerViewLoadFail"
                     arguments:@{@"placementId":bannerView.placementId != nil ? bannerView.placementId : @"",
                                 @"errorCode":@(error.code)}];
}

/*!
 @abstract
 banner 광고 클릭시, 호출된다.
 */
- (void)APSSPBannerViewClicked:(AdPopcornSSPBannerView *)bannerView
{
    NSLog(@"AdPopcornSSPFLBannerView APSSPBannerViewClicked");
    [_channel invokeMethod:@"APSSPBannerViewClicked"
                     arguments:@{@"placementId":bannerView.placementId != nil ? bannerView.placementId : @""}];
}
@end
