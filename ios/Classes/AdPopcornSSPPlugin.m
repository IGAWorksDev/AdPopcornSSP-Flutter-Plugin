#import <Foundation/Foundation.h>
#import "AdPopcornSSPPlugin.h"

@interface AdPopcornSSPPlugin() <APSSPSDKInitializeDelegate, APSSPInterstitialAdDelegate,
    APSSPInterstitialVideoAdDelegate, APSSPRewardVideoAdDelegate, APSSPContentsAdDelegate, APSSPRewardPlusSettingDelegate>
@end

@implementation AdPopcornSSPPlugin

@synthesize channel = _channel;
@synthesize interstitialDictionary = _interstitialDictionary;
@synthesize interstitialVideoDictionary = _interstitialVideoDictionary;
@synthesize rewardVideoDictionary = _rewardVideoDictionary;
@synthesize contentsDictionary = _contentsDictionary;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"adpopcornssp"
            binaryMessenger:[registrar messenger]];
    
    AdPopcornSSPPlugin* instance = [[AdPopcornSSPPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    
    AdPopcornSSPFLBannerViewFactory* bannerFactory =
          [[AdPopcornSSPFLBannerViewFactory alloc] initWithMessenger:registrar.messenger];
      [registrar registerViewFactory:bannerFactory withId:@"AdPopcornSSPBannerView"];
    
    AdPopcornSSPFLNativeViewFactory* nativeFactory =
          [[AdPopcornSSPFLNativeViewFactory alloc] initWithMessenger:registrar.messenger];
      [registrar registerViewFactory:nativeFactory withId:@"AdPopcornSSPNativeView"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if(_interstitialDictionary == nil)
    {
        _interstitialDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if(_interstitialVideoDictionary == nil)
    {
        _interstitialVideoDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if(_rewardVideoDictionary == nil)
    {
        _rewardVideoDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if(_contentsDictionary == nil)
    {
        _contentsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if([@"init" isEqualToString:call.method])
    {
      [self callInit:call result:result];
    }
    else if([@"setUserId" isEqualToString:call.method])
    {
      [self callSetUserId:call result:result];
    }
    else if([@"setLogLevel" isEqualToString:call.method])
    {
      [self callSetLogLevel:call result:result];
    }
    else if([@"setUIDIdentifier" isEqualToString:call.method])
    {
      [self callSetUIDIdentifier:call result:result];
    }
    else if([@"tagForChildDirectedTreatment" isEqualToString:call.method])
    {
      [self callTagForChildDirectedTreatment:call result:result];
    }
    else if([@"loadInterstitial" isEqualToString:call.method])
    {
      [self callLoadInterstitial:call result:result];
    }
    else if([@"showInterstitial" isEqualToString:call.method])
    {
      [self callShowInterstitial:call result:result];
    }
    else if([@"loadInterstitialVideo" isEqualToString:call.method])
    {
        [self callLoadInterstitialVideo:call result:result];
    }
    else if([@"showInterstitialVideo" isEqualToString:call.method])
    {
        [self callShowInterstitialVideo:call result:result];
    }
    else if([@"loadRewardVideo" isEqualToString:call.method])
    {
        [self callLoadRewardVideo:call result:result];
    }
    else if([@"showRewardVideo" isEqualToString:call.method])
    {
        [self callShowRewardVideo:call result:result];
    }
    else if([@"openContents" isEqualToString:call.method])
    {
        [self callOpenContents:call result:result];
    }
    else if([@"openRewardPlusSetting" isEqualToString:call.method])
    {
        [self callOpenRewardPlusSetting:call result:result];
    }
    else if([@"getRewardPlusUserSetting" isEqualToString:call.method])
    {
        [self callGetRewardPlusUserSetting:call result:result];
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

- (void)callInit:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    if(appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
    }
    [AdPopcornSSP initializeSDK:appKey];
    [AdPopcornSSP sharedInstance].initializeDelegate = self;
}

- (void)callSetUserId:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* userId = (NSString*)call.arguments[@"userId"];
    if(userId == nil || userId.length == 0) {
        result([FlutterError errorWithCode:@"no_user_id" message:@"a nil or empty AdPopcornSSP userId was provided" details:nil]);
    }
    [AdPopcornSSP setUserId:userId];
}

- (void)callSetLogLevel:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* logLevel = (NSString*)call.arguments[@"logLevel"];
    if([logLevel isEqualToString:@"Off"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogOff];
    }
    else if([logLevel isEqualToString:@"Critical"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogCritical];
    }
    else if([logLevel isEqualToString:@"Error"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogError];
    }
    else if([logLevel isEqualToString:@"Warning"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogWarning];
    }
    else if([logLevel isEqualToString:@"Info"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogInfo];
    }
    else if([logLevel isEqualToString:@"Debug"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogDebug];
    }
    else if([logLevel isEqualToString:@"Trace"])
    {
        [AdPopcornSSP setLogLevel:AdPopcornSSPLogTrace];
    }
}

- (void)callSetUIDIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* identityType = (NSString*)call.arguments[@"identityType"];
    NSString* identifier = (NSString*)call.arguments[@"identifier"];
    
    int type = 0;
    if(identityType != nil)
    {
        if([identityType isEqualToString:@"phone"])
        {
            type = 1;
        }
    }
    [AdPopcornSSP setUIDIdentifier:type identifier:identifier];
}

- (void)callTagForChildDirectedTreatment:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* tag = (NSString*)call.arguments[@"tag"];
    
    BOOL tagInput = NO;
    if(tag != nil)
    {
        if([tag isEqualToString:@"true"])
        {
            tagInput = YES;
        }
    }
    [AdPopcornSSP tagForChildDirectedTreatment:tagInput];
}

- (void)callLoadInterstitial:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }
    AdPopcornSSPInterstitialAd *interstitialAd;
    if([_interstitialDictionary objectForKey:placementId])
    {
        NSLog(@"callLoadInterstitial already exist interstitial placementId : %@", placementId);
        interstitialAd = [_interstitialDictionary objectForKey:placementId];
    }
    else
    {
        NSLog(@"callLoadInterstitial placementId : %@", placementId);
        interstitialAd = [[AdPopcornSSPInterstitialAd alloc] initWithKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
        interstitialAd.placementId = placementId;
        [_interstitialDictionary setObject:interstitialAd forKey:placementId];
    }
    interstitialAd.delegate = self;
    [interstitialAd loadRequest];
}

- (void)callShowInterstitial:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }
    
    if([_interstitialDictionary objectForKey:placementId])
    {
        NSLog(@"callShowInterstitial already exist interstitial placementId : %@", placementId);
        AdPopcornSSPInterstitialAd *intertitialAd = [_interstitialDictionary objectForKey:placementId];
        [intertitialAd presentFromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    }
    else
    {
        NSLog(@"callShowInterstitial placementId : %@", placementId);
        result([FlutterError errorWithCode:@"no_load_ad" message:@"interstitial is not loaded" details:nil]);
        return;
    }
}

- (void)callLoadInterstitialVideo:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }

    AdPopcornSSPInterstitialVideoAd *interstitialVideoAd;
    if([_interstitialVideoDictionary objectForKey:placementId])
    {
        NSLog(@"callLoadInterstitialVideo already exist interstitial video placementId : %@", placementId);
        interstitialVideoAd = [_interstitialVideoDictionary objectForKey:placementId];
    }
    else
    {
        
        NSLog(@"callLoadInterstitialVideo placementId : %@", placementId);
        interstitialVideoAd = [[AdPopcornSSPInterstitialVideoAd alloc] initWithKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
        interstitialVideoAd.placementId = placementId;
        [_interstitialVideoDictionary setObject:interstitialVideoAd forKey:placementId];
    }
    interstitialVideoAd.delegate = self;
    [interstitialVideoAd loadRequest];
}

