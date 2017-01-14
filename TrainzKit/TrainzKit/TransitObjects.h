//
//  TransitObjects.h
//  interlocking
//
//  Created by Ian Meyer on 11/3/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end

// Handy interface for parsed subway lines, eg: A/C/E, B/D/F/M
@interface SubwayLine : TransitObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSAttributedString *serviceInformation;
@property (nonatomic, copy) NSString *serviceStatus; // simplified version of above
@property (nonatomic, copy) NSString *serviceInformationUpdatedAt; // TODO: NSDate

@end

// For a single train, eg: F
@interface SubwayTrain : TransitObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *serviceStatus; // simplified version of above
@property (nonatomic, copy) NSString *serviceInformationUpdatedAt; // TODO: NSDate

@end

// TODO: Train-specific statuses

// LIRR

// MetroNorth

// Bus

// B&T
