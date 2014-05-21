//
//  AdsWizzMediaFile.m
//  AdsWizz
//
//  Created by Nelson Domínguez on 14/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "AdsWizzMediaFile.h"

NSString *const EventStart = @"start";
NSString *const EventFirstQuartile = @"firstQuartile";
NSString *const EventMidpoint = @"midpoint";
NSString *const EventThirdQuartile = @"thirdQuartile";
NSString *const EventComplete = @"complete";

@implementation AdsWizzMediaFile

@synthesize trackingEvents = _trackingEvents;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _trackingEvents = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setTrackingEvent:(NSString*)event url:(NSString*)url
{
    if ([_trackingEvents objectForKey:event] == nil) {
        [_trackingEvents setObject:url forKey:event];
    }
}

@end
