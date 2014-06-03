//
//  ViewController.m
//  AdsWizzManagerDemo
//
//  Created by Nelson Domínguez on 29/05/14.
//  Copyright (c) 2014 Nelson Dominguez leon. All rights reserved.
//

#import "ViewController.h"
#import <AdsWizzManager/AdsWizzManager.h>

@interface ViewController () <AdsWizzRequestDelegate>

@property (nonatomic, strong) AdsWizzResponseObject *adsResponseObject;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    AdsWizzRequestObject *adsRequest = [[AdsWizzRequestObject alloc] init];
    adsRequest.server = @"kriteria.adswizz.com";
    adsRequest.zone = @"1499";
    adsRequest.companionZone = @"1401";
    
    [[AdsWizzManager sharedManager] requestAd:adsRequest delegate:self];
}

-(void)onResponseReady:(AdsWizzResponseObject *)response
{
    self.adsResponseObject = response;
}

-(void)onResponseError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
