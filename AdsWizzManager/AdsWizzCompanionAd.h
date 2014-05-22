//
//  AdsWizzCompanionAd.h
//  AdsWizz
//
//  Created by Nelson Domínguez on 15/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsWizzCompanionAd : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *creativeType;
@property (nonatomic, strong) NSString *trackingCreativeView;

@end
