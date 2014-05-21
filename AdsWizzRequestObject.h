//
//  AdsWizzRequestObject.h
//  AdsWizz
//
//  Created by Nelson Domínguez on 14/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdsWizzResponseObject;

@interface AdsWizzRequestObject : NSObject

@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *companionZone;

@end

@protocol AdsWizzRequestDelegate <NSObject>

-(void)onResponseError:(NSError*)error;
-(void)onResponseReady:(AdsWizzResponseObject*)response;

@end
