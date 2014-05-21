//
//  AdsWizzManager.h
//  AdsWizz
//
//  Created by Nelson Domínguez on 14/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdsWizzRequestObject.h"
#import "AdsWizzResponseObject.h"
#import "AdsWizzMediaFile.h"
#import "AdsWizzCompanionAd.h"

@class AdsWizzResponseObject;

@interface AdsWizzManager : NSObject

+(instancetype)sharedManager;

-(void)requestAd:(AdsWizzRequestObject*)request delegate:(id<AdsWizzRequestDelegate>)delegate;

@end
