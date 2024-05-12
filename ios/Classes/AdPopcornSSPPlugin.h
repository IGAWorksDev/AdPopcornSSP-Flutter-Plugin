#import <Flutter/Flutter.h>

@interface AdPopcornSSPPlugin : NSObject<FlutterPlugin>
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property (retain, nonatomic) NSMutableDictionary *interstitialDictionary;
@property (retain, nonatomic) NSMutableDictionary *interstitialVideoDictionary;
@property (retain, nonatomic) NSMutableDictionary *rewardVideoDictionary;
@end