- (void)callShowInterstitialVideo:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }
    
    if([_interstitialVideoDictionary objectForKey:placementId])
    {
        NSLog(@"callShowInterstitialVideo already exist interstitial video placementId : %@", placementId);
        AdPopcornSSPInterstitialVideoAd *intertitialVideoAd = [_interstitialVideoDictionary objectForKey:placementId];
        [intertitialVideoAd presentFromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    }
    else
    {
        NSLog(@"callShowInterstitialVideo placementId : %@", placementId);
        result([FlutterError errorWithCode:@"no_load_ad" message:@"interstitial video is not loaded" details:nil]);
        return;
    }
}

- (void)callLoadRewardVideo:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }

    AdPopcornSSPRewardVideoAd *rewardVideoAd;
    if([_rewardVideoDictionary objectForKey:placementId])
    {
        NSLog(@"callLoadRewardVideo already exist reward video placementId : %@", placementId);
        rewardVideoAd = [_rewardVideoDictionary objectForKey:placementId];
    }
    else
    {
        NSLog(@"callLoadRewardVideo placementId : %@", placementId);
        rewardVideoAd = [[AdPopcornSSPRewardVideoAd alloc] initWithKey:appKey placementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
        rewardVideoAd.placementId = placementId;
        [_rewardVideoDictionary setObject:rewardVideoAd forKey:placementId];
    }
    rewardVideoAd.delegate = self;
    [rewardVideoAd loadRequest];
}

