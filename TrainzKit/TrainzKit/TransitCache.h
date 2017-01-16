//
//  TransitCache.h
//  TrainzKit
//
//  Created by Ian Meyer on 1/15/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitObjects.h"

@interface TransitCache : NSObject

+ (TransitCache *)defaultCache;

@property (readonly, copy) NSDate *lastUpdated;
@property (readonly) NSArray<SubwayLine*> *subwayLineStatus;

// check for local data and cloud data
- (void)refreshCacheWithCompletion:(void (^)(NSArray *subwayLineStatus, NSError *error))completionBlock;
// Save fresh statuses from transitHandler to local and cloud caches (if possible)
- (void)updateCacheWithSubwayStatus:(NSArray<SubwayLine*>*)updatedLineStatus;

@end
