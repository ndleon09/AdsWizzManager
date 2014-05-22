//
//  AdsWizzResponseObject.m
//  AdsWizz
//
//  Created by Nelson Domínguez on 15/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "AdsWizzResponseObject.h"
#import "AdsWizzMediaFile.h"
#import "AdsWizzCompanionAd.h"
#import "AFHTTPRequestOperationManager.h"

NSString *const Impression = @"Impression";
NSString *const CustomClick = @"CustomClick";
NSString *const ClickThrough = @"ClickThrough";

@implementation AdsWizzResponseObject

- (id)init
{
    self = [super init];
    if (self) {
        _mediaFile = [[AdsWizzMediaFile alloc] init];
        _companionAd = [[AdsWizzCompanionAd alloc] init];
    }
    return self;
}

-(void)trackEvent:(NSString*)eventName
{
    NSLog(@"Traking Event: %@", eventName);
    
    NSString *url = nil;
    
    if ([eventName isEqualToString:Impression]) {
        url = self.impressionTrack;
    }
    
    else if ([eventName isEqualToString:CustomClick]){
        url = self.clickTrack;
    }
    
    else if ([eventName isEqualToString:@"creativeView"]) {
        url = self.companionAd.trackingCreativeView;
    }
    
    else {
        url = [self.mediaFile.trackingEvents objectForKey:eventName];
    }
    
    if (url != nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:nil failure:nil];
    }
}

-(void)trackImpression
{
    [self trackEvent:Impression];
}

-(void)trackStart
{
    [self trackEvent:EventStart];
}

-(void)trackFirstQuartile
{
    [self trackEvent:EventFirstQuartile];
}

-(void)trackMidPoint
{
    [self trackEvent:EventMidpoint];
}

-(void)trackThirdQuartile
{
    [self trackEvent:EventThirdQuartile];
}

-(void)trackComplete
{
    [self trackEvent:EventComplete];
}

-(void)trackClick
{
    [self trackEvent:CustomClick];
}

-(void)trackCreativeView
{
    [self trackEvent:@"creativeView"];
}

@end