- (void)callShowRewardVideo:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }
    
    if([_rewardVideoDictionary objectForKey:placementId])
    {
        NSLog(@"callShowRewardVideo already exist reward video placementId : %@", placementId);
        AdPopcornSSPRewardVideoAd *rewardVideoAd = [_rewardVideoDictionary objectForKey:placementId];
        [rewardVideoAd presentFromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    }
    else
    {
        NSLog(@"callShowRewardVideo placementId : %@", placementId);
        result([FlutterError errorWithCode:@"no_load_ad" message:@"reward video is not loaded" details:nil]);
        return;
    }
}

- (void)callOpenContents:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    NSString* placementId = (NSString*)call.arguments[@"placementId"];
    if(appKey == nil || appKey.length == 0) {
        result([FlutterError errorWithCode:@"no_app_key" message:@"a nil or empty AdPopcornSSP appKey was provided" details:nil]);
        return;
    }
    if (placementId == nil || placementId.length == 0) {
        result([FlutterError errorWithCode:@"no_placement_id" message:@"a nil or empty AdPopcornSSP placementId was provided" details:nil]);
        return;
    }
    
    AdPopcornSSPContentsAd *contentsAd;
    if([_contentsDictionary objectForKey:placementId])
    {
        NSLog(@"callOpenContents already exist contents ad placementId : %@", placementId);
        contentsAd = [_contentsDictionary objectForKey:placementId];
    }
    else
    {
        NSLog(@"callOpenContents placementId : %@", placementId);
        contentsAd = [[AdPopcornSSPContentsAd alloc] initWithAppKey:appKey contentsPlacementId:placementId viewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
        [_contentsDictionary setObject:contentsAd forKey:placementId];
    }
    contentsAd.delegate = self;
    [contentsAd openContents];
}

- (void)callOpenRewardPlusSetting:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    [AdPopcornSSP openRewardPlusSettingViewController:appKey viewCotroller:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
}

- (void)callGetRewardPlusUserSetting:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* appKey = (NSString*)call.arguments[@"appKey"];
    [AdPopcornSSP sharedInstance].rewardPlusDelegate = self;
    [AdPopcornSSP getRewardPlusUserSetting:appKey];
}

#pragma mark APSSPSDKInitializeDelegate
- (void)AdPopcornSSPSDKDidInitialize
{
    NSLog(@"AdPopcornSSPPlugin AdPopcornSSPSDKDidInitialize");
    [_channel invokeMethod:@"AdPopcornSSPSDKDidInitialize" arguments:@{}];
}

#pragma mark APSSPRewardPlusSettingDelegate
- (void)APSSPRewardPlusSettingInfo:(NSString *)connectedId dailyUserLimit:(int)dailyUserLimit dailyUserCount:(int)dailyUserCount
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardPlusSettingInfo");
    [_channel invokeMethod:@"APSSPRewardPlusSettingInfo"
                     arguments:@{@"connectedId":connectedId != nil ? connectedId : @"",
                                 @"dailyUserLimit":@(dailyUserLimit),
                                 @"dailyUserCount":@(dailyUserCount)}];
}

#pragma mark APSSPInterstitialAdDelegate
/*!
 @abstract
 intersitial 광고 load 완료시(성공시), 호출된다.
 */
- (void)APSSPInterstitialAdLoadSuccess:(AdPopcornSSPInterstitialAd *)interstitialAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdLoadSuccess");
    [_channel invokeMethod:@"APSSPInterstitialAdLoadSuccess"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @""}];
}

/*!
 @abstract
 intersitial 광고 load 실패시, 호출된다.
 */
