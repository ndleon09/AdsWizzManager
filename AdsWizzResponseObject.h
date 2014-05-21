//
//  AdsWizzResponseObject.h
//  AdsWizz
//
//  Created by Nelson Domínguez on 15/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const Impression;
extern NSString *const CustomClick;
extern NSString *const ClickThrough;

@class AdsWizzMediaFile;
@class AdsWizzCompanionAd;

@interface AdsWizzResponseObject : NSObject

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) AdsWizzMediaFile *mediaFile;
@property (nonatomic, strong) AdsWizzCompanionAd *companionAd;
@property (nonatomic, strong) NSString *impressionTrack;
@property (nonatomic, strong) NSString *clickTrack;
@property (nonatomic, strong) NSString *clickThrough;

-(void)trackImpression;
-(void)trackStart;
-(void)trackFirstQuartile;
-(void)trackMidPoint;
-(void)trackThirdQuartile;
-(void)trackComplete;
-(void)trackClick;
-(void)trackCreativeView;

@end
