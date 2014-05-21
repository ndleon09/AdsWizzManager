//
//  AdsWizzManager.m
//  AdsWizz
//
//  Created by Nelson Domínguez on 14/01/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "AdsWizzManager.h"

#import "AFHTTPRequestOperation.h"
#import "AdsWizzRequestObject.h"
#import "AdsWizzResponseObject.h"
#import "AdsWizzMediaFile.h"
#import "AdsWizzCompanionAd.h"

@interface AdsWizzManager() <NSXMLParserDelegate>

@property (nonatomic, assign) id<AdsWizzRequestDelegate> delegate;

@property (nonatomic, strong) NSMutableString *currentElementValue;
@property (nonatomic, strong) NSString *trackingEventType;

@property (nonatomic, strong) AdsWizzResponseObject *adsWizzResponseObject;

@end

@implementation AdsWizzManager

+(instancetype)sharedManager
{
    static AdsWizzManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AdsWizzManager alloc] init];
    });
    
    return _sharedManager;
}

-(void)requestAd:(AdsWizzRequestObject*)request delegate:(id<AdsWizzRequestDelegate>)delegate;
{
    [[NSOperationQueue mainQueue] cancelAllOperations];
    
    self.delegate = delegate;
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/www/delivery/swfIndex.php?zoneId=%@&protocolVersion=2.0&reqType=AdsSetup", request.server, request.zone];
    
    if (request.companionZone.length > 0) {
        urlString = [NSString stringWithFormat:@"%@&companionZones=%@", urlString, request.companionZone];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    op.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSXMLParser *parser = (NSXMLParser*)responseObject;
        [parser setDelegate:self];
        [parser parse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(onResponseError:)]) {
            [self.delegate onResponseError:error];
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (NSInteger)secondsForTimeString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return (hours * 60 * 60) + (minutes * 60) + seconds;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.adsWizzResponseObject = [[AdsWizzResponseObject alloc] init];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Ad"]) {
        self.adsWizzResponseObject.rid = [attributeDict valueForKey:@"id"];
    }
    else if ([elementName isEqualToString:@"MediaFile"] && [attributeDict valueForKey:@"apiFramework"] == nil) {
        self.adsWizzResponseObject.mediaFile.delivery = [attributeDict valueForKey:@"delivery"];
        self.adsWizzResponseObject.mediaFile.bitrate = [[attributeDict valueForKey:@"bitrate"] integerValue];
        self.adsWizzResponseObject.mediaFile.width = [[attributeDict valueForKey:@"width"] integerValue];
        self.adsWizzResponseObject.mediaFile.height = [[attributeDict valueForKey:@"height"] integerValue];
        self.adsWizzResponseObject.mediaFile.type = [attributeDict valueForKey:@"type"];
    }
    else if ([elementName isEqualToString:@"Companion"]) {
        self.adsWizzResponseObject.companionAd.cid = [[attributeDict valueForKey:@"id"] integerValue];
        self.adsWizzResponseObject.companionAd.width = [[attributeDict valueForKey:@"width"] integerValue];
        self.adsWizzResponseObject.companionAd.height = [[attributeDict valueForKey:@"height"] integerValue];
    }
    else if ([elementName isEqualToString:@"StaticResource"]) {
        self.adsWizzResponseObject.companionAd.creativeType = [attributeDict valueForKey:@"creativeType"];
    }
    else if ([elementName isEqualToString:@"Tracking"]) {
        self.trackingEventType = [attributeDict valueForKey:@"event"];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *cdataString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    self.currentElementValue = [[NSMutableString alloc] initWithString:cdataString];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentElementValue == nil) {
        self.currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        [self.currentElementValue appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:Impression] && self.adsWizzResponseObject.impressionTrack.length == 0) {
        self.adsWizzResponseObject.impressionTrack = self.currentElementValue;
    }
    else if ([elementName isEqualToString:ClickThrough]) {
        self.adsWizzResponseObject.clickThrough = self.currentElementValue;
    }
    else if ([elementName isEqualToString:CustomClick]) {
        self.adsWizzResponseObject.clickTrack = self.currentElementValue;
    }
    else if ([elementName isEqualToString:@"MediaFile"]) {
        if (self.adsWizzResponseObject.mediaFile.source.length == 0) {
            self.adsWizzResponseObject.mediaFile.source = self.currentElementValue;
        }
    }
    else if ([elementName isEqualToString:@"Tracking"]) {
        if ([self.trackingEventType isEqualToString:@"creativeView"]) {
            self.adsWizzResponseObject.companionAd.trackingCreativeView = self.currentElementValue;
        }
        else {
            [self.adsWizzResponseObject.mediaFile setTrackingEvent:self.trackingEventType url:self.currentElementValue];
        }
        
        self.trackingEventType = nil;
    }
    else if ([elementName isEqualToString:@"StaticResource"]) {
        self.adsWizzResponseObject.companionAd.source = self.currentElementValue;
    }
    else if ([elementName isEqualToString:@"CompanionClickThrough"]) {
        self.adsWizzResponseObject.clickThrough = self.currentElementValue;
    }
    else if ([elementName isEqualToString:@"Duration"]) {
        self.adsWizzResponseObject.duration = [self secondsForTimeString:self.currentElementValue];
    }
    
    self.currentElementValue = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([self.delegate respondsToSelector:@selector(onResponseReady:)]) {
        [self.delegate onResponseReady:self.adsWizzResponseObject];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if ([self.delegate respondsToSelector:@selector(onResponseError:)]) {
        [self.delegate onResponseError:parseError];
    }
}

@end
