//
//  ViewController.m
//  AdsWizzManagerDemo
//
//  Created by Nelson Domínguez on 29/05/14.
//  Copyright (c) 2014 Nelson Dominguez León. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AdsWizzManager/AdsWizzManager.h>

@interface ViewController () <AdsWizzRequestDelegate>

@property (nonatomic, strong) AdsWizzResponseObject *adsResponseObject;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSTimer *timerTracking;
@property (nonatomic, assign) NSInteger trackPosition;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"AdsWizzManagerDemo";
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStylePlain target:self action:@selector(makeRequest)];
    
    [self makeRequest];
}

-(void)makeRequest
{
    AdsWizzRequestObject *adsRequest = [[AdsWizzRequestObject alloc] init];
    adsRequest.server = @"kriteria.adswizz.com";
    adsRequest.zone = @"1499";
    adsRequest.companionZone = @"1401";
    
    [[AdsWizzManager sharedManager] requestAd:adsRequest delegate:self];
}

-(void)onResponseReady:(AdsWizzResponseObject *)response
{
    self.adsResponseObject = response;
    
    if (self.adsResponseObject.rid.length > 0) {
        
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        [self.adsResponseObject trackImpression];
        
        if ([self.adsResponseObject.mediaFile.type isEqualToString:@"audio/mpeg"]) {
            [self playAudioWithURL:[NSURL URLWithString:self.adsResponseObject.mediaFile.source]];
        }
    }
}

-(void)onResponseError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)playAudioWithURL:(NSURL*)url
{
    self.player = [AVPlayer playerWithURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.player play];
    
    self.timerTracking = [NSTimer scheduledTimerWithTimeInterval:self.adsResponseObject.duration / 4 target:self selector:@selector(trackProgress:) userInfo:nil repeats:YES];
    [self.timerTracking fire];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.adsResponseObject trackComplete];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.trackPosition = 0;
    self.player = nil;
    self.adsResponseObject = nil;
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

-(void)trackProgress:(NSTimer*)timer
{
    if (self.trackPosition == 0) {
        [self.adsResponseObject trackStart];
    }
    else if (self.trackPosition == 1) {
        [self.adsResponseObject trackFirstQuartile];
    }
    else if (self.trackPosition == 2) {
        [self.adsResponseObject trackMidPoint];
    }
    else if (self.trackPosition == 3) {
        [self.adsResponseObject trackThirdQuartile];
        
        [self.timerTracking invalidate];
        self.timerTracking = nil;
    }
    
    self.trackPosition = self.trackPosition + 1;
}

@end