- (void)APSSPInterstitialAdLoadFail:(AdPopcornSSPInterstitialAd *)interstitialAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdLoadFail : %@", error);
    [_channel invokeMethod:@"APSSPInterstitialAdLoadFail"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @"",
                                 @"errorCode":@(error.code)}];
}

/*!
 @abstract
 intersitial 광고 close시, 호출된다.
 */
- (void)APSSPInterstitialAdClosed:(AdPopcornSSPInterstitialAd *)interstitialAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdClosed");
    [_channel invokeMethod:@"APSSPInterstitialAdClosed"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @""}];
}

/*!
 @abstract
 intersitial 광고 클릭시, 호출된다.
 */
- (void)APSSPInterstitialAdClicked:(AdPopcornSSPInterstitialAd *)interstitialAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdClicked");
    [_channel invokeMethod:@"APSSPInterstitialAdClicked"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @""}];
}

/*!
 @abstract
 intersitial 광고 show 완료시(성공시), 호출된다.
 */
- (void)APSSPInterstitialAdShowSuccess:(AdPopcornSSPInterstitialAd *)interstitialAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdShowSuccess");
    [_channel invokeMethod:@"APSSPInterstitialAdShowSuccess"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @""}];
}

/*!
 @abstract
 intersitial 광고 show 실패시, 호출된다.
 */
- (void)APSSPInterstitialAdShowFail:(AdPopcornSSPInterstitialAd *)interstitialAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialAdShowFail : %@", error);
    [_channel invokeMethod:@"APSSPInterstitialAdShowFail"
                     arguments:@{@"placementId":interstitialAd.placementId != nil ? interstitialAd.placementId : @""}];
}

#pragma mark APSSPInterstitialVideoAdDelegate
/*!
 @abstract
 interstitial video 광고 로드에 성공한 경우 호출된다.
 */
- (void)APSSPInterstitialVideoAdLoadSuccess:(AdPopcornSSPInterstitialVideoAd *)interstitialVideoAd
{
    [_channel invokeMethod:@"APSSPInterstitialVideoAdLoadSuccess"
                     arguments:@{@"placementId":interstitialVideoAd.placementId != nil ? interstitialVideoAd.placementId : @""}];
}

/*!
 @abstract
 interstitial video 광고 로드에 실패한 경우 호출된다.
 */
- (void)APSSPInterstitialVideoAdLoadFail:(AdPopcornSSPInterstitialVideoAd *)interstitialVideoAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialVideoAdLoadFail : %@", error);
    [_channel invokeMethod:@"APSSPInterstitialVideoAdLoadFail"
                      arguments:@{@"placementId":interstitialVideoAd.placementId != nil ? interstitialVideoAd.placementId : @"",
                                  @"errorCode":@(error.code)}];
}

/*!
 @abstract
 interstitial video 광고가 정상적으로 노출될 때 호출된다.
 */
- (void)APSSPInterstitialVideoAdShowSuccess:(AdPopcornSSPInterstitialVideoAd *)interstitialVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialVideoAdShowSuccess");
    [_channel invokeMethod:@"APSSPInterstitialVideoAdShowSuccess"
                     arguments:@{@"placementId":interstitialVideoAd.placementId != nil ? interstitialVideoAd.placementId : @""}];
}

/*!
 @abstract
 interstitial video 광고가 노출에 실패했을 때 호출된다.
 */
- (void)APSSPInterstitialVideoAdShowFail:(AdPopcornSSPInterstitialVideoAd *)interstitialVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialVideoAdShowFail");
    [_channel invokeMethod:@"APSSPInterstitialVideoAdShowFail"
                     arguments:@{@"placementId":interstitialVideoAd.placementId != nil ? interstitialVideoAd.placementId : @""}];
}

/*!
 @abstract
 interstitial video 광고가 닫히면 호출된다.
 */
- (void)APSSPInterstitialVideoAdClosed:(AdPopcornSSPInterstitialVideoAd *)interstitialVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPInterstitialVideoAdClosed");
    [_channel invokeMethod:@"APSSPInterstitialVideoAdClosed"
                     arguments:@{@"placementId":interstitialVideoAd.placementId != nil ? interstitialVideoAd.placementId : @""}];
}

#pragma mark APSSPRewardVideoAdDelegate
/*!
 @abstract
 video 광고 로드에 성공한 경우 호출된다.
 */
