//
//  AdsWizzMediaFile.h
//  AdsWizz
//
//  Created by Nelson Domínguez on 14/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const EventStart;
extern NSString *const EventFirstQuartile;
extern NSString *const EventMidpoint;
extern NSString *const EventThirdQuartile;
extern NSString *const EventComplete;

@interface AdsWizzMediaFile : NSObject
{
    NSMutableDictionary *_trackingEvents;
}

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, retain) NSString * delivery;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, retain) NSString * source;

@property (nonatomic, strong, readonly) NSDictionary *trackingEvents;

-(void)setTrackingEvent:(NSString*)event url:(NSString*)url;

@end
