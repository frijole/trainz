//
//  TransitObjects.m
//  interlocking
//
//  Created by Ian Meyer on 11/3/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "TransitObjects.h"
#import "TargetConditionals.h"

#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
#endif

#if __has_include(<AppKit/AppKit.h>)
#import <AppKit/AppKit.h>
#endif

@interface TransitObject ()

@end

@implementation TransitObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super init] ) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    // Override in subclasses
}

- (NSDictionary *)dictionaryRepresentation {
    // Override in subclasses
    return nil;
}

@end


@implementation SubwayLine

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> \"%@\" Status: %@", NSStringFromClass(self.class), self, self.name, self.status];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[@"name"];
    self.status = dictionary[@"status"];
    
    NSString *tmpServiceInformationHTML = dictionary[@"text"];
    
    if ( tmpServiceInformationHTML ) {
        //TODO: Parse into attributed string
        NSAttributedString *tmpAttributedStatus = nil;
#if TARGET_OS_OSX
        tmpAttributedStatus = [[NSAttributedString alloc] initWithHTML:[tmpServiceInformationHTML dataUsingEncoding:NSUTF8StringEncoding]

                                                                         options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                   NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                              documentAttributes:nil];
#else
        NSError *error = nil;
        tmpAttributedStatus = [[NSAttributedString alloc] initWithData:[tmpServiceInformationHTML dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                 options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                                           NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                                      documentAttributes:nil
                                                                                                   error:&error];
#endif
        self.serviceInformation = tmpAttributedStatus;

        self.serviceStatus = [[self serviceStatusFromString:tmpAttributedStatus.string] componentsJoinedByString:@"\n\n"];
        
        NSString *tmpTimestamp = dictionary[@"Date"];
        tmpTimestamp = [tmpTimestamp stringByAppendingFormat:@"%@", dictionary[@"Time"]];
        // TODO: parse into NSDate
        self.serviceInformationUpdatedAt = tmpTimestamp;
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSDictionary *rtnDictionary = @{@"name":self.name,
                                    @"status":self.status,
                                    @"service_status":self.serviceStatus};

    return rtnDictionary;
}

- (NSArray *)serviceStatusFromString:(NSString *)serviceInformationString {
    NSArray *stringFragments = [serviceInformationString componentsSeparatedByString:@"\n\n"];
    
    stringFragments = [stringFragments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ( [evaluatedObject isKindOfClass:[NSString class]] && [(NSString *)evaluatedObject length] > 0 );
    }]];
    
    NSArray *tmpCleanedStrings = @[];
    
    __block NSString *tmpNextString = nil;
    for ( NSString *tmpFragment in stringFragments ) {
        NSString *tmpCleanedString = tmpFragment;

        if ( tmpNextString && tmpNextString.length > 0 ) {
            tmpNextString = [self filteredStatusString:tmpNextString];
            tmpCleanedStrings = [tmpCleanedStrings arrayByAddingObject:tmpNextString];
            tmpNextString = nil;
        }
        
        if ( [tmpCleanedString containsString:@"Posted:"] ) {
            // set it aside for the beginning of the next line
            NSRange tmpPostedRange = [tmpCleanedString rangeOfString:@"Posted:"];
            tmpNextString = [tmpCleanedString substringFromIndex:tmpPostedRange.location];
            tmpCleanedString = [tmpCleanedString substringToIndex:tmpPostedRange.location];
        }
        
        if ( [tmpCleanedString containsString:@"Planned Work"] ) {
            // tmpCleanedStrings = [tmpCleanedStrings arrayByAddingObject:@"Planned Work"];
            tmpCleanedString = [tmpCleanedString stringByReplacingOccurrencesOfString:@"Planned Work" withString:@""];
        }
        
        tmpCleanedString = [self filteredStatusString:tmpCleanedString];
        
        if ( ![tmpCleanedString containsString:@"[ad]"] && tmpCleanedString.length > 1 ) {
            tmpCleanedStrings = [tmpCleanedStrings arrayByAddingObject:tmpCleanedString];
        }
    }
    
    NSLog(@"%@ lines", @(tmpCleanedStrings.count));
    
    return tmpCleanedStrings;
}

- (NSString *)filteredStatusString:(NSString *)statusString {
    statusString = [statusString stringByReplacingOccurrencesOfString:@"•" withString:@""];
    statusString = [statusString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    statusString = [statusString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    statusString = [statusString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( [statusString containsString:@"[1]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[1]" withString:@"①"];
    }
    if ( [statusString containsString:@"[2]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[2]" withString:@"②"];
    }
    if ( [statusString containsString:@"[3]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[3]" withString:@"③"];
    }
    if ( [statusString containsString:@"[4]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[4]" withString:@"④"];
    }
    if ( [statusString containsString:@"[5]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[5]" withString:@"⑤"];
    }
    if ( [statusString containsString:@"[6]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[6]" withString:@"⑥"];
    }
    if ( [statusString containsString:@"[6D]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[6D]" withString:@"⑥"];
    }
    if ( [statusString containsString:@"[7]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[7]" withString:@"⑦"];
    }

    
    if ( [statusString containsString:@"[A]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[A]" withString:@"Ⓐ"];
    }
    if ( [statusString containsString:@"[C]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[C]" withString:@"Ⓒ"];
    }
    if ( [statusString containsString:@"[E]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[E]" withString:@"Ⓔ"];
    }

    if ( [statusString containsString:@"[B]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[B]" withString:@"Ⓑ"];
    }
    if ( [statusString containsString:@"[D]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[D]" withString:@"Ⓓ"];
    }
    if ( [statusString containsString:@"[F]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[F]" withString:@"Ⓕ"];
    }
    if ( [statusString containsString:@"[M]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[M]" withString:@"Ⓜ"];
    }

    if ( [statusString containsString:@"[G]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[G]" withString:@"Ⓖ"];
    }
    
    if ( [statusString containsString:@"[L]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[L]" withString:@"Ⓛ"];
    }
    
    if ( [statusString containsString:@"[N]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[N]" withString:@"Ⓝ"];
    }
    if ( [statusString containsString:@"[Q]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[Q]" withString:@"Ⓠ"];
    }
    if ( [statusString containsString:@"[R]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[R]" withString:@"Ⓡ"];
    }
    
    if ( [statusString containsString:@"[S]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[S]" withString:@"Ⓢ"];
    }
    
    if ( [statusString containsString:@"[J]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[J]" withString:@"Ⓙ"];
    }
    if ( [statusString containsString:@"[Z]"] ) {
        statusString = [statusString stringByReplacingOccurrencesOfString:@"[Z]" withString:@"Ⓩ"];
    }
    
    return statusString;
}

@end


@implementation SubwayTrain

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    // wat
}

@end