- (void)APSSPRewardVideoAdLoadSuccess:(AdPopcornSSPRewardVideoAd *)rewardVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdLoadSuccess");
    [_channel invokeMethod:@"APSSPRewardVideoAdLoadSuccess"
                     arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @""}];
}

/*!
 @abstract
 video 광고 로드에 실패한 경우 호출된다.
 */
- (void)APSSPRewardVideoAdLoadFail:(AdPopcornSSPRewardVideoAd *)rewardVideoAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdLoadFail : %@", error);
    [_channel invokeMethod:@"APSSPRewardVideoAdLoadFail"
                 arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @"",
                             @"errorCode":@(error.code)}];
}

/*!
 @abstract
 video 광고가 정상적으로 노출될 때 호출된다.
 */
- (void)APSSPRewardVideoAdShowSuccess:(AdPopcornSSPRewardVideoAd *)rewardVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdShowSuccess");
    [_channel invokeMethod:@"APSSPRewardVideoAdShowSuccess"
                     arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @""}];
}

/*!
 @abstract
 video 광고가 노출에 실패했을 때 호출된다.
 */
- (void)APSSPRewardVideoAdShowFail:(AdPopcornSSPRewardVideoAd *)rewardVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdShowFail");
    [_channel invokeMethod:@"APSSPRewardVideoAdShowFail"
                     arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @""}];
}

/*!
 @abstract
 video 광고가 닫히면 호출된다.
 */
- (void)APSSPRewardVideoAdClosed:(AdPopcornSSPRewardVideoAd *)rewardVideoAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdClosed");
    [_channel invokeMethod:@"APSSPRewardVideoAdClosed"
                     arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @""}];
}

/*!
 @abstract
 AP SSP reward video 재생 완료 시 호출된다.
 */
- (void)APSSPRewardVideoAdPlayCompleted:(AdPopcornSSPRewardVideoAd *)rewardVideoAd adNetworkNo:(long) adNetworkNo completed:(BOOL)completed
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardVideoAdPlayCompleted");
    [_channel invokeMethod:@"APSSPRewardVideoAdPlayCompleted"
                     arguments:@{@"placementId":rewardVideoAd.placementId != nil ? rewardVideoAd.placementId : @"",
                                 @"adNetworkNo":@(adNetworkNo),
                                 @"completed":@(completed)}];
}

/*!
 @abstract
 AP SSP reward plus 리워드 적립 요청 완료 시 호출된다.
 */
- (void)APSSPRewardPlusCompleteResult:(BOOL)result resultCode:(int) resultCode reward:(int)reward
{
    NSLog(@"AdPopcornSSPPlugin APSSPRewardPlusCompleteResult");
    [_channel invokeMethod:@"APSSPRewardPlusCompleteResult"
                     arguments:@{@"result":@(result),
                                 @"resultCode":@(resultCode),
                                 @"reward":@(reward)}];
}

#pragma mark APSSPContentsAdDelegate
- (void)APSSPContentsAdOpenSuccess:(AdPopcornSSPContentsAd *)contentsAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPContentsAdOpenSuccess");
    [_channel invokeMethod:@"ContentsAdOpenSuccess" arguments:@{}];
}

- (void)APSSPContentsAdOpenFail:(AdPopcornSSPContentsAd *)contentsAd error:(AdPopcornSSPError *)error
{
    NSLog(@"AdPopcornSSPPlugin APSSPContentsAdOpenFail");
    [_channel invokeMethod:@"ContentsAdOpenFail" arguments:@{}];
}

- (void)APSSPContentsAdClosed:(AdPopcornSSPContentsAd *)contentsAd
{
    NSLog(@"AdPopcornSSPPlugin APSSPContentsAdClosed");
    [_channel invokeMethod:@"ContentsAdClosed" arguments:@{}];
}

- (void)APSSPContentsAdComplete:(AdPopcornSSPContentsAd *)contentsAd reward:(NSInteger)reward rewardKey:(NSString *)rewardKey { 
    NSLog(@"AdPopcornSSPPlugin APSSPContentsAdComplete");
    [_channel invokeMethod:@"ContentsAdCompleted" 
                 arguments:@{@"reward":@(reward),
                             @"rewardKey":rewardKey}];
}
@end
