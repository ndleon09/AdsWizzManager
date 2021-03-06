#AdsWizz library for IOS

##Installation

Just add `pod "AdsWizzManager", :git => "https://github.com/ndleon09/AdsWizzManager"` to your Podfile and run `pod install`.

##ARC

AdsWizzManager uses ARC (Automatic Reference Counting).

If you are using AdsWizzManager in your non-arc project, you will need to set a -fobjc-arc compiler flag on all of the AdsWizzManager source files.

To set a compiler flag in Xcode, go to your active target and select the "Build Phases" tab. Now select all AdsWizzManager source files, press Enter, insert -fobjc-arc and then "Done" to disable ARC for AdsWizzManager.

##Usage

`#import <AdsWizzManager/AdsWizzManager.h>`

Create a `AdsWizzRequestObject`, for example:

```objective-c
AdsWizzRequestObject* request = [[AdsWizzRequestObject alloc] init];
request.zone = @"XXXX";
request.companionZone = @"XXXX";
request.server = @"kriteria.adswizz.com";
````


Make the request using the class `AdsWizzManager`, for example:

```objective-c
[[AdsWizzManager sharedManager] requestAd:request delegate:self];
```

*Do not forget to implement the delegate `AdsWizzRequestDelegate`*

```objective-c
-(void)onResponseReady:(AdsWizzResponseObject *)adResponse
{
    self.adResponseObject = adResponse;
}

-(void)onResponseError:(NSString*)info
{
    NSLog( @"Error: %@", info);
}
```

To make calls to **tracking urls**, use the following methods of `AdsWizzResponseObject`

```objective-c
-(void)trackImpression;
-(void)trackStart;
-(void)trackCreativeView;
-(void)trackFirstQuartile;
-(void)trackMidPoint;
-(void)trackThirdQuartile;
-(void)trackComplete;
-(void)trackClick;
```