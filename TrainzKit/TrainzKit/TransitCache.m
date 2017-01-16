//
//  TransitCache.m
//  TrainzKit
//
//  Created by Ian Meyer on 1/15/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import "TransitCache.h"
#import <CloudKit/CloudKit.h>

NSString * const kUserDefaultsSuiteName = @"group.info.frijole.trainz";
NSString * const kCloudKitContainerIdentifier = @"iCloud.info.frijole.TrainzApp";

NSString * const kTransitCacheStatusCollectionKey = @"lineStatuses";
NSString * const kTransitCacheLastUpdatedDateKey = @"lastUpdated";

@interface TransitCache ()

@property (readwrite, copy) NSDate *lastUpdated;
@property (readwrite) NSArray<SubwayLine*> *subwayLineStatus;

#pragma mark - Device Cache
// Read in potentially-updated information
// Automatically done to populate properties
- (void)refreshFromUserDefaults;

// Save fresh statuses from transitHandler to the cache
// Will call updateCloud...: after saving locally
- (void)updateDefaultsWithSubwayStatus:(NSArray<NSDictionary*>*)subwayStatuses;

#pragma mark - CloudKit wrapper

- (void)checkCloudStatusWithCompletion:(void (^)(BOOL available, NSError *error))completionBlock;

// Check for remotely cached statuses, could take a bit so async.
- (void)refreshFromCloudWithCompletion:(void (^)(NSArray *subwayLineStatus, NSError *error))completionBlock;

// Save cached statuses to the cloud
- (void)updateCloudWithSubwayStatus:(NSArray<NSDictionary*>*)subwayStatuses;

@end

@implementation TransitCache

+ (TransitCache *)defaultCache {
    static TransitCache *_defaultCache = nil;
    if ( _defaultCache ) {
        _defaultCache = [[TransitCache alloc] init];
        [_defaultCache refreshFromUserDefaults];
    }
    return _defaultCache;
}

- (void)refreshCacheWithCompletion:(void (^)(NSArray *subwayLineStatus, NSError *))completionBlock {
    [self refreshFromUserDefaults];
    [self refreshFromCloudWithCompletion:^(NSArray *subwayLineStatus, NSError *error) {
        if ( completionBlock ) {
            // whatever collection we have, and any error we got from the cloud
            dispatch_async(dispatch_get_main_queue(),^{completionBlock(self.subwayLineStatus, error);});
        }
    }];
}

- (void)updateCacheWithSubwayStatus:(NSArray<SubwayLine *>*)updatedLineStatus {
    NSMutableArray *tmpArrayToCache = [NSMutableArray array];
    for ( SubwayLine *tmpLine in updatedLineStatus ) {
        NSDictionary *tmpLineDict = [tmpLine dictionaryRepresentation];
        [tmpArrayToCache addObject:tmpLineDict];
    }
    
    [self updateDefaultsWithSubwayStatus:tmpArrayToCache];
    [self updateCloudWithSubwayStatus:tmpArrayToCache];
}

#pragma mark - Local

- (void)refreshFromUserDefaults {
    NSUserDefaults *tmpSharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultsSuiteName];

    // date?
    NSDate *tmpLastUpdated = [tmpSharedDefaults objectForKey:kTransitCacheLastUpdatedDateKey];
    if ( tmpLastUpdated ) {
        self.lastUpdated = tmpLastUpdated;
    }
    
    // statuses?
    NSArray *tmpLineDicts = [tmpSharedDefaults objectForKey:kTransitCacheStatusCollectionKey];
    NSMutableArray *tmpLineStatuses = [NSMutableArray array];
    if ( tmpLineDicts && tmpLineDicts.count > 0 ) {
        for ( NSDictionary *tmpLineDict in tmpLineDicts ) {
            SubwayLine *tmpLine = [[SubwayLine alloc] initWithDictionary:tmpLineDict];
            if ( tmpLine ) {
                [tmpLineStatuses addObject:tmpLine];
            } else {
                NSLog(@"error creating line object from cached status dictionary: %@", tmpLineDict);
            }
        }
    }
    
    self.subwayLineStatus = tmpLineStatuses;
}

- (void)updateDefaultsWithSubwayStatus:(NSArray<NSDictionary *> *)subwayStatuses {
    NSUserDefaults *tmpSharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultsSuiteName];
    [tmpSharedDefaults setObject:subwayStatuses forKey:kTransitCacheStatusCollectionKey];
    [tmpSharedDefaults setObject:[NSDate date] forKey:kTransitCacheLastUpdatedDateKey];
}

#pragma mark - Cloud

- (void)checkCloudStatusWithCompletion:(void (^)(BOOL available, NSError *error))completionBlock {
    CKContainer *tmpContainer = [CKContainer containerWithIdentifier:kCloudKitContainerIdentifier];
    [tmpContainer accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        NSLog(@"accountStatusWithCompletion returned status: %@, error: %@", @(accountStatus), error);
        
        BOOL rtnAvailable = NO;
        if ( accountStatus == CKAccountStatusAvailable ) {
            rtnAvailable = YES;
        }
        
        if ( completionBlock ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(rtnAvailable, error);
            });
        }
    }];
}

- (void)refreshFromCloudWithCompletion:(void (^)(NSArray *subwayLineStatus, NSError *error))completionBlock {
    void (^fetchFromCloudBlock)() = ^{
        // wat
    };
    
    [self checkCloudStatusWithCompletion:^(BOOL available, NSError *error) {
        if ( !available || error ) {
            NSLog(@"cloud not available, error: %@", error);
        } else {
            fetchFromCloudBlock();
        }
    }];
}

- (void)updateCloudWithSubwayStatus:(NSArray<NSDictionary *> *)subwayStatuses {
    void (^updateCloudBlock)() = ^{
        // wat
    };
    
    [self checkCloudStatusWithCompletion:^(BOOL available, NSError *error) {
        if ( !available || error ) {
            NSLog(@"cloud not available, error: %@", error);
        } else {
            updateCloudBlock();
        }
    }];
}

@end
