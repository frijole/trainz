//
//  ComplicationController.m
//  TrainzNano Extension
//
//  Created by Ian Meyer on 1/14/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    handler([CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:[self templateForComplication:complication] timelineAnimationGroup:nil]);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    handler([self templateForComplication:complication]);
}

#pragma mark - Utilities

- (CLKComplicationTemplate *)templateForComplication:(CLKComplication *)complication {
    CLKComplicationTemplate *rtnTemplate = nil;
    
    switch (complication.family) {
        case CLKComplicationFamilyExtraLarge: {
            CLKComplicationTemplateExtraLargeStackImage *tmpTemplate = [[CLKComplicationTemplateExtraLargeStackImage alloc] init];
            [tmpTemplate setLine1ImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-ok"]]];
            [tmpTemplate.line1ImageProvider setTintColor:[UIColor greenColor]];
            [tmpTemplate setLine2TextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            rtnTemplate = tmpTemplate;
        }
            break;
            
        case CLKComplicationFamilyModularLarge: {
            CLKComplicationTemplateModularLargeStandardBody *tmpTemplate = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
//            [tmpTemplate setHeaderImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-alert"]]];
//            [tmpTemplate.headerImageProvider setTintColor:[UIColor orangeColor]];
            [tmpTemplate setHeaderTextProvider:[CLKTextProvider textProviderWithFormat:@"Service Alert"]];
            [tmpTemplate setBody1TextProvider:[CLKTextProvider textProviderWithFormat:@"ⒶⒸⒺ Delays"]];
            rtnTemplate = tmpTemplate;
        }
            break;
            
        case CLKComplicationFamilyModularSmall: {
            CLKComplicationTemplateModularSmallSimpleImage *tmpTemplate = [[CLKComplicationTemplateModularSmallSimpleImage alloc] init];
            [tmpTemplate setImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-alert"]]];
            [[tmpTemplate imageProvider] setTintColor:[UIColor orangeColor]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyCircularSmall: {
            CLKComplicationTemplateCircularSmallSimpleImage *tmpTemplate = [[CLKComplicationTemplateCircularSmallSimpleImage alloc] init];
            [tmpTemplate setImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-alert"]]];
            [[tmpTemplate imageProvider] setTintColor:[UIColor orangeColor]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianLarge: {
            CLKComplicationTemplateUtilitarianLargeFlat *tmpTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            [tmpTemplate setImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-alert"]]];
            [[tmpTemplate imageProvider] setTintColor:[UIColor orangeColor]];
            [tmpTemplate setTextProvider:[CLKTextProvider textProviderWithFormat:@"DELAYS"]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianSmall: {
            CLKComplicationTemplateUtilitarianSmallSquare *tmpTemplate = [[CLKComplicationTemplateUtilitarianSmallSquare alloc] init];
            [tmpTemplate setImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train-alert"]]];
            [[tmpTemplate imageProvider] setTintColor:[UIColor orangeColor]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianSmallFlat: {
            CLKComplicationTemplateUtilitarianSmallFlat *tmpTemplate = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            [tmpTemplate setTextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            rtnTemplate = tmpTemplate;
        }   break;
    }

    return rtnTemplate;
}

@end
