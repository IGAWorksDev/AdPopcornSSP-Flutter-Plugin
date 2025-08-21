#import <Flutter/Flutter.h>
#import <AdPopcornSSP/AdPopcornSSPSDK.h>
#import "AdPopcornSSPFLBannerView.h"
#import "AdPopcornSSPFLNativeView.h"

@interface AdPopcornSSPPlugin : NSObject<FlutterPlugin>
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property (retain, nonatomic) NSMutableDictionary *interstitialDictionary;
@property (retain, nonatomic) NSMutableDictionary *interstitialVideoDictionary;
@property (retain, nonatomic) NSMutableDictionary *rewardVideoDictionary;
@property (retain, nonatomic) NSMutableDictionary *contentsDictionary;
@property (retain, nonatomic) NSMutableDictionary *popContentsDictionary;
@end
